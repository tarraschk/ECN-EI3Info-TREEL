#----------------------------------------------------------------------------*
# Development directory, where all scripts are defined                       *
#----------------------------------------------------------------------------*

DEV_DIR := /usr/local/dev-arm/arm-dev-files

#----------------------------------------------------------------------------*
# Define development board                                                   *
#----------------------------------------------------------------------------*

DEVELOPMENT_BOARD := olimex-lpc-l2294

#----------------------------------------------------------------------------*
# SOURCE_DIR is the list of directories that contain all sources             *
#----------------------------------------------------------------------------*

SOURCE_DIR := sources
SOURCE_DIR += $(DEV_DIR)/sources
SOURCE_DIR += ../sources-communs

#----------------------------------------------------------------------------*
# Source file list                                                           *
#----------------------------------------------------------------------------*

SOURCES := main.c
SOURCES += crt0-for-sample-code.s
SOURCES += initialize-lpc2200-pll.c
SOURCES += handler-for-IRQ.s
SOURCES += handler-stub-for-DAbort.s
SOURCES += handler-stub-for-FIRQ.s
SOURCES += handler-stub-for-PAbort.s
SOURCES += handler-stub-for-SWI.s
SOURCES += handler-stub-for-undef.s
SOURCES += sorties_s0_s3.c

#----------------------------------------------------------------------------*
# Linker script files                                                        *
#----------------------------------------------------------------------------*

LINK_FOR_EXTERNAL_RAM := yes
LINK_FOR_INTERNAL_RAM := yes
LINK_FOR_INTERNAL_FLASH := yes

#----------------------------------------------------------------------------*
# Project name                                                               *
#----------------------------------------------------------------------------*

PROJECT := test

#----------------------------------------------------------------------------*
# C user options                                                             *
#----------------------------------------------------------------------------*

# Define here options for C compiling
C_USER_OPTIONS :=

#----------------------------------------------------------------------------*
# C++ user options                                                           *
#----------------------------------------------------------------------------*

# Define here options for C compiling
CPP_USER_OPTIONS :=

#----------------------------------------------------------------------------*
# User library directory list                                                *
#----------------------------------------------------------------------------*

# List the user directory to look for the libraries here
ULIBDIR :=

#----------------------------------------------------------------------------*
# User library list                                                          *
#----------------------------------------------------------------------------*

# List all user libraries here
ULIBS := 

#----------------------------------------------------------------------------*
# Include generic makefile                                                   *
#----------------------------------------------------------------------------*

include $(DEV_DIR)/makefiles/sample-code-makefile.mak

#----------------------------------------------------------------------------*
