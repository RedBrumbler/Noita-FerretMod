cmake_minimum_required(VERSION 3.25)

if (NOT DEFINED MOD_VERSION)
    set(MOD_VERSION "0.1.0")
endif()

project(FerretMod
    VERSION ${MOD_VERSION}
    DESCRIPTION "Noita mod adding ferrets that tell you to make games"
    HOMEPAGE_URL "https://github.com/RedBrumbler/Noita-FerretMod"
    LANGUAGES # Empty
)

install(
    DIRECTORY ferret_mod
    DESTINATION .
    COMPONENT ferret_mod
)

set(CPACK_GENERATOR ZIP)
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")
set(CPACK_VERBATIM_VARIABLES TRUE)
include(CPack)
