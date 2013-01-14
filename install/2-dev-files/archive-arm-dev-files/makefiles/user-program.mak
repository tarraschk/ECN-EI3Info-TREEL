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
# ifneq (0, $(shell [ -e $(MONITOR_API_DIR_PATH)/api.h ] ; echo $$?))
#   $(error The api.h file does not exist in the API directory)
# endif
#endif

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
#                                                                            *
#          Build directories                                                 *
#                                                                            *
#----------------------------------------------------------------------------*

include $(DEV_DIR)/makefiles/build-dirs-definition.mak

#----------------------------------------------------------------------------*
#  Include monitor definitions                                               *
#----------------------------------------------------------------------------*

-include $(MONITOR_API_DIR_PATH)/monitor-features.mak

#----------------------------------------------------------------------------*
#  Include common definitions                                                *
#----------------------------------------------------------------------------*

include $(DEV_DIR)/makefiles/common-definitions.mak

#----------------------------------------------------------------------------*
# Kind of serial link needed by this project                                 *
# MONITOR_SERIAL_LINK is defined by $(MONITOR_API_DIR_PATH)/monitor-features.mak *
#----------------------------------------------------------------------------*

SERIAL_DEFINITION := $(MONITOR_SERIAL_LINK)

#---------------------------------------------------------------*
#                                                               *
#          Define LD script                                     *
#                                                               *
#---------------------------------------------------------------*

LDSCRIPT_EXTERNAL_RAM := $(DEV_DIR)/ld-scripts/user_program_in_external_ram.ld

#---------------------------------------------------------------*
#                                                               *
#          Command files to handle                              *
#                                                               *
#---------------------------------------------------------------*

COMMAND_FILES_TO_BUILD := clean.command
COMMAND_FILES_TO_BUILD += 1-verbose-build.command
COMMAND_FILES_TO_BUILD += 1-build-as.command
COMMAND_FILES_TO_BUILD += dump-hex.command
COMMAND_FILES_TO_BUILD += display-obj-size.command

ifdef SERIAL_DEFINITION
  ifneq ($(SERIAL_DEFINITION), )
    COMMAND_FILES_TO_BUILD += serial.command
  endif
endif

#---------------------------------------------------------------*

COMMAND_FILES_TO_DELETE += clean.command
COMMAND_FILES_TO_DELETE += dump-hex.command
COMMAND_FILES_TO_DELETE += display-obj-size.command

#---------------------------------------------------------------*
#                                                               *
#          Command file inference rule                          *
#                                                               *
#---------------------------------------------------------------*
# Define SERIAL_DEFINITION as an empty variable if not defined

ifndef SERIAL_DEFINITION
  SERIAL_DEFINITION :=
endif

#---------------------------------------------------------------*

%.command: $(DEV_DIR)/command-templates/%.command makefile.mak
	@echo "*** Building Command file $@"
	$(SILENT_CHAR)sed "s:OPENOCDSCRIPTDIR:$(DEV_DIR)/openocd-scripts:g" $< | \
sed "s@SERIALLINK@$(SERIAL_DEFINITION)@g" | \
sed "s:GNUARMPATH:$(GNU_ARM_PATH):g" | \
sed "s:USERPROGRAMNAME:$(USER_PROGRAM_NAME):g" | \
sed "s:DEVELOPMENTBOARD:$(strip $(DEVELOPMENT_BOARD)):g" | \
sed "s:CRYSTALFREQUENCY:$(strip $(LPC22XX_CRYSTAL_FREQUENCY)):g" | \
sed "s:OBJECTFILELIST:$(OBJECTS):g" > $@
	$(SILENT_CHAR)chmod +x $@

#---------------------------------------------------------------*
#                                                               *
#          make all inference rule                              *
#                                                               *
#---------------------------------------------------------------*

OBJECTS := $(patsubst %, $(BUILD_DIR)/%.o, $(SOURCES))
ifdef SOURCES_THUMB
  OBJECTS += $(patsubst %, $(BUILD_DIR)/%.oo, $(SOURCES_THUMB))
endif

MAKE_ALL_TARGETS += $(COMMAND_FILES_TO_BUILD)
MAKE_ALL_TARGETS += $(OBJECTS)

ifneq ($(LDSCRIPT_EXTERNAL_RAM), )
  MAKE_ALL_TARGETS += $(USER_PROGRAM_NAME).srec
endif

all: $(MAKE_ALL_TARGETS)
	@echo "Success !"

#----------------------------------------------------------------------------*
#                                                                            *
#          "as" goal                                                         *
#                                                                            *
#----------------------------------------------------------------------------*

OBJECTS_AS := $(patsubst %, $(AS_BUILD_DIR)/%.s, $(SOURCES))
ifdef SOURCES_THUMB
  OBJECTS_AS += $(patsubst %, $(AS_BUILD_DIR)/%.os, $(SOURCES_THUMB))
endif

#----------------------------------------------------------------------------*

$(AS_BUILD_DIR):
	@echo "*** Making directory: $@"
	$(SILENT_CHAR)mkdir $(AS_BUILD_DIR)

#----------------------------------------------------------------------------*

as:$(AS_BUILD_DIR) $(OBJECTS_AS)
	@echo "Success !"

#---------------------------------------------------------------*
#                                                               *
#          make directory inference rules                       *
#                                                               *
#---------------------------------------------------------------*

$(BUILD_DIR):
	@echo "*** Making directory $@"
	$(SILENT_CHAR)mkdir $(BUILD_DIR)

#---------------------------------------------------------------*
#                                                               *
#          link inference rules                                 *
#                                                               *
#---------------------------------------------------------------*

LDFLAGS_EXTERNAL_RAM := $(COMMON_LD_FLAGS) -T$(LDSCRIPT_EXTERNAL_RAM)

%.srec: $(OBJECTS) $(LDSCRIPT_EXTERNAL_RAM)
	@echo "*** Linking $@"
	$(SILENT_CHAR)$(LD_TOOL) $(OBJECTS) $(LDFLAGS_EXTERNAL_RAM) -Map=$@.map $(LIBS) -o temp.elf
	$(SILENT_CHAR)$(OBJCOPY_TOOL) -O srec temp.elf $@
	$(SILENT_CHAR)rm -f temp.elf

#---------------------------------------------------------------*
#                                                               *
#          clean goal                                           *
#                                                               *
#---------------------------------------------------------------*

clean:
	@echo "*** Cleaning..."
	$(SILENT_CHAR)rm -fr $(AS_BUILD_DIR)
	$(SILENT_CHAR)rm -fr $(BUILD_DIR)
	$(SILENT_CHAR)rm -f $(COMMAND_FILES_TO_DELETE)
	$(SILENT_CHAR)rm -f *.srec *.map

#---------------------------------------------------------------*
#                                                               *
#         Compiler invocation inference rules                   *
#                                                               *
#---------------------------------------------------------------*

TEMP_SOURCE_DIRS := $(SOURCE_DIR)
include $(DEV_DIR)/makefiles/compiler-calls.mak

#---------------------------------------------------------------*
#                                                               *
#          Weak include of dependency files                     *
#         (should be the last of the makefile)                  *
#                                                               *
#---------------------------------------------------------------*

-include $(BUILD_DIR)/*.dep

#---------------------------------------------------------------*
