#----------------------------------------------------------------------------*
#                                                                            *
# Do NOT edit this makefile with an editor which replaces tabs by spaces !   *    
#                                                                            *
#----------------------------------------------------------------------------*
#                                                                            *
#          Handling verbose option                                           *
#                                                                            *
#----------------------------------------------------------------------------*

ifdef VERBOSE
  SILENT_CHAR :=
else
  SILENT_CHAR := @
endif 

#----------------------------------------------------------------------------*
#  Define GNU_ARM_PATH variable: path to the GNU ARM tools                   *
#----------------------------------------------------------------------------*

include /usr/local/dev-arm/gcc-for-arm-definition.mak

ifndef GNU_ARM_PATH
  $(error Error: no defined compiler tool, variable GNU_ARM_PATH is not defined)
endif

#----------------------------------------------------------------------------*
#  Define timing settings                                                    *
#----------------------------------------------------------------------------*

ifndef LPC22XX_CRYSTAL_FREQUENCY
  $(error Error: no defined quartz frequency, variable LPC22XX_CRYSTAL_FREQUENCY is not defined)
endif

ifndef LPC22XX_PLL_FREQUENCY_MULTIPLIER
  $(error Error: no defined frequency multiplier, variable LPC22XX_PLL_FREQUENCY_MULTIPLIER is not defined)
endif

ifndef LPC22XX_APB_DIVIDER
  $(error Error: no defined peripheral clock divider, variable LPC22XX_APB_DIVIDER is not defined)
endif

#----------------------------------------------------------------------------*
#  GCC Tool definition                                                       *
#----------------------------------------------------------------------------*

CC_TOOL := $(GNU_ARM_PATH)/bin/$(ARM_COMPILER_PREFIX)gcc -mcpu=arm7tdmi-s
ifdef SOURCES_THUMB
  CC_TOOL += -mthumb-interwork
else
  ifdef MONITOR_USES_THUMB_INTERWORK
    CC_TOOL += -mthumb-interwork
	endif
endif

#----------------------------------------------------------------------------*
#  AS_TOOL Tool definition                                                   *
#----------------------------------------------------------------------------*

AS_TOOL := $(GNU_ARM_PATH)/bin/$(ARM_COMPILER_PREFIX)as -mcpu=arm7tdmi-s
ifdef SOURCES_THUMB
  AS_TOOL += -mthumb-interwork
else
  ifdef MONITOR_USES_THUMB_INTERWORK
    AS_TOOL += -mthumb-interwork
	endif
endif

AS_TOOL += --fatal-warnings
AS_TOOL += $(patsubst %, -I %, $(SOURCE_DIR))

#----------------------------------------------------------------------------*
#  Object copy Tool definition                                               *
#----------------------------------------------------------------------------*

OBJCOPY_TOOL := $(GNU_ARM_PATH)/bin/$(ARM_COMPILER_PREFIX)objcopy

#----------------------------------------------------------------------------*
#  GDB Tool definition                                                       *
#----------------------------------------------------------------------------*

GDB_TOOL := $(GNU_ARM_PATH)/bin/$(ARM_COMPILER_PREFIX)gdb

#----------------------------------------------------------------------------*
#  GDB Tool definition                                                       *
#----------------------------------------------------------------------------*

LD_TOOL := $(GNU_ARM_PATH)/bin/$(ARM_COMPILER_PREFIX)ld

#----------------------------------------------------------------------------*
#  GCC Version (e.g. 4.2.0)                                                  *
#----------------------------------------------------------------------------*

GCC_VERSION := $(shell $(CC_TOOL) --version | awk '/(GCC)/ { print $$3; }')

#----------------------------------------------------------------------------*
#  Common LD flags                                                           *
#----------------------------------------------------------------------------*

COMMON_LD_FLAGS :=
COMMON_LD_FLAGS += -nostartfiles
COMMON_LD_FLAGS += --fatal-warnings
COMMON_LD_FLAGS += --warn-common 
COMMON_LD_FLAGS += --no-undefined 
COMMON_LD_FLAGS += --cref
ifdef SOURCES_THUMB
  COMMON_LD_FLAGS += -L$(GNU_ARM_PATH)/arm-elf/lib/interwork
  COMMON_LD_FLAGS += -L$(GNU_ARM_PATH)/lib/gcc/arm-elf/$(GCC_VERSION)/interwork
else
  ifdef MONITOR_USES_THUMB_INTERWORK
    COMMON_LD_FLAGS += -L$(GNU_ARM_PATH)/arm-elf/lib/interwork
    COMMON_LD_FLAGS += -L$(GNU_ARM_PATH)/lib/gcc/arm-elf/$(GCC_VERSION)/interwork
  else
    COMMON_LD_FLAGS += -L$(GNU_ARM_PATH)/arm-elf/lib
    COMMON_LD_FLAGS += -L$(GNU_ARM_PATH)/lib/gcc/arm-elf/$(GCC_VERSION)
  endif
