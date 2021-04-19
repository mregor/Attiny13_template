# Название проекта.
# Имя основного С-файла без расширения, пример для 'project1.c': 'project1'.
PROJECT = main

# Тип чипа для AVR GCC и частота ядра. 
# https://gcc.gnu.org/onlinedocs/gcc/AVR-Options.html
GCC_MCU = avr25
CLOCK_HZ   = 1200000

# Опции для AVRDUDE.
# https://ph0en1x.net/77-avrdude-full-howto-samples-options-gui-linux.html
AVRDUDE_MCU             = t13
AVRDUDE_PROGRAMMER      = usbasp
AVRDUDE_PROGRAMMER_PORT = /dev/ttyUSB0

# Fuses
FUSE_L = 0x6a
FUSE_H = 0xff
FUSE_E = 0xff

# Список дополнительных C-файлов для компиляции (указывать через пробел).
C_FILES = src/main.c


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CFLAGS        = -g -Os -Wall -mcall-prologues -std=c99 -mmcu=$(GCC_MCU) -DF_CPU=$(CLOCK_HZ)UL
FUSES         = -U lfuse:w:$(FUSE_L):m -U hfuse:w:$(FUSE_H):m -U efuse:w:$(FUSE_E):m
FLASH         = -U flash:w:$(PROJECT).hex

AVR_GCC       = `which avr-gcc`
AVR_OBJCOPY   = `which avr-objcopy`
AVR_SIZE      = `which avr-size`
AVR_OBJDUMP   = `which avr-objdump`
AVRDUDE       = `which avrdude`
REMOVE        = `which rm`
NANO          = `which nano`
TAR           = `which tar`
DATETIME      = `date +"%d-%m-%Y"`

AVRDUDE_CMD   = $(AVRDUDE) -p $(AVRDUDE_MCU) -c $(AVRDUDE_PROGRAMMER) -P $(AVRDUDE_PROGRAMMER_PORT) -v

%.elf: %.c
	$(AVR_GCC) $(CFLAGS) $< $(C_FILES) -o $@

%.hex: %.elf
	$(AVR_OBJCOPY) -R .eeprom -O ihex $< $@

all: clean elf hex

program: $(PROJECT).hex
	$(AVRDUDE_CMD) $(FLASH)

fuses:
	$(AVRDUDE_CMD) $(FUSES)

elf: $(PROJECT).elf

hex: $(PROJECT).hex

size: $(PROJECT).elf
	$(AVR_SIZE) $(PROJECT).elf

disasm: $(PROJECT).elf
	$(AVR_OBJDUMP) -d $(PROJECT).elf

clean:
	$(REMOVE) -f *.hex *.elf *.o

edit:
	$(NANO) $(PROJECT).c

tar:
	$(TAR) -zcf $(PROJECT)_$(DATETIME).tgz ./* 