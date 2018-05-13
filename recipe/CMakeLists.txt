cmake_minimum_required (VERSION 3.1.0)
project (THEORA)

## Find depenencies

# libogg

FIND_PATH(OGG_INCLUDE_DIR
    ogg.h
    PATH_SUFFIXES include/ogg
)

FIND_LIBRARY(OGG_LIBRARIES
    NAMES ogg libogg
    PATH_SUFFIXES lib
)
message(STATUS Found ogg headers at ${OGG_INCLUDE_DIR})
message(STATUS Found ogg libs at ${OGG_LIBRARIES})

include_directories(OGG_INCLUDE_DIR)

# libvorbis

# FIND_PATH(VORBIS_INCLUDE_DIR
#     vorbis.h
#     PATH_SUFFIXES include/vorbis
# )

# FIND_LIBRARY(VORBIS_LIBRARIES
#     NAMES vorbis libvorbis
#     PATH_SUFFIXES lib
# )

# message(STATUS Found vorbis headers at ${VORBIS_INCLUDE_DIR})
# message(STATUS Found vorbis libs at ${VORBIS_LIBRARIES})

# include_directories(VORBIS_INCLUDE_DIR)

## Build libtheora

add_definitions(-DOC_X86_ASM)
include_directories("${THEORA_SOURCE_DIR}/include")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY build)

set(THEORA_SRC
   lib/analyze.c
   lib/apiwrapper.c
   lib/bitpack.c
   lib/collect.c
   lib/decapiwrapper.c
   lib/decinfo.c
   lib/decode.c
   lib/dequant.c
   lib/encapiwrapper.c
   lib/encfrag.c
   lib/encinfo.c
   lib/encode.c
   lib/enquant.c
   lib/fdct.c
   lib/fragment.c
   lib/huffdec.c
   lib/huffenc.c
   lib/idct.c
   lib/info.c
   lib/internal.c
   lib/mathops.c
   lib/mcenc.c
   lib/quant.c
   lib/rate.c
   lib/state.c
   lib/tokenize.c
   lib/x86/mmxencfrag.c
   lib/x86/mmxfdct.c
   lib/x86/mmxfrag.c
   lib/x86/mmxidct.c
   lib/x86/mmxstate.c
   lib/x86/sse2idct.c
   lib/x86/x86cpu.c
   lib/x86/x86enquant.c
   lib/x86/x86state.c
)

add_library(THEORA SHARED
	${THEORA_SRC}
)

target_link_libraries (THEORA
	${OGG_LIBRARIES} 
    # ${VORBIS_LIBRARIES}
)

# if(WIN32)
# 	if(MSVC)
# 		configure_file(	${CMAKE_CURRENT_SOURCE_DIR}/win32/THEORA.def ${CMAKE_CURRENT_BINARY_DIR}/win32/THEORA.def @ONLY)
# 		set_target_properties(THEORA PROPERTIES LINK_FLAGS "/DEF:win32/THEORA.def")
# 	endif()
# endif()

set_target_properties(THEORA 
	PROPERTIES DEFINE_SYMBOL "DLL_EXPORT"
)
set_target_properties(THEORA
	PROPERTIES PREFIX "" OUTPUT_NAME "libtheora"
)

##### Installation targets #####
install(TARGETS THEORA
  LIBRARY DESTINATION "lib${LIB_SUFFIX}"
  ARCHIVE DESTINATION "lib${LIB_SUFFIX}"
  RUNTIME DESTINATION bin)

file(GLOB INCLUDE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/*.h)
# Copy .h files to include dir.
install(DIRECTORY ${THEORA_SOURCE_DIR}/include/theora DESTINATION include
	FILES_MATCHING PATTERN "*.h")
