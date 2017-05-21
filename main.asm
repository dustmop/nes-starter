.include "include.mov-macros.asm"
.include "include.sys.asm"
.include "gfx.h.asm"
.include "read_controller.h.asm"

.importzp bg_x_scroll, bg_y_scroll, main_yield, ppu_ctrl_current
.import palette, graphics, spritelist

.export RESET, NMI

.segment "CODE"

RESET:
  ; Stop interrupts from happening during initialization.
  sei
  ; Disable decimal mode.
  cld
  ; Disable IRQs from the APU.
  ldy #$40
  sty $4017
StackAndGraphics:
  ; Assign the stack to be empty.
  ldx #$ff
  txs
  ; Clear PPU registers.
  inx
  stx PPU_CTRL
  stx PPU_MASK
  ; Turn off audio.
  stx $4010
  stx $4015

  ; Wait for next frame.
Wait0:
  bit PPU_STATUS
  bpl Wait0

  ; Clear all RAM by assigning 0, except the shadow OAM, which is assigned $ff.
ClearMemory:
  ldx #0
:
  mov {$000,x}, #0
  sta $100,x
  sta $300,x
  sta $400,x
  sta $500,x
  sta $600,x
  sta $700,x
  mov {$200,x}, #$ff
  inx
  bne :-

  ; Wait for next frame. PPU needs 2 frames of time to startup.
Wait1:
  bit PPU_STATUS
  bpl Wait1

  ; Load palette, which is defined in the prologue.
  ldx #<palette
  ldy #>palette
  jsr LoadPalette

  ; Load nametable and attributes, which are defined in the prologue.
  ldx #<graphics
  ldy #>graphics
  jsr LoadGraphics

  ; Load spritelist, which is defined in the prologue.
  ldx #<spritelist
  ldy #>spritelist
  jsr LoadSpritelist

  ; Turn on the nmi, then wait for the next frame before enabling the display.
  ; This prevents a partially rendered frame from appearing at start-up.
  jsr EnableNmi
  jsr WaitNewFrame
  jsr EnableDisplayAndNmi

ForeverLoop:
  ; Wait for the next frame to start.
  jsr WaitNewFrame
  ; Read controller, but don't do anything with it.
  jsr ReadInputPort0

  jmp ForeverLoop


NMI:
  ; Preserve registers.
  pha
  txa
  pha
  tya
  pha
  ; Yield to next frame.
  mov main_yield, #$ff
  ; DMA sprites.
  mov OAM_ADDR, #$00
  mov OAM_DMA, #$02
  ; Reset ppu pointer.
  lda #0
  sta PPU_ADDR
  sta PPU_ADDR
  ; Assign the scroll.
  lda bg_x_scroll
  sta PPU_SCROLL
  lda bg_y_scroll
  sta PPU_SCROLL
  ; Assign ppu control.
  lda ppu_ctrl_current
  sta PPU_CTRL
  ; Restore registers.
  pla
  tay
  pla
  tax
  pla
  rti
