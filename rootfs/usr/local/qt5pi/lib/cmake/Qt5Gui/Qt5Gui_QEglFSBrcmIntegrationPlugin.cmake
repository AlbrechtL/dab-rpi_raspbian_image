
add_library(Qt5::QEglFSBrcmIntegrationPlugin MODULE IMPORTED)

_populate_Gui_plugin_properties(QEglFSBrcmIntegrationPlugin RELEASE "egldeviceintegrations/libqeglfs-brcm-integration.so")

list(APPEND Qt5Gui_PLUGINS Qt5::QEglFSBrcmIntegrationPlugin)
