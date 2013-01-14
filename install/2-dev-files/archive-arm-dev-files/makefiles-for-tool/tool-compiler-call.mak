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
#                                                                      *
# C++ COMPILER INFERENCE RULE                                          *
#                                                                      *
#----------------------------------------------------------------------*

$(BUILD_DIR)/%.cpp.o:$(A_DIR)/%.cpp makefile.mak
	$(COMPILER) $(OPTIONS_GCC) -Weffc++ -c $< -o $@ -MD -MP -MF $@.dep

#----------------------------------------------------------------------*
#                                                                      *
# C COMPILER INFERENCE RULE                                            *
#                                                                      *
#----------------------------------------------------------------------*

$(BUILD_DIR)/%.c.o:$(A_DIR)/%.c makefile.mak
	$(COMPILER) $(OPTIONS_GCC) -c $< -o $@ -MD -MP -MF $@.dep

#----------------------------------------------------------------------*
#Call recursivly this file, without the first item of TEMP_SOURCE_DIRS *
#----------------------------------------------------------------------*

TEMP_SOURCE_DIRS := $(filter-out $(word 1, $(TEMP_SOURCE_DIRS)), $(TEMP_SOURCE_DIRS))

include $(DEV_DIR)/makefiles-for-tool/tool-compiler-call.mak

#----------------------------------------------------------------------*

endif