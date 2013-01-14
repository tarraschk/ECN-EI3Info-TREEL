#----------------------------------------------------------------------------*
#                                                                            *
# Do NOT edit this makefile with an editor which replace tabs by spaces !    *    
#                                                                            *
#----------------------------------------------------------------------------*
#  Check Monitor API directory exists                                        *
#----------------------------------------------------------------------------*

#ifneq (0, $(shell [ -d $(MONITOR_API_DIR_PATH) ] ; echo $$?))
#  $(error The API directory does not exist)
#else
# ifneq (0, $(shell [ -e $(MONITOR_API_DIR_PATH)/monitor-api.h ] ; echo $$?))
#   $(error The monitor-api.h file does not exist in the API directory)
# endif
#endif

#----------------------------------------------------------------------------*
#                                                                            *
#          Build directories                                                 *
#                                                                            *
#----------------------------------------------------------------------------*

include $(DEV_DIR)/makefiles/build-dirs-definition.mak

#----------------------------------------------------------------------------*

COMMON_C_CPP_OPTIONS :=
MAKE_ALL_TARGETS := $(BUILD_DIR)

#----------------------------------------------------------------------------*
#                                                                            *
#          Include development board definitions                             *
#                                                                            *
#----------------------------------------------------------------------------*

include $(DEV_DIR)/development-boards/$(DEVELOPMENT_BOARD).txt

#----------------------------------------------------------------------------*

include $(DEV_DIR)/microcontrollers/$(MICROCONTROLLER)-microcontroller.txt

#----------------------------------------------------------------------------*
#  Include monitor definitions                                               *
#----------------------------------------------------------------------------*

-include $(MONITOR_API_DIR_PATH)/monitor-features.mak

#----------------------------------------------------------------------------*
#  Include common definitions                                                *
#----------------------------------------------------------------------------*

include $(DEV_DIR)/makefiles/common-definitions.mak

#----------------------------------------------------------------------------*
#                                                                            *
#   LD Script that defines extension location in ROM                         *
#                                                                            *
#----------------------------------------------------------------------------*

ifdef ROM_ADDRESS
  ifndef EXTENSION_SIZE
    $(error Error:EXTENSION_SIZE not defined)
	else
    MAKE_ALL_TARGETS += $(BUILD_DIR)/location-in-rom.ld
  endif
endif

#----------------------------------------------------------------------------*

$(BUILD_DIR)/location-in-rom.ld:$(BUILD_DIR) $(DEV_DIR)/ld-scripts/location-in-rom.template.ld makefile.mak
	@echo "*** Building script file $@"
	$(SILENT_CHAR)sed "s:START_ADDRESS:$(ROM_ADDRESS):g" $< | \
sed "s@LENGTH@$(EXTENSION_SIZE)@g" > $@

#----------------------------------------------------------------------------*
#                                                                            *
#          Command files to handle                                           *
#                                                                            *
#----------------------------------------------------------------------------*

COMMAND_FILES_TO_BUILD := clean.command
COMMAND_FILES_TO_BUILD += 1-verbose-build.command
COMMAND_FILES_TO_BUILD += dump-hex.command
COMMAND_FILES_TO_BUILD += display-obj-size.command

ifdef SERIAL_DEFINITION
  ifneq ($(SERIAL_DEFINITION), )
    COMMAND_FILES_TO_BUILD += serial.command
  endif
endif

ifdef ROM_ADDRESS
  COMMAND_FILES_TO_BUILD += 2-run-openocd.command
  COMMAND_FILES_TO_BUILD += 2a-internal-flash-perform-programming.command
  COMMAND_FILES_TO_BUILD += 2a-internal-flash-erase-check.command
endif

#----------------------------------------------------------------------------*

MAKE_ALL_TARGETS += $(COMMAND_FILES_TO_BUILD)

#----------------------------------------------------------------------------*

