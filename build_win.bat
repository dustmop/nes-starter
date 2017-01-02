ca65 main.asm -o build\main.o
ca65 gfx.asm -o build\gfx.o
ca65 read_controller.asm -o build\read_controller.o
ca65 prologue.asm -o build\prologue.o
ca65 vars.asm -o build\vars.o
ld65 -o starter.nes build\main.o build\gfx.o build\read_controller.o build\prologue.o build\vars.o -C link.cfg
