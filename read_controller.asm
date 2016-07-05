.export ReadInputPort0, ReadInputPort1

.include "include.sys.asm"

.importzp buttons

.segment "CODE"


.proc ReadInputPort0
  ldy #1
  sty INPUT_PORT_0
  sty buttons
  dey
  sty INPUT_PORT_0
Loop:
  lda INPUT_PORT_0
  lsr a
  rol buttons
  lda INPUT_PORT_0
  lsr a
  rol buttons
  bcc Loop
Done:
  rts
.endproc


.proc ReadInputPort1
  ldy #1
  sty INPUT_PORT_0
  sty buttons
  dey
  sty INPUT_PORT_0
Loop:
  lda INPUT_PORT_1
  lsr a
  rol buttons
  lda INPUT_PORT_1
  lsr a
  rol buttons
  bcc Loop
Done:
  rts
.endproc
