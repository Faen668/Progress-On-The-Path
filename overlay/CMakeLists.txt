cmake_minimum_required(VERSION 3.21)
set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE FILEPATH "")
set(VCPKG_TARGET_TRIPLET "x64-windows-static" CACHE STRING "")
set(VCPKG_HOST_TRIPLET "x64-windows-static" CACHE STRING "")
cmake_policy(SET CMP0091 NEW)
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
project(PotpOverlay LANGUAGES CXX RC)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(imgui CONFIG REQUIRED)

# An .asi: Ultimate ASI Loader (a Nexus requirement, https://www.nexusmods.com/witcher3/mods/13671, installed as
# winmm.dll beside the game) loads every one it finds, so this shares the game with other .asi mods. We don't ship it.
add_library(PotpOverlay SHARED src/main.cpp src/d3d12_hook.cpp src/input_hook.cpp src/ui.cpp src/settings.cpp src/pad.cpp src/model.cpp src/engine.cpp src/scan.cpp src/gameicons.cpp src/cardart.cpp src/achievements.cpp src/customach.cpp src/achicons.cpp src/kills.cpp src/cloth.cpp src/itemmodel.cpp src/modelview.cpp src/text.cpp src/log.cpp src/book.cpp src/potp.rc)
set_target_properties(PotpOverlay PROPERTIES SUFFIX ".asi")
# The achievement pack and the fonts are built into the .asi: a new one of either builds it again
set_source_files_properties(src/potp.rc PROPERTIES OBJECT_DEPENDS
	"${CMAKE_CURRENT_SOURCE_DIR}/data/achievements.dat;${CMAKE_CURRENT_SOURCE_DIR}/fonts/AlegreyaSans-Regular.ttf;${CMAKE_CURRENT_SOURCE_DIR}/fonts/EBGaramond.ttf;${CMAKE_CURRENT_SOURCE_DIR}/fonts/Cinzel.ttf;${CMAKE_CURRENT_SOURCE_DIR}/data/book.mesh;${CMAKE_CURRENT_SOURCE_DIR}/data/book_d.jpg;${CMAKE_CURRENT_SOURCE_DIR}/data/book_s.jpg;${CMAKE_CURRENT_SOURCE_DIR}/data/book_n.jpg;${CMAKE_CURRENT_SOURCE_DIR}/data/book_r.jpg;${CMAKE_CURRENT_SOURCE_DIR}/data/parchment.jpg;${CMAKE_CURRENT_SOURCE_DIR}/data/edges.jpg;${CMAKE_CURRENT_SOURCE_DIR}/data/edges_n.jpg;${CMAKE_CURRENT_SOURCE_DIR}/data/book_m.png")
target_link_libraries(PotpOverlay PRIVATE imgui::imgui d3d12 dxgi dxguid psapi shell32 ole32 uuid xmllite shlwapi windowscodecs)
target_compile_options(PotpOverlay PRIVATE /W4 /utf-8 /permissive-)
target_compile_definitions(PotpOverlay PRIVATE NOMINMAX WIN32_LEAN_AND_MEAN)

# Every build installs into Progress on the Path's own mod: its scripts and compiled scripts, the overlay's notices,
# and the .asi in the game's folders. The fonts and achievement data are inside the .asi.
set(POTP_MOD "${CMAKE_CURRENT_SOURCE_DIR}/../progress on the path ng")
set(W3_GAME_DIR "F:/Steam/steamapps/common/The Witcher 3" CACHE PATH "The game's folder")
# The text comes from source/strings/en.csv: see utility/gen-overlay-text.py
add_custom_command(TARGET PotpOverlay PRE_BUILD
	COMMAND python "${CMAKE_CURRENT_SOURCE_DIR}/../utility/gen-overlay-text.py"
	COMMENT "Making the overlay's text from en.csv")

add_custom_command(TARGET PotpOverlay POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E rm -rf "${W3_GAME_DIR}/mods/modProgressOnThePathNG/content/scripts"
	COMMAND ${CMAKE_COMMAND} -E copy_directory
		"${POTP_MOD}/workspace/scripts"
		"${W3_GAME_DIR}/mods/modProgressOnThePathNG/content/scripts"
	COMMAND ${CMAKE_COMMAND} -E copy_if_different
		"${POTP_MOD}/packed/mods/modprogressonthepathng/content/precompiled.rsblob"
		"${W3_GAME_DIR}/mods/modProgressOnThePathNG/content/precompiled.rsblob"
	COMMAND ${CMAKE_COMMAND} -E rm -rf "${W3_GAME_DIR}/mods/modProgressOnThePathNG/fonts"
	COMMAND ${CMAKE_COMMAND} -E rm -f "${W3_GAME_DIR}/mods/modProgressOnThePathNG/achievements.dat"
	COMMAND ${CMAKE_COMMAND} -E copy_if_different
		"$<TARGET_FILE:PotpOverlay>"
		"${W3_GAME_DIR}/bin/x64_dx12/PotpOverlay.asi"
	COMMAND ${CMAKE_COMMAND} -E copy_if_different
		"${CMAKE_CURRENT_SOURCE_DIR}/THIRD-PARTY-NOTICES.txt"
		"${W3_GAME_DIR}/mods/modProgressOnThePathNG/THIRD-PARTY-NOTICES.txt"
	COMMENT "Installing Progress on the Path, and PotpOverlay.asi")
