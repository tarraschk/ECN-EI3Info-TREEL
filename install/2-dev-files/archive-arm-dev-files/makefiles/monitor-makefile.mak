#----------------------------------------------------------------------------*
#                                                                            *
# Do NOT edit this makefile with an editor which replaces tabs by spaces !   *    
#                                                                            *
#----------------------------------------------------------------------------*

# http://makepp.sourceforge.net/1.19/makepp_statements.html
# http://gpwiki.org/index.php/Makefile

#----------------------------------------------------------------------------*
# SOURCES is the list that contains all source files to be compiled into     *
# 32-bit code (without any directory reference)                              *
#----------------------------------------------------------------------------*

SOURCES :=

#----------------------------------------------------------------------------*
# SOURCES is the list that contains all source files to be compiled into     *
# Thumb code (without any directory reference)                               *
#----------------------------------------------------------------------------*

SOURCES_THUMB :=

#----------------------------------------------------------------------------*
# API is the list of header files that declare routines available to user    *
# programs (without any directory reference)                                 *
#----------------------------------------------------------------------------*

API :=

#----------------------------------------------------------------------------*
# API_LATEX is the list of latex files that describe routines available to   *
# user programs (without any directory reference)                            *
#----------------------------------------------------------------------------*

API_LATEX :=

#----------------------------------------------------------------------------*
# DISPATCHER is the list of header files (without any directory reference)   *
# that declare routines available with both an 'usr_' and a 'kernel_' prefix.*
#----------------------------------------------------------------------------*

DISPATCHER :=

#----------------------------------------------------------------------------*
# DOC_COMMAND_LATEX is the list of tex files that contain the descriptor of  *
# shell commands.                                                            *
#----------------------------------------------------------------------------*

DOC_COMMAND_LATEX :=

#----------------------------------------------------------------------------*
# DESCRIPTOR_FILES is the list of descriptor files                           *
#----------------------------------------------------------------------------*

ifndef DESCRIPTOR_FILES_NO_API
  $(error Error: DESCRIPTOR_FILES_NO_API variable is not defined)
endif

ifndef DESCRIPTOR_FILES_USE_API
  $(error Error: DESCRIPTOR_FILES_USE_API variable is not defined)
endif

include $(DESCRIPTOR_FILES_NO_API)

API := # Reset API setting so that API files of DESCRIPTOR_FILES_NO_API are ignored
MONITOR_API_LATEX := $(API_LATEX) # Get monitor API

API_LATEX := # Reset API setting so that API_LATEX files of DESCRIPTOR_FILES_NO_API are ignored

include $(DESCRIPTOR_FILES_USE_API)

SOURCE_DIR := $(sort $(dir $(DESCRIPTOR_FILES_NO_API) $(DESCRIPTOR_FILES_USE_API)))

MONITOR_API_LATEX_FULL_PATHS := $(foreach FILE, $(MONITOR_API_LATEX), $(shell find $(SOURCE_DIR) -name $(FILE)))

USER_API_LATEX_FULL_PATHS := $(foreach FILE, $(API_LATEX), $(shell find $(SOURCE_DIR) -name $(FILE)))

DISPATCHER_FULL_PATHS := $(foreach FILE, $(DISPATCHER), $(shell find $(SOURCE_DIR) -name $(FILE)))

MONITOR_COMMANDS_LATEX_FULL_PATHS := $(foreach FILE, $(DOC_COMMAND_LATEX), $(shell find $(SOURCE_DIR) -name $(FILE)))

API_FULL_PATHS := $(foreach FILE, $(API), $(shell find $(SOURCE_DIR) -name $(FILE)))

#----------------------------------------------------------------------------*
#                                                                            *
#          Build directories                                                 *
#                                                                            *
#----------------------------------------------------------------------------*

include $(DEV_DIR)/makefiles/build-dirs-definition.mak

