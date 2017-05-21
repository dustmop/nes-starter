default: starter.nes

clean:
	rm -rf build/

SRC = main.asm \
      gfx.asm \
      read_controller.asm \
      prologue.asm \
      vars.asm

OBJ = $(patsubst %.asm,build/%.o,$(SRC))

build/%.o: %.asm
	mkdir -p build/
	ca65 -o $@ $(patsubst build/%.o, %.asm, $@) -g

build/prologue.o: prologue.asm build/image.chr.dat build/image.graphics.dat \
               build/image.palette.dat
	ca65 -o build/prologue.o prologue.asm -g

build/image.chr.dat build/image.graphics.dat build/image.palette.dat: image.png
	mkdir -p build/
	makechr image.png -o build/image.%s.dat -b 0f
	cat build/image.nametable.dat build/image.attribute.dat > \
            build/image.graphics.dat

starter.nes: build/image.chr.dat $(OBJ)
	ld65 -o starter.nes $(OBJ) -C link.cfg -Ln starter.ln
	python convertln.py starter.ln > starter.nes.0.nl
