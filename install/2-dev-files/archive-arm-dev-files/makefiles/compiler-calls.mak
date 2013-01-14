#----------------------------------------------------------------------*
#                                                                      *
#  Don't call this makefile directly                                   *
#                                                                      *
#----------------------------------------------------------------------*

ifneq ($(words $(TEMP_SOURCE_DIRS)), 0)

#----------------------------------------------------------------------*
#                                                                      *
#  Building inference rules                                            *
#                                                                      *
#----------------------------------------------------------------------*

A_DIR := $(word 1, $(TEMP_SOURCE_DIRS))

#----------------------------------------------------------------------*
#   Calling C compiler                                                 *
#----------------------------------------------------------------------*

$(BUILD_DIR)/%.c.o:$(A_DIR)/%.c makefile.mak
	@echo "*** C Compiling $<"
	$(SILENT_CHAR)$(CC_TOOL) -c $(ACTUAL_C_OPTIONS) $(C_CPP_OPTIMIZING_OPTIONS) -MD -MP -MF $@.dep -Wa,-ahlms=$@.lst $< -o $@ \
|| ( rm -f $(COMMAND_FILES_TO_DELETE) ; exit 1 )


$(AS_BUILD_DIR)/%.c.s:$(A_DIR)/%.c makefile.mak
	@echo "*** C Compiling $< -> s"
	$(SILENT_CHAR)$(CC_TOOL) -S $(ACTUAL_C_OPTIONS) $(C_CPP_OPTIMIZING_OPTIONS) -MD -MP -MF $@.dep -Wa,-ahlms=$@.lst $< -o $@ \
|| ( rm -f $(COMMAND_FILES_TO_DELETE) ; exit 1 )


#----------------------------------------------------------------------*
#   Calling C compiler (thumb mode)                                    *
#----------------------------------------------------------------------*

$(BUILD_DIR)/%.c.oo:$(A_DIR)/%.c makefile.mak
	@echo "*** C Compiling (thumb) $<"
	$(SILENT_CHAR)$(CC_TOOL) -mthumb -c $(ACTUAL_C_OPTIONS) $(C_CPP_OPTIMIZING_OPTIONS) -MD -MP -MF $@.dep -Wa,-ahlms=$@.lst $< -o $@ \
|| ( rm -f $(COMMAND_FILES_TO_DELETE) ; exit 1 )

$(AS_BUILD_DIR)/%.c.os:$(A_DIR)/%.c makefile.mak
	@echo "*** C Compiling (thumb) $< -> s"
	$(SILENT_CHAR)$(CC_TOOL) -mthumb -S $(ACTUAL_C_OPTIONS) $(C_CPP_OPTIMIZING_OPTIONS) -MD -MP -MF $@.dep -Wa,-ahlms=$@.lst $< -o $@ \
|| ( rm -f $(COMMAND_FILES_TO_DELETE) ; exit 1 )


#----------------------------------------------------------------------*
#   Calling C ++ compiler                                              *
#----------------------------------------------------------------------*

$(BUILD_DIR)/%.cpp.o:$(A_DIR)/%.cpp makefile.mak
	@echo "*** C++ Compiling $<"
	$(SILENT_CHAR)$(CC_TOOL) -c $(ACTUAL_CPP_OPTIONS) $(C_CPP_OPTIMIZING_OPTIONS) -MD -MP -MF $@.dep -Wa,-ahlms=$@.lst $< -o $@ \
|| ( rm -f $(COMMAND_FILES_TO_DELETE) ; exit 1 )

$(AS_BUILD_DIR)/%.cpp.s:$(A_DIR)/%.cpp makefile.mak
	@echo "*** C++ Compiling $< -> s"
	$(SILENT_CHAR)$(CC_TOOL) -S $(ACTUAL_CPP_OPTIONS) $(C_CPP_OPTIMIZING_OPTIONS) -MD -MP -MF $@.dep -Wa,-ahlms=$@.lst $< -o $@ \
|| ( rm -f $(COMMAND_FILES_TO_DELETE) ; exit 1 )


#----------------------------------------------------------------------*
#   Calling C ++ compiler (thumb mode)                                 *
#----------------------------------------------------------------------*

$(BUILD_DIR)/%.cpp.oo:$(A_DIR)/%.cpp makefile.mak
	@echo "*** C++ Compiling (thumb) $<"
	$(SILENT_CHAR)$(CC_TOOL) -mthumb -c $(ACTUAL_CPP_OPTIONS) $(C_CPP_OPTIMIZING_OPTIONS) -MD -MP -MF $@.dep -Wa,-ahlms=$@.lst $< -o $@ \
|| ( rm -f $(COMMAND_FILES_TO_DELETE) ; exit 1 )

$(AS_BUILD_DIR)/%.cpp.os:$(A_DIR)/%.cpp makefile.mak
	@echo "*** C++ Compiling (thumb) $< -> s"
	$(SILENT_CHAR)$(CC_TOOL) -mthumb -S $(ACTUAL_CPP_OPTIONS) $(C_CPP_OPTIMIZING_OPTIONS) -MD -MP -MF $@.dep -Wa,-ahlms=$@.lst $< -o $@ \
|| ( rm -f $(COMMAND_FILES_TO_DELETE) ; exit 1 )


#----------------------------------------------------------------------*
#   Calling Assembler                                                  *
#----------------------------------------------------------------------*

$(BUILD_DIR)/%.s.o:$(A_DIR)/%.s makefile.mak
	@echo "*** Assembling $<"
	$(SILENT_CHAR)$(AS_TOOL) $(ASFLAGS) --MD $@.dep $< -o $@ \
|| ( rm -f $(COMMAND_FILES_TO_DELETE) ; exit 1 )

$(AS_BUILD_DIR)/%.s.s:$(A_DIR)/%.s makefile.mak
	@echo "*** Copying $< -> s"
	$(SILENT_CHAR)cp $< $@


#----------------------------------------------------------------------*
#Call recursivly this file, without the first item of TEMP_SOURCE_DIRS *
#----------------------------------------------------------------------*

TEMP_SOURCE_DIRS := $(filter-out $(word 1, $(TEMP_SOURCE_DIRS)), $(TEMP_SOURCE_DIRS))

include $(DEV_DIR)/makefiles/compiler-calls.mak

#----------------------------------------------------------------------*

endif