#----------------------------------------------------------------------------*
#                                                                            *
#          Check VIRTUAL_PROCESSOR_COUNT variable is defined                 *
#  Should be 1 for a regular (single core processor) monitor                 *
#  Is > 1 for a multi-core simulator monitor                                 *
#                                                                            *
#----------------------------------------------------------------------------*

ifndef VIRTUAL_PROCESSOR_COUNT
  $(error Error: VIRTUAL_PROCESSOR_COUNT variable is not defined)
endif

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
#          Build script file for linking in internal ram                     *
#                                                                            *
#----------------------------------------------------------------------------*

LDSCRIPT_INTERNAL_RAM :=
ifdef LINK_FOR_INTERNAL_RAM
  ifeq ($(LINK_FOR_INTERNAL_RAM), yes)
    LDSCRIPT_INTERNAL_RAM := $(BUILD_DIR)/linker-script-for-internal-ram.ld
    $(shell mkdir -p $(BUILD_DIR))
    $(shell sed "s/INTERNAL_RAM_SIZE/$(INTERNAL_RAM_SIZE)/g" $(DEV_DIR)/ld-scripts/monitor-internal-ram.template.ld > $(LDSCRIPT_INTERNAL_RAM))
  endif
endif

#----------------------------------------------------------------------------*
#                                                                            *
#          Build script file for linking in internal flash                   *
#                                                                            *
#----------------------------------------------------------------------------*

LDSCRIPT_INTERNAL_FLASH :=
ifdef LINK_FOR_INTERNAL_FLASH
  ifeq ($(LINK_FOR_INTERNAL_FLASH), yes)
    LDSCRIPT_INTERNAL_FLASH := $(BUILD_DIR)/linker-script-for-internal-flash.ld
    $(shell mkdir -p $(BUILD_DIR))
    $(shell sed "s/INTERNAL_RAM_SIZE/$(INTERNAL_RAM_SIZE)/g" $(DEV_DIR)/ld-scripts/monitor-internal-flash.template.ld > $(BUILD_DIR)/temp)
    $(shell sed "s/INTERNAL_FLASH_SIZE/$(INTERNAL_FLASH_SIZE)/g" $(BUILD_DIR)/temp > $(BUILD_DIR)/temp2)
    $(shell sed "s/EXTERNAL_RAM_ADDRESS/$(EXTERNAL_RAM_ADDRESS)/g" $(BUILD_DIR)/temp2 > $(BUILD_DIR)/temp)
    $(shell sed "s/EXTERNAL_RAM_SIZE/$(EXTERNAL_RAM_SIZE)/g" $(BUILD_DIR)/temp > $(LDSCRIPT_INTERNAL_FLASH))
    $(shell rm $(BUILD_DIR)/temp $(BUILD_DIR)/temp2)
  endif
endif

#----------------------------------------------------------------------------*
#                                                                            *
#          Build script file for linking in external ram                     *
#                                                                            *
#----------------------------------------------------------------------------*

LDSCRIPT_EXTERNAL_RAM :=
ifdef LINK_FOR_EXTERNAL_RAM
  ifeq ($(LINK_FOR_EXTERNAL_RAM), yes)
    LDSCRIPT_EXTERNAL_RAM := $(BUILD_DIR)/linker-script-for-external-ram.ld
    $(shell mkdir -p $(BUILD_DIR))
    $(shell sed "s/INTERNAL_RAM_SIZE/$(INTERNAL_RAM_SIZE)/g" $(DEV_DIR)/ld-scripts/monitor-external-ram.template.ld > $(BUILD_DIR)/temp)
    $(shell sed "s/EXTERNAL_RAM_ADDRESS/$(EXTERNAL_RAM_ADDRESS)/g" $(BUILD_DIR)/temp > $(BUILD_DIR)/temp2)
    $(shell sed "s/EXTERNAL_RAM_SIZE/$(EXTERNAL_RAM_SIZE)/g" $(BUILD_DIR)/temp2 > $(LDSCRIPT_EXTERNAL_RAM))
    $(shell rm $(BUILD_DIR)/temp $(BUILD_DIR)/temp2)
	endif
