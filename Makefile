# === CONFIGURATION ===
ASM = nasm
LD = ld
ASMFLAGS = -f elf32
LDFLAGS = -m elf_i386

EXCLUDED = stdio32.asm window.asm math.asm

ASM_SOURCES := $(wildcard *.asm) $(wildcard *.s) $(wildcard *.as)
SOURCES := $(filter-out $(EXCLUDED), $(ASM_SOURCES))

OBJECTS := $(patsubst %.asm,%.o,$(patsubst %.s,%.o,$(patsubst %.as,%.o,$(SOURCES))))
BINARIES := $(patsubst %.asm,%,$(patsubst %.s,%,$(patsubst %.as,%,$(SOURCES))))

.SUFFIXES:
MAKEFLAGS += -rR

# Color codes for red text and reset
RED := \033[31m
RESET := \033[0m

all: $(BINARIES)

%: %.o
	@echo "🔗 Linking $< -> $@"
	@$(LD) $(LDFLAGS) -o $@ $< || { printf "$(RED)❌ Linking failed for %s$(RESET)\n" "$@"; exit 1; }

%.o: %.asm
	@echo "🛠️  Assembling $< -> $@"
	@$(ASM) $(ASMFLAGS) -o $@ $< || { printf "$(RED)❌ Assembly failed for %s$(RESET)\n" "$<"; exit 1; }

%.o: %.s
	@echo "🛠️  Assembling $< -> $@"
	@$(ASM) $(ASMFLAGS) -o $@ $< || { printf "$(RED)❌ Assembly failed for %s$(RESET)\n" "$<"; exit 1; }

%.o: %.as
	@echo "🛠️  Assembling $< -> $@"
	@$(ASM) $(ASMFLAGS) -o $@ $< || { printf "$(RED)❌ Assembly failed for %s$(RESET)\n" "$<"; exit 1; }

clean:
	@echo "🧹 Cleaning .o and binaries (excluding EXCLUDED files)..."
	@for src in $(SOURCES); do \
		base=$${src%.*}; \
		rm -f "$$base.o" "$$base"; \
	done

.PHONY: all clean
