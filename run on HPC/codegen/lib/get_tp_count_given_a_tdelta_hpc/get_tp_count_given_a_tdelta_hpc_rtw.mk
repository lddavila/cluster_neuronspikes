﻿###########################################################################
## Makefile generated for component 'get_tp_count_given_a_tdelta_hpc'. 
## 
## Makefile     : get_tp_count_given_a_tdelta_hpc_rtw.mk
## Generated on : Sat Mar 01 17:35:43 2025
## Final product: .\get_tp_count_given_a_tdelta_hpc.lib
## Product type : static-library
## 
###########################################################################

###########################################################################
## MACROS
###########################################################################

# Macro Descriptions:
# PRODUCT_NAME            Name of the system to build
# MAKEFILE                Name of this makefile
# COMPILER_COMMAND_FILE   Compiler command listing model reference header paths
# CMD_FILE                Command file
# MODELLIB                Static library target

PRODUCT_NAME              = get_tp_count_given_a_tdelta_hpc
MAKEFILE                  = get_tp_count_given_a_tdelta_hpc_rtw.mk
MATLAB_ROOT               = D:\MATLABR2024b
MATLAB_BIN                = D:\MATLABR2024b\bin
MATLAB_ARCH_BIN           = $(MATLAB_BIN)\win64
START_DIR                 = D:\cluster_neuronspikes\run on HPC
TGT_FCN_LIB               = ISO_C
SOLVER_OBJ                = 
CLASSIC_INTERFACE         = 0
MODEL_HAS_DYNAMICALLY_LOADED_SFCNS = 
RELATIVE_PATH_TO_ANCHOR   = ..\..\..
COMPILER_COMMAND_FILE     = get_tp_count_given_a_tdelta_hpc_rtw_comp.rsp
CMD_FILE                  = get_tp_count_given_a_tdelta_hpc_rtw.rsp
C_STANDARD_OPTS           = 
CPP_STANDARD_OPTS         = 
NODEBUG                   = 1
MODELLIB                  = get_tp_count_given_a_tdelta_hpc.lib

###########################################################################
## TOOLCHAIN SPECIFICATIONS
###########################################################################

# Toolchain Name:          Microsoft Visual C++ 2022 v17.0 | nmake (64-bit Windows)
# Supported Version(s):    17.0
# ToolchainInfo Version:   2024b
# Specification Revision:  1.0
# 
#-------------------------------------------
# Macros assumed to be defined elsewhere
#-------------------------------------------

# NODEBUG
# cvarsdll
# cvarsmt
# conlibsmt
# ldebug
# conflags
# cflags

#-----------
# MACROS
#-----------

MW_EXTERNLIB_DIR    = $(MATLAB_ROOT)\extern\lib\win64\microsoft
MW_LIB_DIR          = $(MATLAB_ROOT)\lib\win64
CPU                 = AMD64
APPVER              = 5.02
CVARSFLAG           = $(cvarsmt)
CFLAGS_ADDITIONAL   = -D_CRT_SECURE_NO_WARNINGS
CPPFLAGS_ADDITIONAL = -EHs -D_CRT_SECURE_NO_WARNINGS /wd4251 /Zc:__cplusplus
LIBS_TOOLCHAIN      = $(conlibs)

TOOLCHAIN_SRCS = 
TOOLCHAIN_INCS = 
TOOLCHAIN_LIBS = 

#------------------------
# BUILD TOOL COMMANDS
#------------------------

# C Compiler: Microsoft Visual C Compiler
CC = cl

# Linker: Microsoft Visual C Linker
LD = link

# C++ Compiler: Microsoft Visual C++ Compiler
CPP = cl

# C++ Linker: Microsoft Visual C++ Linker
CPP_LD = link

# Archiver: Microsoft Visual C/C++ Archiver
AR = lib

# MEX Tool: MEX Tool
MEX_PATH = $(MATLAB_ARCH_BIN)
MEX = "$(MEX_PATH)\mex"

# Download: Download
DOWNLOAD =

# Execute: Execute
EXECUTE = $(PRODUCT)

# Builder: NMAKE Utility
MAKE = nmake


#-------------------------
# Directives/Utilities
#-------------------------

