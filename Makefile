default: starter.nes

clean:
	rm -rf .b/

SRC = main.asm \
      gfx.asm \
      read_controller.asm \
      prologue.asm \
      vars.asm

OBJ = $(patsubst %.asm,.b/%.o,$(SRC))

.b/%.o: %.asm
	mkdir -p .b/
	ca65 -o $@ $(patsubst .b/%.o, %.asm, $@) -g

.b/prologue.o: prologue.asm .b/image.chr.dat .b/image.graphics.dat \
               .b/image.palette.dat
	ca65 -o .b/prologue.o prologue.asm -g

.b/image.chr.dat .b/image.graphics.dat .b/image.palette.dat: image.png
	mkdir -p .b/
	makechr image.png -o .b/image.%s.dat -b 0f
	cat .b/image.nametable.dat .b/image.attribute.dat > \
            .b/image.graphics.dat

starter.nes: .b/image.chr.dat $(OBJ)
	ld65 -o starter.nes $(OBJ) -C link.cfg -Ln starter.ln
	python convertln.py starter.ln > starter.nes.0.nl
