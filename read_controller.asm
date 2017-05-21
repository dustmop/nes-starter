.export ReadInputPort0, ReadInputPort1

.include "include.sys.asm"

.importzp buttons

.segment "CODE"


;ReadInputPort1
; Read the state of the input port #0.
; @out buttons: State of each button.
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


;ReadInputPort1
; Read the state of the input port #1.
; @out buttons: State of each button.
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
