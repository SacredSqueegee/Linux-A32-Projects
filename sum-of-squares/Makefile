# Makefile for ARM Assembly Project

# If using gef (1) then define debug as sudo gdb so gef is not used
# and define a target specifically for gef
USING_GEF = 1

#
# Compiler and tools
# ==============================================================================
GDB = gdb-multiarch
AS = arm-none-linux-gnueabihf-as
LD = arm-none-linux-gnueabihf-ld
OBJCOPY = arm-none-linux-gnueabihf-objcopy
QEMU = qemu-arm

#
# Flags for various tools
# ==============================================================================
GDB_FLAGS = -ex 'target remote localhost:4242' \
			-ex 'set disassemble-next-line on' \
			-ex 'layout next' \
			-ex 'layout next' \
			-ex 'layout next' \
			-ex 'layout next'

GDB_SERVER_FLAGS = 	-ex 'gef-remote localhost 4242' \
					-ex 'set disassemble-next-line on'

AS_FLAGS = -gdwarf-2 --gen-debug --warn --fatal-warnings
LD_FLAGS = -static -nostdlib

#
# Directories
# ==============================================================================
SRC_DIR = src
LST_DIR = lst
BIN_DIR = bin
INCLUDE_DIR = include
MACRO_DIR = macros

#
# Output binary
# ==============================================================================
TARGET = $(BIN_DIR)/main

#
# Source files
# ==============================================================================
SRC = $(wildcard $(SRC_DIR)/*.s)

#
# Object files
# ==============================================================================
OBJ = $(SRC:$(SRC_DIR)/%.s=$(BIN_DIR)/%.o)

#
# Ensure directories exist
# ==============================================================================
$(shell mkdir -p $(BIN_DIR))
$(shell mkdir -p $(LST_DIR))

#
# Default rule
# ==============================================================================
all: $(TARGET)

#
# Linking
# ==============================================================================
$(TARGET): $(OBJ)
	$(LD) $(LD_FLAGS) -o $@ $^

#
# Assembling
# ==============================================================================
$(BIN_DIR)/%.o: $(SRC_DIR)/%.s
	$(AS) $(AS_FLAGS) -I$(INCLUDE_DIR) -I$(MACRO_DIR) -aghlms=$(LST_DIR)/$*.lst -o $@ $<

#
# Clean rule
# ==============================================================================
clean:
	rm -f $(BIN_DIR)/*
	rm -f $(LST_DIR)/*

#
# Run rule
# ==============================================================================
run: clean $(TARGET)
	@$(QEMU) $(TARGET)

#
# Debug rules
# ==============================================================================
ifeq ($(USING_GEF), 1)
debug:
	sudo $(GDB) $(GDB_FLAGS)

gef:
	$(GDB) $(GDB_FLAGS)

else
debug:
	$(GDB) $(GDB_FLAGS)

endif

debug_server: clean all
	qemu-arm -g 4242 $(TARGET)

.PHONY: all clean run debug gef debug_server