endif
COMMON_LD_FLAGS += -lc -lgcc
#COMMON_LD_FLAGS += $(patsubst %,-L%,$(DLIBDIR) $(ULIBDIR))

#----------------------------------------------------------------------------*

# List all default C defines here, like -D_DEBUG=1
DDEFS := 

# List all default ASM defines here, like -D_DEBUG=1
DADEFS := 

# List the default directory to look for the libraries here
DLIBDIR :=

# List all default libraries here
DLIBS   := 

DEFS    := $(DDEFS)
ADEFS   := $(DADEFS)
LIBS    := $(DLIBS) # $(ULIBS)
MCFLAGS := -mcpu=arm7tdmi-s # -mfpu=softfpa

#----------------------------------------------------------------------------*

ASFLAGS := $(MCFLAGS) $(ADEFS)

#----------------------------------------------------------------------------*
#                                                                            *
#  Common C and C++ command line options for optimizing                      *
#                                                                            *
#----------------------------------------------------------------------------*

C_CPP_OPTIMIZING_OPTIONS := -O2
C_CPP_OPTIMIZING_OPTIONS += -fomit-frame-pointer
C_CPP_OPTIMIZING_OPTIONS += -foptimize-register-move

#----------------------------------------------------------------------------*
#                                                                            *
#          Common C and C++ command line options                             *
#                                                                            *
#----------------------------------------------------------------------------*

COMMON_C_CPP_OPTIONS += -mcpu=arm7tdmi-s
#COMMON_C_CPP_OPTIONS += -msoft-float
COMMON_C_CPP_OPTIONS += -Wall
COMMON_C_CPP_OPTIONS += -Werror
COMMON_C_CPP_OPTIONS += -Wreturn-type
COMMON_C_CPP_OPTIONS += -Wformat
COMMON_C_CPP_OPTIONS += -Wsign-compare
COMMON_C_CPP_OPTIONS += -Wpointer-arith
COMMON_C_CPP_OPTIONS += -Wparentheses
COMMON_C_CPP_OPTIONS += -Wcast-align
COMMON_C_CPP_OPTIONS += -Wcast-qual
COMMON_C_CPP_OPTIONS += -fverbose-asm $(DEFS)
#COMMON_C_CPP_OPTIONS += -Wconversion
COMMON_C_CPP_OPTIONS += -Wwrite-strings
COMMON_C_CPP_OPTIONS += -Wswitch

#----------------------------------------------------------------------------*
#                                                                            *
#          Handling Quartz Frequency                                         *
#                                                                            *
#----------------------------------------------------------------------------*

COMMON_C_CPP_OPTIONS += -DLPC22XX_CRYSTAL_FREQUENCY=$(LPC22XX_CRYSTAL_FREQUENCY)
COMMON_C_CPP_OPTIONS += -DLPC22XX_PLL_FREQUENCY_MULTIPLIER=$(LPC22XX_PLL_FREQUENCY_MULTIPLIER)
COMMON_C_CPP_OPTIONS += -DLPC22XX_APB_DIVIDER=$(LPC22XX_APB_DIVIDER)

#----------------------------------------------------------------------------*
#                                                                            *
#          Include pathes                                                    *
#                                                                            *
#----------------------------------------------------------------------------*

COMMON_C_CPP_OPTIONS += $(patsubst %, -I %, $(SOURCE_DIR))

#----------------------------------------------------------------------------*
#                                                                            *
#          C command line options                                            *
#                                                                            *
#----------------------------------------------------------------------------*

ACTUAL_C_OPTIONS := $(C_USER_OPTIONS)
ACTUAL_C_OPTIONS += $(COMMON_C_CPP_OPTIONS)
ACTUAL_C_OPTIONS += -Wstrict-prototypes
ACTUAL_C_OPTIONS += -Wbad-function-cast
ACTUAL_C_OPTIONS += -Wmissing-declarations
ACTUAL_C_OPTIONS += -Wimplicit-function-declaration
ACTUAL_C_OPTIONS += -Wno-int-to-pointer-cast
ACTUAL_C_OPTIONS += -Wno-pointer-to-int-cast

#----------------------------------------------------------------------------*
#                                                                            *
#          C++ command line options                                          *
#                                                                            *
#----------------------------------------------------------------------------*

ACTUAL_CPP_OPTIONS := $(CPP_USER_OPTIONS)
ACTUAL_CPP_OPTIONS += $(COMMON_C_CPP_OPTIONS)
ACTUAL_CPP_OPTIONS += -Wsign-promo
ACTUAL_CPP_OPTIONS += -Woverloaded-virtual
ACTUAL_CPP_OPTIONS += -Weffc++
ACTUAL_CPP_OPTIONS += -fno-rtti
ACTUAL_CPP_OPTIONS += -fno-threadsafe-statics
ACTUAL_CPP_OPTIONS += -fno-use-cxa-get-exception-ptr
ACTUAL_CPP_OPTIONS += -fno-enforce-eh-specs
ACTUAL_CPP_OPTIONS += -fno-exceptions

#----------------------------------------------------------------------------*
