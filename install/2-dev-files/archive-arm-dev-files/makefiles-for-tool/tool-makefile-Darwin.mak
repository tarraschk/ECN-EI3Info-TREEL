#----------------------------------------------------------------------*
#                                                                      *
# TOOL DEFINITION FOR DARWIN (MAC OS X)                                *
#                                                                      *
#----------------------------------------------------------------------*

#----------------------------------------------------------------------*
#                                                                      *
# DEFINE COMPILER TO USE                                               *
#                                                                      *
#----------------------------------------------------------------------*

COMPILER := gcc -m32
LINKER := g++ -m32
STRIP := strip

#----------------------------------------------------------------------*
#                                                                      *
# DEFINE SOURCE LIST                                                   *
#                                                                      *
#----------------------------------------------------------------------*

ALL_SOURCES := $(SOURCES) $(SOURCES_FOR_MACOSX)

#----------------------------------------------------------------------*
#                                                                      *
# DEFINE LIBRARY LIST                                                  *
#                                                                      *
#----------------------------------------------------------------------*

ALL_LIBRARIES := $(LIBRARIES_FOR_MACOSX)

#----------------------------------------------------------------------*
#                                                                      *
# DEFINE INSTALL PATH                                                  *
#                                                                      *
#----------------------------------------------------------------------*

INSTALL_PATH := /usr/local/dev-arm/arm-tools/bin

#----------------------------------------------------------------------*
#                                                                      *
# DEFINE GCC OPTIONS                                                   *
#                                                                      *
#----------------------------------------------------------------------*

OPTIONS_GCC := -DMACOSX

#-----------------------------------------------------------------*