CDEBUG              = -Zi
C_OUTPUT_FLAG       = -Fo
LDDEBUG             = /DEBUG
OUTPUT_FLAG         = -out:
CPPDEBUG            = -Zi
CPP_OUTPUT_FLAG     = -Fo
CPPLDDEBUG          = /DEBUG
OUTPUT_FLAG         = -out:
ARDEBUG             =
STATICLIB_OUTPUT_FLAG = -out:
MEX_DEBUG           = -g
RM                  = @del
ECHO                = @echo
MV                  = @ren
RUN                 = @cmd /C

#--------------------------------------
# "Faster Runs" Build Configuration
#--------------------------------------

ARFLAGS              = /nologo
CFLAGS               = $(cflags) $(CVARSFLAG) $(CFLAGS_ADDITIONAL) \
                       /O2 /Oy-
CPPFLAGS             = /TP $(cflags) $(CVARSFLAG) $(CPPFLAGS_ADDITIONAL) \
                       /O2 /Oy-
CPP_LDFLAGS          = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN)
CPP_SHAREDLIB_LDFLAGS  = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN) \
                         -dll -def:$(DEF_FILE)
DOWNLOAD_FLAGS       =
EXECUTE_FLAGS        =
LDFLAGS              = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN)
MEX_CPPFLAGS         =
MEX_CPPLDFLAGS       =
MEX_CFLAGS           =
MEX_LDFLAGS          =
MAKE_FLAGS           = -f $(MAKEFILE)
SHAREDLIB_LDFLAGS    = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN) \
                       -dll -def:$(DEF_FILE)



###########################################################################
## OUTPUT INFO
###########################################################################

PRODUCT = .\get_tp_count_given_a_tdelta_hpc.lib
PRODUCT_TYPE = "static-library"
BUILD_TYPE = "Static Library"

###########################################################################
## INCLUDE PATHS
###########################################################################

INCLUDES_BUILDINFO = 

INCLUDES = $(INCLUDES_BUILDINFO)

###########################################################################
## DEFINES
###########################################################################

DEFINES_CUSTOM = 
DEFINES_STANDARD = -DMODEL=get_tp_count_given_a_tdelta_hpc

DEFINES = $(DEFINES_CUSTOM) $(DEFINES_STANDARD)

###########################################################################
## SOURCE FILES
###########################################################################

