


macro(_qt5gui_find_extra_libs Name Libs LibDir IncDirs)
    set(Qt5Gui_${Name}_LIBRARIES)
    set(Qt5Gui_${Name}_INCLUDE_DIRS ${IncDirs})
    foreach(_lib ${Libs})
        string(REGEX REPLACE [^_A-Za-z0-9] _ _cmake_lib_name ${_lib})
        if (NOT TARGET Qt5::Gui_${_cmake_lib_name} AND NOT _Qt5Gui_${_cmake_lib_name}_LIBRARY_DONE)
            find_library(Qt5Gui_${_cmake_lib_name}_LIBRARY ${_lib}
                PATHS "${LibDir}"
                NO_DEFAULT_PATH
            )
            if (NOT Qt5Gui_${_cmake_lib_name}_LIBRARY)
                # The above find_library call doesn't work for finding
                # libraries in Windows SDK paths outside of the proper
                # environment, even if the libraries are present.  In other
                # cases it is OK for the libraries to not be found
                # because they are optional dependencies of Qt5Gui, needed
                # only if the qopengl.h header is used.
                # We try to find the libraries in the first place because Qt may be
                # compiled with another set of GL libraries (such as coming
                # from ANGLE).  The point of these find calls is to try to
                # find the same binaries as Qt is compiled with (as they are
                # in the interface of QtGui), so an effort is made to do so
                # above with paths known to qmake.
                set(_Qt5Gui_${_cmake_lib_name}_LIBRARY_DONE TRUE)
                unset(Qt5Gui_${_cmake_lib_name}_LIBRARY CACHE)
            else()
                add_library(Qt5::Gui_${_cmake_lib_name} SHARED IMPORTED)
                set_property(TARGET Qt5::Gui_${_cmake_lib_name} APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${Qt5Gui_${Name}_INCLUDE_DIRS})

                set_property(TARGET Qt5::Gui_${_cmake_lib_name} APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
                _qt5_Gui_check_file_exists("${Qt5Gui_${_cmake_lib_name}_LIBRARY}")
                set_property(TARGET Qt5::Gui_${_cmake_lib_name} PROPERTY IMPORTED_LOCATION_RELEASE "${Qt5Gui_${_cmake_lib_name}_LIBRARY}")

                unset(Qt5Gui_${_cmake_lib_name}_LIBRARY CACHE)

                find_library(Qt5Gui_${_cmake_lib_name}_LIBRARY_DEBUG ${_lib}d
                    PATHS "${LibDir}"
                    NO_DEFAULT_PATH
                )
                if (Qt5Gui_${_cmake_lib_name}_LIBRARY_DEBUG)
                    set_property(TARGET Qt5::Gui_${_cmake_lib_name} APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
                    _qt5_Gui_check_file_exists("${Qt5Gui_${_cmake_lib_name}_LIBRARY_DEBUG}")
                    set_property(TARGET Qt5::Gui_${_cmake_lib_name} PROPERTY IMPORTED_LOCATION_DEBUG "${Qt5Gui_${_cmake_lib_name}_LIBRARY_DEBUG}")
                endif()
                unset(Qt5Gui_${_cmake_lib_name}_LIBRARY_DEBUG CACHE)
                list(APPEND Qt5Gui_${Name}_LIBRARIES Qt5::Gui_${_cmake_lib_name})
            endif()
        endif()
    endforeach()
endmacro()


_qt5gui_find_extra_libs(EGL "EGL" "/opt/vc/lib" "")

_qt5gui_find_extra_libs(OPENGL "GLESv2" "/home/albrecht/raspi/sysroot/usr/lib/arm-linux-gnueabihf" "")



set(Qt5Gui_OPENGL_IMPLEMENTATION GLESv2)

get_target_property(_configs Qt5::Gui IMPORTED_CONFIGURATIONS)
foreach(_config ${_configs})
    set_property(TARGET Qt5::Gui APPEND PROPERTY
        IMPORTED_LINK_DEPENDENT_LIBRARIES_${_config}
        ${Qt5Gui_EGL_LIBRARIES} ${Qt5Gui_OPENGL_LIBRARIES}
    )
endforeach()
unset(_configs)