COMMAND_FILES_TO_DELETE += clean.command
COMMAND_FILES_TO_DELETE += dump-hex.command
COMMAND_FILES_TO_DELETE += display-obj-size.command
COMMAND_FILES_TO_DELETE += 2-run-openocd.command
COMMAND_FILES_TO_DELETE += 2a-internal-flash-perform-programming.command
COMMAND_FILES_TO_DELETE += 2a-internal-flash-erase-check.command

#----------------------------------------------------------------------------*
#                                                                            *
#          GDB Scripts                                                       *
#                                                                            *
#----------------------------------------------------------------------------*

GDB_SCRIPT_FILES_TO_BUILD :=

ifdef ROM_ADDRESS
  GDB_SCRIPT_FILES_TO_BUILD += $(BUILD_DIR)/internal-flash-erase-check.gdb
  GDB_SCRIPT_FILES_TO_BUILD += $(BUILD_DIR)/internal-flash-perform-programming.gdb
endif

MAKE_ALL_TARGETS += $(GDB_SCRIPT_FILES_TO_BUILD)

#----------------------------------------------------------------------------*
#                                                                            *
#          Command file inference rule                                       *
#                                                                            *
#----------------------------------------------------------------------------*
# Define SERIAL_DEFINITION as an empty variable if not defined

ifndef SERIAL_DEFINITION
  SERIAL_DEFINITION :=
endif

#----------------------------------------------------------------------------*

%.command: $(DEV_DIR)/command-templates/%.command makefile.mak
	@echo "*** Building Command file $@"
	$(SILENT_CHAR)sed "s:OPENOCDSCRIPTDIR:$(DEV_DIR)/openocd-scripts:g" $< | \
sed "s@SERIALLINK@$(SERIAL_DEFINITION)@g" | \
sed "s:GDB_TOOL:$(GDB_TOOL):g" | \
sed "s:GNUARMPATH:$(GNU_ARM_PATH):g" | \
sed "s:USERPROGRAMNAME:$(EXTENSION_PROGRAM_NAME)-internal-flash:g" | \
sed "s:GDBDIR:$(BUILD_DIR):g" | \
sed "s:DEVELOPMENTBOARD:$(strip $(DEVELOPMENT_BOARD)):g" | \
sed "s:CRYSTALFREQUENCY:$(strip $(LPC22XX_CRYSTAL_FREQUENCY)):g" | \
sed "s:OBJECTFILELIST:$(OBJECTS):g" > $@
	$(SILENT_CHAR)chmod +x $@

#----------------------------------------------------------------------------*
#                                                                            *
#          GDB file inference rule                                           *
#                                                                            *
#----------------------------------------------------------------------------*

$(BUILD_DIR)/%.gdb: $(DEV_DIR)/gdb-script-templates/%.template.gdb
	@echo "*** Building '$@'"
	$(SILENT_CHAR)sed "s:INTERNAL_FLASH_TARGET:$(EXTENSION_PROGRAM_NAME)-internal-flash.hex:g" $< | \
sed "s:INTERNAL_RAM_TARGET:$(EXTENSION_PROGRAM_NAME)-internal-ram.srec:g" | \
sed "s:EXTERNAL_RAM_TARGET:$(EXTENSION_PROGRAM_NAME)-external-ram.srec:g" | \
sed "s:SOURCE_DIR_LIST:$(SOURCE_DIR):g" > $@

#----------------------------------------------------------------------------*
#                                                                            *
#          make all inference rule                                           *
#                                                                            *
#----------------------------------------------------------------------------*

OBJECTS := $(patsubst %, $(BUILD_DIR)/%.o, $(SOURCES))
ifdef SOURCES_THUMB
  OBJECTS += $(patsubst %, $(BUILD_DIR)/%.oo, $(SOURCES_THUMB))
endif

MAKE_ALL_TARGETS += $(OBJECTS)

MAKE_ALL_TARGETS += $(EXTENSION_PROGRAM_NAME)-ram.srec

ifdef ROM_ADDRESS
  MAKE_ALL_TARGETS += $(EXTENSION_PROGRAM_NAME)-internal-flash.hex
