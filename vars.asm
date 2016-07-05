.segment "ZEROPAGE" : zeropage

main_yield: .byte 0
ppu_ctrl_current: .byte 0
ppu_mask_current: .byte 0
bg_x_scroll: .byte 0
bg_y_scroll: .byte 0
buttons: .byte 0
pointer: .word 0

.exportzp main_yield, ppu_ctrl_current, ppu_mask_current
.exportzp bg_x_scroll, bg_y_scroll, buttons
.exportzp pointer
