.segment "CODE"

.export LoadGraphics, LoadPalette, LoadSpritelist
.export EnableDisplayAndNmi, EnableDisplay, EnableNmi, WaitNewFrame
.export DisableDisplay

.importzp ppu_mask_current, ppu_ctrl_current, main_yield

.include "include.mov-macros.asm"
.include "include.sys.asm"

.importzp pointer


;LoadGraphics
; Takes a pointer to nametable and attributes, of size $400, and loads it into
; PPU memory.
; @in x: Low byte of the pointer.
; @in y: Low byte of the pointer.
.proc LoadGraphics
  bit PPU_STATUS
  stx pointer+0
  sty pointer+1
  ldx #4
  ldy #0
  mov PPU_ADDR, #$20
  mov PPU_ADDR, #0
Loop:
  lda (pointer),y
  sta PPU_DATA
  iny
  bne Loop
  inc pointer+1
  dex
  bne Loop
  rts
.endproc


;LoadPalette
; Takes a pointer to a palette, of size $20, and loads it into PPU memory.
; @in x: Low byte of the pointer.
; @in y: Low byte of the pointer.
.proc LoadPalette
  bit PPU_STATUS
  stx pointer+0
  sty pointer+1
  lda #$3f
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR
  ldy #0
Loop:
  lda (pointer),y
  sta PPU_DATA
  iny
  cpy #$20
  bne Loop
  ldy #0
  lda (pointer),y
  sta PPU_DATA
  rts
.endproc


;LoadSpritelist
; Takes a pointer to a list of sprites, terminated by $ff, and loads it into
; the shadow OAM.
; @in x: Low byte of the pointer.
; @in y: Low byte of the pointer.
.proc LoadSpritelist
  stx pointer+0
  sty pointer+1
  ldy #0
Loop:
  lda (pointer),y
  cmp #$ff
  beq Done
  sta $200,y
  iny
  bne Loop
Done:
  rts
.endproc


;EnableDisplayAndNmi
; Enable PPU rendering and enable the NMI.
.proc EnableDisplayAndNmi
  lda #(PPU_CTRL_NMI_ENABLE | PPU_CTRL_SPRITE_1000)
  sta PPU_CTRL
  sta ppu_ctrl_current
  lda #(PPU_MASK_SHOW_SPRITES | PPU_MASK_SHOW_BG | PPU_MASK_NOCLIP_SPRITES | PPU_MASK_NOCLIP_BG)
  sta PPU_MASK
  sta ppu_mask_current
  cli
  rts
.endproc


;EnableNmi
; Enable the NMI, and disable everything else.
.proc EnableNmi
  lda #(PPU_CTRL_NMI_ENABLE | PPU_CTRL_SPRITE_1000)
  sta PPU_CTRL
  sta ppu_ctrl_current
  cli
  rts
.endproc


;WaitNewFrame
; Wait until the next NMI happens and is finished.
.proc WaitNewFrame
  mov main_yield, #0
WaitLoop:
  bit main_yield
  bpl WaitLoop
  mov main_yield, #0
  rts
.endproc


;EnableDisplay
; Enable PPU rendering, keeping other PPU settings the same.
.proc EnableDisplay
  lda ppu_mask_current
  ora #(PPU_MASK_SHOW_SPRITES | PPU_MASK_SHOW_BG)
  sta PPU_MASK
  sta ppu_mask_current
  rts
.endproc


;DisableDisplay
; Disable PPU rendering.
.proc DisableDisplay
  lda ppu_mask_current
  and #($ff & ~PPU_MASK_SHOW_SPRITES & ~PPU_MASK_SHOW_BG)
  sta PPU_MASK
  sta ppu_mask_current
  rts
.endproc