endif

all: $(MAKE_ALL_TARGETS)
	@echo "Success !"

#----------------------------------------------------------------------------*
#                                                                            *
#          make directory inference rules                                    *
#                                                                            *
#----------------------------------------------------------------------------*

$(BUILD_DIR):
	@echo "*** Making directory $@"
	$(SILENT_CHAR)mkdir $(BUILD_DIR)

#----------------------------------------------------------------------------*
#                                                                            *
#   link for external ram inference rule                                     *
#                                                                            *
#----------------------------------------------------------------------------*

LDSCRIPT_EXTERNAL_RAM := $(DEV_DIR)/ld-scripts/extension-in-external-ram.ld

LDFLAGS_EXTERNAL_RAM := $(COMMON_LD_FLAGS) -T$(LDSCRIPT_EXTERNAL_RAM)

$(EXTENSION_PROGRAM_NAME)-ram.srec: $(OBJECTS) $(LDSCRIPT_EXTERNAL_RAM)
	@echo "*** Linking $@"
	$(SILENT_CHAR)$(CC_TOOL) $(OBJECTS) $(LDFLAGS_EXTERNAL_RAM) -Wl,-Map=$@.map $(LIBS) -o $(EXTENSION_PROGRAM_NAME)-ram.elf
	$(SILENT_CHAR)$(OBJCOPY_TOOL) -O srec $(EXTENSION_PROGRAM_NAME)-ram.elf $(EXTENSION_PROGRAM_NAME)-ram.srec

#----------------------------------------------------------------------------*
#                                                                            *
#   link for rom inference rule                                              *
#                                                                            *
#----------------------------------------------------------------------------*

LDSCRIPT_ROM := $(DEV_DIR)/ld-scripts/extension-in-rom.ld

LDFLAGS_ROM := $(COMMON_LD_FLAGS) -T$(LDSCRIPT_ROM) -L $(BUILD_DIR)

%.elf: $(OBJECTS) $(LDSCRIPT_ROM)
	@echo "*** Linking $@"
	$(SILENT_CHAR)$(CC_TOOL) $(OBJECTS) $(LDFLAGS_ROM) -Wl,-Map=$@.map $(LIBS) -o $@

$(EXTENSION_PROGRAM_NAME)-internal-flash.hex: $(OBJECTS) $(LDSCRIPT_ROM)
	@echo "*** Linking $@"
	$(SILENT_CHAR)$(CC_TOOL) $(OBJECTS) $(LDFLAGS_ROM) -Wl,-Map=$@.map $(LIBS) -o $(EXTENSION_PROGRAM_NAME)-internal-flash.elf
	$(SILENT_CHAR)$(OBJCOPY_TOOL) -O ihex $(EXTENSION_PROGRAM_NAME)-internal-flash.elf $(EXTENSION_PROGRAM_NAME)-internal-flash.hex

#----------------------------------------------------------------------------*
#                                                                            *
#          clean goal                                                        *
#                                                                            *
#----------------------------------------------------------------------------*

clean:
	@echo "*** Cleaning..."
	$(SILENT_CHAR)rm -fr $(BUILD_DIR)
	$(SILENT_CHAR)rm -f $(COMMAND_FILES_TO_DELETE)
	$(SILENT_CHAR)rm -f *.srec *.map *.elf *.hex

#----------------------------------------------------------------------------*
#                                                                            *
#         Compiler invocation inference rules                                *
#                                                                            *
#----------------------------------------------------------------------------*

TEMP_SOURCE_DIRS := $(SOURCE_DIR)
include $(DEV_DIR)/makefiles/compiler-calls.mak

#----------------------------------------------------------------------------*
#                                                                            *
#          Weak include of dependency files                                  *
#         (should be the last of the makefile)                               *
#                                                                            *
#----------------------------------------------------------------------------*

-include $(BUILD_DIR)/*.dep

#----------------------------------------------------------------------------*