SRCS = $(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_initialize.c $(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_terminate.c $(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc.c $(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\abs.c $(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\any.c $(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\combineVectorElements.c $(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_emxutil.c $(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_emxAPI.c

ALL_SRCS = $(SRCS)

###########################################################################
## OBJECTS
###########################################################################

OBJS = get_tp_count_given_a_tdelta_hpc_initialize.obj get_tp_count_given_a_tdelta_hpc_terminate.obj get_tp_count_given_a_tdelta_hpc.obj abs.obj any.obj combineVectorElements.obj get_tp_count_given_a_tdelta_hpc_emxutil.obj get_tp_count_given_a_tdelta_hpc_emxAPI.obj

ALL_OBJS = $(OBJS)

###########################################################################
## PREBUILT OBJECT FILES
###########################################################################

PREBUILT_OBJS = 

###########################################################################
## LIBRARIES
###########################################################################

LIBS = 

###########################################################################
## SYSTEM LIBRARIES
###########################################################################

SYSTEM_LIBS = 

###########################################################################
## ADDITIONAL TOOLCHAIN FLAGS
###########################################################################

#---------------
# C Compiler
#---------------

CFLAGS_ = /source-charset:utf-8
CFLAGS_BASIC = $(DEFINES) @$(COMPILER_COMMAND_FILE)

CFLAGS = $(CFLAGS) $(CFLAGS_) $(CFLAGS_BASIC)

#-----------------
# C++ Compiler
#-----------------

CPPFLAGS_ = /source-charset:utf-8
CPPFLAGS_BASIC = $(DEFINES) @$(COMPILER_COMMAND_FILE)

CPPFLAGS = $(CPPFLAGS) $(CPPFLAGS_) $(CPPFLAGS_BASIC)

###########################################################################
## INLINED COMMANDS
###########################################################################


!include $(MATLAB_ROOT)\rtw\c\tools\vcdefs.mak


###########################################################################
## PHONY TARGETS
###########################################################################

.PHONY : all build clean info prebuild download execute set_environment_variables


all : build
	@cmd /C "@echo ### Successfully generated all binary outputs."


build : set_environment_variables prebuild $(PRODUCT)


prebuild : 


download : $(PRODUCT)


execute : download


set_environment_variables : 
	@set INCLUDE=$(INCLUDES);$(INCLUDE)
	@set LIB=$(LIB)


###########################################################################
## FINAL TARGET
###########################################################################

#---------------------------------
# Create a static library         
#---------------------------------

$(PRODUCT) : $(OBJS) $(PREBUILT_OBJS)
	@cmd /C "@echo ### Creating static library "$(PRODUCT)" ..."
	$(AR) $(ARFLAGS) -out:$(PRODUCT) @$(CMD_FILE)
	@cmd /C "@echo ### Created: $(PRODUCT)"


###########################################################################
## INTERMEDIATE TARGETS
###########################################################################

#---------------------
# SOURCE-TO-OBJECT
#---------------------

.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


get_tp_count_given_a_tdelta_hpc_initialize.obj : "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_initialize.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_initialize.c"


get_tp_count_given_a_tdelta_hpc_terminate.obj : "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_terminate.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_terminate.c"


get_tp_count_given_a_tdelta_hpc.obj : "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc.c"


abs.obj : "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\abs.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\abs.c"


any.obj : "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\any.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\any.c"


combineVectorElements.obj : "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\combineVectorElements.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\combineVectorElements.c"


get_tp_count_given_a_tdelta_hpc_emxutil.obj : "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_emxutil.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_emxutil.c"


get_tp_count_given_a_tdelta_hpc_emxAPI.obj : "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_emxAPI.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\get_tp_count_given_a_tdelta_hpc\get_tp_count_given_a_tdelta_hpc_emxAPI.c"


###########################################################################
## DEPENDENCIES
###########################################################################

$(ALL_OBJS) : rtw_proj.tmw $(COMPILER_COMMAND_FILE) $(MAKEFILE)


###########################################################################
## MISCELLANEOUS TARGETS
###########################################################################

info : 
	@cmd /C "@echo ### PRODUCT = $(PRODUCT)"
	@cmd /C "@echo ### PRODUCT_TYPE = $(PRODUCT_TYPE)"
	@cmd /C "@echo ### BUILD_TYPE = $(BUILD_TYPE)"
	@cmd /C "@echo ### INCLUDES = $(INCLUDES)"
	@cmd /C "@echo ### DEFINES = $(DEFINES)"
	@cmd /C "@echo ### ALL_SRCS = $(ALL_SRCS)"
	@cmd /C "@echo ### ALL_OBJS = $(ALL_OBJS)"
	@cmd /C "@echo ### LIBS = $(LIBS)"
	@cmd /C "@echo ### MODELREF_LIBS = $(MODELREF_LIBS)"
	@cmd /C "@echo ### SYSTEM_LIBS = $(SYSTEM_LIBS)"
	@cmd /C "@echo ### TOOLCHAIN_LIBS = $(TOOLCHAIN_LIBS)"
	@cmd /C "@echo ### CFLAGS = $(CFLAGS)"
	@cmd /C "@echo ### LDFLAGS = $(LDFLAGS)"
	@cmd /C "@echo ### SHAREDLIB_LDFLAGS = $(SHAREDLIB_LDFLAGS)"
	@cmd /C "@echo ### CPPFLAGS = $(CPPFLAGS)"
	@cmd /C "@echo ### CPP_LDFLAGS = $(CPP_LDFLAGS)"
	@cmd /C "@echo ### CPP_SHAREDLIB_LDFLAGS = $(CPP_SHAREDLIB_LDFLAGS)"
	@cmd /C "@echo ### ARFLAGS = $(ARFLAGS)"
	@cmd /C "@echo ### MEX_CFLAGS = $(MEX_CFLAGS)"
	@cmd /C "@echo ### MEX_CPPFLAGS = $(MEX_CPPFLAGS)"
	@cmd /C "@echo ### MEX_LDFLAGS = $(MEX_LDFLAGS)"
	@cmd /C "@echo ### MEX_CPPLDFLAGS = $(MEX_CPPLDFLAGS)"
	@cmd /C "@echo ### DOWNLOAD_FLAGS = $(DOWNLOAD_FLAGS)"
	@cmd /C "@echo ### EXECUTE_FLAGS = $(EXECUTE_FLAGS)"
	@cmd /C "@echo ### MAKE_FLAGS = $(MAKE_FLAGS)"


clean : 
	$(ECHO) "### Deleting all derived files ..."
	@if exist $(PRODUCT) $(RM) $(PRODUCT)
	$(RM) $(ALL_OBJS)
	$(ECHO) "### Deleted all derived files."