endif

#----------------------------------------------------------------------------*
#                                                                            *
#          XTR_CLASS handling                                                *
#                                                                            *
#----------------------------------------------------------------------------*

ifdef XTR_CLASS
 ifeq ($(XTR_CLASS), 0)
  COMMON_C_CPP_OPTIONS += -DXTR_CLASS=0
 else
  ifeq ($(XTR_CLASS), 1)
   COMMON_C_CPP_OPTIONS += -DXTR_CLASS=1
  else
   ifeq ($(XTR_CLASS), 2)
    COMMON_C_CPP_OPTIONS += -DXTR_CLASS=2
   else
    $(error Error: XTR_CLASS is equal to $(XTR_CLASS), but it should be 0, 1 or 2)
   endif
  endif
 endif
else # XTR_CLASS is not defined
  XTR_CLASS := 0
  COMMON_C_CPP_OPTIONS += -DXTR_CLASS=0
endif
COMMON_C_CPP_OPTIONS += -DVIRTUAL_PROCESSOR_COUNT=$(VIRTUAL_PROCESSOR_COUNT)

#----------------------------------------------------------------------------*
#                                                                            *
#          XTR_TASK_STATE_OBSERVER handling                                  *
#                                                                            *
#----------------------------------------------------------------------------*

ifdef XTR_TASK_STATE_OBSERVER
 ifeq ($(XTR_TASK_STATE_OBSERVER), 0)
  COMMON_C_CPP_OPTIONS += -DXTR_TASK_STATE_OBSERVER=0
 else
  ifeq ($(XTR_TASK_STATE_OBSERVER), 1)
   COMMON_C_CPP_OPTIONS += -DXTR_TASK_STATE_OBSERVER=1
  else
   $(error Error: XTR_TASK_STATE_OBSERVER is equal to $(XTR_TASK_STATE_OBSERVER), but it should be 0 or 1)
  endif
 endif
else # XTR_TASK_STATE_OBSERVER is not defined
  XTR_TASK_STATE_OBSERVER := 0
  COMMON_C_CPP_OPTIONS += -DXTR_TASK_STATE_OBSERVER=0
endif

#----------------------------------------------------------------------------*

include $(DEV_DIR)/makefiles/common-definitions.mak

#----------------------------------------------------------------------------*
#                                                                            *
#          build latex documentation inference rule                          *
#                                                                            *
#----------------------------------------------------------------------------*

DOCUMENTATION_FILE := monitor_documentation.pdf
MAKE_ALL_TARGETS += $(DOCUMENTATION_FILE)
TEMP_LATEX := Z_LATEX_BUILD

# http://stackoverflow.com/questions/2369314/why-does-sed-require-3-backslashes-for-a-regular-backslash
INCLUDE_USER_API_LATEX_INSTRUCTIONS := $(patsubst %, \\\input{%}, $(USER_API_LATEX_FULL_PATHS))

INCLUDE_MONITOR_API_LATEX_INSTRUCTIONS := $(patsubst %, \\\input{%}, $(MONITOR_API_LATEX_FULL_PATHS))

INCLUDE_MONITOR_COMMANDS_LATEX_INSTRUCTIONS := $(patsubst %, \\\input{%}, $(MONITOR_COMMANDS_LATEX_FULL_PATHS))

#----------------------------------------------------------------------------*

