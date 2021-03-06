F_CPU = 20000000UL
SAMPLE_LEN = 32
MCU = atmega32

CC = avr-gcc
CFLAGS = -Wall -Os

all: clean force bin/synth.elf
	
bin/synth.elf: src/synth.c src/osc.c src/modulation.c src/envelope.c src/midi.c src/com.c src/notes.c
	$(CC) $(CFLAGS) -DSAMPLE_LEN=$(SAMPLE_LEN) -DF_CPU=$(F_CPU) -DNOTE_LIM=$(NOTE_LIM) -mmcu=$(MCU) $^ -o $@
	avr-size -C $@ --mcu=$(MCU)
	
force:
	-mkdir bin

clean:
	-rm -rf bin
	
prog: bin/synth.elf
	avrdude -c usbasp -p m32 -U flash:w:$^