$(DOCUMENTATION_FILE):$(USER_API_LATEX_FULL_PATHS) makefile.mak $(DEV_DIR)/makefiles/monitor-makefile.mak
	@echo "*** Making monitor documentation"
	$(SILENT_CHAR)rm -fr $(TEMP_LATEX)
	$(SILENT_CHAR)mkdir $(TEMP_LATEX)
	$(SILENT_CHAR)cp $(DEV_DIR)/doc-in-latex/* $(TEMP_LATEX)
	$(SILENT_CHAR)sed "s:USER_API_SOURCE_FILE_LIST:$(INCLUDE_USER_API_LATEX_INSTRUCTIONS):g" $(DEV_DIR)/doc-in-latex/monitor_documentation.tex | \
sed "s:MONITOR_API_SOURCE_FILE_LIST:$(INCLUDE_MONITOR_API_LATEX_INSTRUCTIONS):g"| \
sed "s:MONITOR_COMMAND_LIST:$(INCLUDE_MONITOR_COMMANDS_LATEX_INSTRUCTIONS):g" > $(TEMP_LATEX)/monitor_documentation.tex
	$(SILENT_CHAR)$(TEMP_LATEX)/build.command 1> /dev/null
	$(SILENT_CHAR)cp $(TEMP_LATEX)/monitor_documentation.pdf $(DOCUMENTATION_FILE)  

#----------------------------------------------------------------------------*
#                                                                            *
#          build dispatcher file and inference rule                          *
#                                                                            *
#----------------------------------------------------------------------------*

DISPATCHER_SOURCE_FILE := monitor-dispatcher-definition.s

#----------------------------------------------------------------------------*

ifdef DISPATCHER
  SOURCES += $(DISPATCHER_SOURCE_FILE)
else
  DISPATCHER :=
endif

#----------------------------------------------------------------------------*

MAKE_DISPATCHER_TARGET := $(BUILD_DIR)/$(DISPATCHER_SOURCE_FILE)

#----------------------------------------------------------------------------*

MAKE_DISPATCHER_ARGUMENTS := output-file:$(MAKE_DISPATCHER_TARGET)
MAKE_DISPATCHER_ARGUMENTS += processor:arm7tdmi
#ifdef XTR_CLASS
  MAKE_DISPATCHER_ARGUMENTS += defined-variable:XTR_CLASS=$(XTR_CLASS)
#endif
#ifdef XTR_TASK_STATE_OBSERVER
  MAKE_DISPATCHER_ARGUMENTS += defined-variable:XTR_TASK_STATE_OBSERVER=$(XTR_TASK_STATE_OBSERVER)
#endif
MAKE_DISPATCHER_ARGUMENTS += generate-dependency-file:$(BUILD_DIR)/make-dispatcher-dependencies.dep
MAKE_DISPATCHER_ARGUMENTS += $(patsubst %, source-header:%, $(DISPATCHER_FULL_PATHS))

#----------------------------------------------------------------------------*

$(MAKE_DISPATCHER_TARGET):$(DISPATCHER_FULL_PATHS)
	@echo "*** Making monitor dispatcher"
	$(SILENT_CHAR)/usr/local/dev-arm/arm-tools/bin/make-dispatcher $(MAKE_DISPATCHER_ARGUMENTS)  

#----------------------------------------------------------------------------*
#                                                                            *
#          build api definitions and inference rule                          *
#                                                                            *
#----------------------------------------------------------------------------*

ifdef API
  BUILD_API := 1
  SOURCES += monitor-api-definition.s
else
  API :=
  BUILD_API := 0
endif

#----------------------------------------------------------------------------*

API_DIR := api

#----------------------------------------------------------------------------*

MAKE_API_ARGUMENTS := api-spec-for-monitor:$(BUILD_DIR)/monitor-api-definition.s
ifdef SOURCES_THUMB
  MAKE_API_ARGUMENTS += processor:arm7-thumb-interwork
else
  MAKE_API_ARGUMENTS += processor:arm7
endif
MAKE_API_ARGUMENTS += serial-definition:$(SERIAL_DEFINITION)
MAKE_API_ARGUMENTS += api-spec-for-user-program:monitor-api-for-user-program.s
MAKE_API_ARGUMENTS += monitor-api-resulting-header:monitor-api.h
MAKE_API_ARGUMENTS += api-in-html:monitor-api.html
MAKE_API_ARGUMENTS += entry-point-base-address:+40000040
MAKE_API_ARGUMENTS += api-target-dir:$(API_DIR)
MAKE_API_ARGUMENTS += api-auxiliary-makefile:monitor-features.mak
ifdef XTR_CLASS
  MAKE_API_ARGUMENTS += defined-variable:XTR_CLASS=$(XTR_CLASS)
endif
ifdef XTR_TASK_STATE_OBSERVER
  MAKE_API_ARGUMENTS += defined-variable:XTR_TASK_STATE_OBSERVER=$(XTR_TASK_STATE_OBSERVER)
endif
MAKE_API_ARGUMENTS += generate-dependency-file:$(BUILD_DIR)/make-api-dependencies.dep
MAKE_API_ARGUMENTS += $(patsubst %, api-source-header:%, $(API))
MAKE_API_ARGUMENTS += $(patsubst %, source-header-dir:%, $(SOURCE_DIR))

#----------------------------------------------------------------------------*

MAKE_API_TARGET := $(BUILD_DIR)/monitor-api-definition.s

MAKE_API_SUB_TARGETS := $(API_DIR)/monitor-api-for-user-program.s
MAKE_API_SUB_TARGETS += $(API_DIR)/monitor-features.mak
MAKE_API_SUB_TARGETS += $(patsubst %, $(API_DIR)/%, $(API))

#----------------------------------------------------------------------------*

$(MAKE_API_SUB_TARGETS):$(MAKE_API_TARGET)

#----------------------------------------------------------------------------*

$(MAKE_API_TARGET):$(API_DIR) $(API_FULL_PATHS)
	@echo "*** Making monitor API"
	$(SILENT_CHAR)/usr/local/dev-arm/arm-tools/bin/make-api $(MAKE_API_ARGUMENTS)  

#----------------------------------------------------------------------------*
#   Assembler inference rule for generated assembly files                    *
#----------------------------------------------------------------------------*

$(BUILD_DIR)/%.s.o:$(BUILD_DIR)/%.s makefile.mak
	@echo "*** Assembling $<"
	$(SILENT_CHAR)$(AS_TOOL) $(ASFLAGS) --MD $@.dep $< -o $@

$(AS_BUILD_DIR)/%.s.s:$(BUILD_DIR)/%.s makefile.mak
	@echo "*** Copying $< -> s"
	$(SILENT_CHAR)cp $< $@

#----------------------------------------------------------------------------*
#                                                                            *
#          Command files to handle                                           *
#                                                                            *
#----------------------------------------------------------------------------*

COMMAND_FILES_TO_BUILD := 2-run-openocd.command

ifneq ($(LDSCRIPT_INTERNAL_FLASH), )
  COMMAND_FILES_TO_BUILD += 2a-internal-flash-erase.command
  COMMAND_FILES_TO_BUILD += 2a-internal-flash-erase-check.command
  COMMAND_FILES_TO_BUILD += 2a-internal-flash-perform-programming.command
endif

ifneq ($(LDSCRIPT_EXTERNAL_RAM), )
  COMMAND_FILES_TO_BUILD += 2a-run-external-ram.command
  COMMAND_FILES_TO_BUILD += 2a-debug-external-ram.command
endif

ifneq ($(LDSCRIPT_INTERNAL_RAM), )
  COMMAND_FILES_TO_BUILD += 2a-run-internal-ram.command
  COMMAND_FILES_TO_BUILD += 2a-debug-internal-ram.command
endif

COMMAND_FILES_TO_BUILD += clean.command
COMMAND_FILES_TO_BUILD += 1-verbose-build.command
COMMAND_FILES_TO_BUILD += 1-build-as.command
COMMAND_FILES_TO_BUILD += 2b-telnet.command
COMMAND_FILES_TO_BUILD += display-obj-size.command

ifdef SERIAL_DEFINITION
  ifneq ($(SERIAL_DEFINITION), )
    COMMAND_FILES_TO_BUILD += serial.command
  endif
endif

#----------------------------------------------------------------------------*

MAKE_ALL_TARGETS += $(COMMAND_FILES_TO_BUILD)

#----------------------------------------------------------------------------*

COMMAND_FILES_TO_DELETE := 2-run-openocd.command
COMMAND_FILES_TO_DELETE += 2a-debug-internal-ram.command
COMMAND_FILES_TO_DELETE += 2a-debug-external-ram.command
COMMAND_FILES_TO_DELETE += 2a-internal-flash-erase.command
COMMAND_FILES_TO_DELETE += 2a-internal-flash-erase-check.command
COMMAND_FILES_TO_DELETE += 2a-internal-flash-perform-programming.command
COMMAND_FILES_TO_DELETE += 2a-run-external-ram.command
COMMAND_FILES_TO_DELETE += 2a-run-internal-ram.command
COMMAND_FILES_TO_DELETE += 2b-telnet.command
COMMAND_FILES_TO_DELETE += display-obj-size.command

#----------------------------------------------------------------------------*
#                                                                            *
#          GDB script files to handle                                        *
#                                                                            *
#----------------------------------------------------------------------------*

GDB_SCRIPT_FILES_TO_BUILD :=
ifneq ($(LDSCRIPT_INTERNAL_FLASH), )
  GDB_SCRIPT_FILES_TO_BUILD += $(GDB_SCRIPT_DIR)/internal-flash-erase.gdb
  GDB_SCRIPT_FILES_TO_BUILD += $(GDB_SCRIPT_DIR)/internal-flash-erase-check.gdb
  GDB_SCRIPT_FILES_TO_BUILD += $(GDB_SCRIPT_DIR)/internal-flash-perform-programming.gdb
endif

ifneq ($(LDSCRIPT_EXTERNAL_RAM), )
  GDB_SCRIPT_FILES_TO_BUILD += $(GDB_SCRIPT_DIR)/debug-in-external-ram.gdb
  GDB_SCRIPT_FILES_TO_BUILD += $(GDB_SCRIPT_DIR)/run-in-external-ram.gdb
endif

ifneq ($(LDSCRIPT_INTERNAL_RAM), )
  GDB_SCRIPT_FILES_TO_BUILD += $(GDB_SCRIPT_DIR)/debug-in-internal-ram.gdb
  GDB_SCRIPT_FILES_TO_BUILD += $(GDB_SCRIPT_DIR)/run-in-internal-ram.gdb
endif

#----------------------------------------------------------------------------*
#                                                                            *
#          make all inference rule                                           *
#                                                                            *
#----------------------------------------------------------------------------*

BUILD_INTERNAL_RAM_IMAGE: $(PRODUCT_DIR)/$(PROJECT)-internal-ram.elf

BUILD_EXTERNAL_RAM_IMAGE: $(PRODUCT_DIR)/$(PROJECT)-external-ram.elf

BUILD_INTERNAL_FLASH_IMAGE: $(PRODUCT_DIR)/$(PROJECT)-internal-flash.elf

OBJECTS := $(patsubst %, $(BUILD_DIR)/%.o, $(SOURCES))
ifdef SOURCES_THUMB
  OBJECTS += $(patsubst %, $(BUILD_DIR)/%.oo, $(SOURCES_THUMB))
endif

MAKE_ALL_TARGETS += $(GDB_SCRIPT_DIR)
MAKE_ALL_TARGETS += $(OBJECTS)

MAKE_ALL_TARGETS += $(PRODUCT_DIR)

ifeq ($(BUILD_API), 1)
  MAKE_ALL_TARGETS += $(MAKE_API_TARGET)
endif

ifneq ($(LDSCRIPT_INTERNAL_RAM), )
  MAKE_ALL_TARGETS += BUILD_INTERNAL_RAM_IMAGE
endif

ifneq ($(LDSCRIPT_EXTERNAL_RAM), )
  MAKE_ALL_TARGETS += BUILD_EXTERNAL_RAM_IMAGE
endif

ifneq ($(LDSCRIPT_INTERNAL_FLASH), )
  MAKE_ALL_TARGETS += BUILD_INTERNAL_FLASH_IMAGE
endif

MAKE_ALL_TARGETS += $(GDB_SCRIPT_FILES_TO_BUILD)

#----------------------------------------------------------------------------*
#                                                                            *
#          Check C comment style                                             *
#                                                                            *
#----------------------------------------------------------------------------*

FILTERED_SOURCES := $(filter %.s, $(SOURCES))
ifdef SOURCES_THUMB
  FILTERED_SOURCES += $(filter %.s, $(SOURCES_THUMB))
endif

#----------------------------------------------------------------------------*

CHECK_C_COMMENT_ARGUMENTS := output-file:$(BUILD_DIR)/check-c-comments.txt
CHECK_C_COMMENT_ARGUMENTS += $(patsubst %, file:%, $(FILTERED_SOURCES))
CHECK_C_COMMENT_ARGUMENTS += $(patsubst %, directory:%, $(SOURCE_DIR) $(BUILD_DIR))

#----------------------------------------------------------------------------*

MAKE_ALL_TARGETS += $(BUILD_DIR)/check-c-comments.txt

#----------------------------------------------------------------------------*

$(BUILD_DIR)/check-c-comments.txt:$(BUILD_DIR)/monitor-api-definition.s
	@echo "*** Checking C comments"
	$(SILENT_CHAR)/usr/local/dev-arm/arm-tools/bin/check-c-comments $(CHECK_C_COMMENT_ARGUMENTS)

#----------------------------------------------------------------------------*
#                                                                            *
#          A L L    I N F E R E N C E    R U L E                             *
#                                                                            *
#----------------------------------------------------------------------------*

all: $(MAKE_ALL_TARGETS)
	@echo "Success !"

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
	@echo "*** Building Command file: $@"
	$(SILENT_CHAR)sed "s:GDBDIR:$(GDB_SCRIPT_DIR):g" $< | \
sed "s:OPENOCDSCRIPTDIR:$(DEV_DIR)/openocd-scripts:g" | \
sed "s@SERIALLINK@$(SERIAL_DEFINITION)@g" | \
sed "s:GDB_TOOL:$(GDB_TOOL):g" | \
sed "s:GNUARMPATH:$(GNU_ARM_PATH):g" | \
sed "s:OBJECTFILELIST:$(OBJECTS):g" | \
sed "s:DEVELOPMENTBOARD:$(strip $(DEVELOPMENT_BOARD)):g" | \
sed "s:CRYSTALFREQUENCY:$(strip $(LPC22XX_CRYSTAL_FREQUENCY)):g" | \
sed "s:PRODUCT_PATH:$(PRODUCT_DIR)/$(PROJECT):g" > $@
	$(SILENT_CHAR)chmod +x $@

#----------------------------------------------------------------------------*
#                                                                            *
#          GDB file inference rule                                           *
#                                                                            *
#----------------------------------------------------------------------------*

$(GDB_SCRIPT_DIR)/%.gdb: $(DEV_DIR)/gdb-script-templates/%.template.gdb
	@echo "*** Building '$@'"
	$(SILENT_CHAR)sed "s:INTERNAL_FLASH_TARGET:$(PRODUCT_DIR)/$(PROJECT)-internal-flash.elf:g" $< | \
sed "s:INTERNAL_RAM_TARGET:$(PRODUCT_DIR)/$(PROJECT)-internal-ram.elf:g" | \
sed "s:EXTERNAL_RAM_TARGET:$(PRODUCT_DIR)/$(PROJECT)-external-ram.elf:g" | \
sed "s:LAST_INTERNAL_FLASH_BANK:$(LAST_INTERNAL_FLASH_BANK):g" | \
sed "s:SOURCE_DIR_LIST:$(SOURCE_DIR):g" > $@

#----------------------------------------------------------------------------*
#                                                                            *
#          make directory inference rules                                    *
#                                                                            *
#----------------------------------------------------------------------------*

$(AS_BUILD_DIR):
	@echo "*** Making directory: $@"
	$(SILENT_CHAR)mkdir $(AS_BUILD_DIR)

$(BUILD_DIR):
	@echo "*** Making directory: $@"
	$(SILENT_CHAR)mkdir $(BUILD_DIR)

$(PRODUCT_DIR):
	@echo "*** Making directory: $@"
	$(SILENT_CHAR)mkdir $(PRODUCT_DIR)

$(GDB_SCRIPT_DIR):
	@echo "*** Making directory: $@"
	$(SILENT_CHAR)mkdir $(GDB_SCRIPT_DIR)

$(API_DIR):
	@echo "*** Making directory: $@"
	$(SILENT_CHAR)mkdir $(API_DIR)

#----------------------------------------------------------------------------*
#                                                                            *
#          link inference rules                                              *
#                                                                            *
#----------------------------------------------------------------------------*

LDFLAGS_INTERNAL_RAM := $(COMMON_LD_FLAGS) --script=$(LDSCRIPT_INTERNAL_RAM)

#----------------------------------------------------------------------------*

LDFLAGS_EXTERNAL_RAM := $(COMMON_LD_FLAGS) --script=$(LDSCRIPT_EXTERNAL_RAM)

#----------------------------------------------------------------------------*

LDFLAGS_ROM := $(COMMON_LD_FLAGS) --script=$(LDSCRIPT_INTERNAL_FLASH)

#----------------------------------------------------------------------------*

$(PRODUCT_DIR)/%internal-ram.elf: $(PRODUCT_DIR) $(OBJECTS) $(LDSCRIPT_INTERNAL_RAM)
	@echo "*** Linking $@"
	$(SILENT_CHAR)$(LD_TOOL) $(OBJECTS) $(LDFLAGS_INTERNAL_RAM) -Map=$@.map $(LIBS) -o $@

#----------------------------------------------------------------------------*

$(PRODUCT_DIR)/%external-ram.elf: $(PRODUCT_DIR) $(OBJECTS) $(LDSCRIPT_EXTERNAL_RAM)
	@echo "*** Linking $@"
	$(SILENT_CHAR)$(LD_TOOL) $(OBJECTS) $(LDFLAGS_EXTERNAL_RAM) -Map=$@.map $(LIBS) -o $@

#----------------------------------------------------------------------------*

$(PRODUCT_DIR)/%internal-flash.elf: $(PRODUCT_DIR) $(OBJECTS) $(LDSCRIPT_INTERNAL_FLASH)
	@echo "*** Linking $@"
	$(SILENT_CHAR)$(LD_TOOL) $(OBJECTS) $(LDFLAGS_ROM) -Map=$@.map $(LIBS) -o $@

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

as:$(AS_BUILD_DIR) $(MAKE_DISPATCHER_TARGET) $(OBJECTS_AS)

#----------------------------------------------------------------------------*
#                                                                            *
#          clean goal                                                        *
#                                                                            *
#----------------------------------------------------------------------------*

clean:
	@echo "*** Cleaning..."
	$(SILENT_CHAR)rm -fr $(API_DIR)
	$(SILENT_CHAR)rm -fr $(BUILD_DIR)
	$(SILENT_CHAR)rm -fr $(AS_BUILD_DIR)
	$(SILENT_CHAR)rm -fr $(PRODUCT_DIR)
	$(SILENT_CHAR)rm -f $(COMMAND_FILES_TO_DELETE)
	$(SILENT_CHAR)rm -fR $(GDB_SCRIPT_DIR)
	$(SILENT_CHAR)rm -f $(DOCUMENTATION_FILE)
	$(SILENT_CHAR)rm -fr $(TEMP_LATEX)

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
