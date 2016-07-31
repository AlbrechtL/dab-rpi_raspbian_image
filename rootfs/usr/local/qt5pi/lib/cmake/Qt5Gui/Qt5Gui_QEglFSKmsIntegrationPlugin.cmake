
add_library(Qt5::QEglFSKmsIntegrationPlugin MODULE IMPORTED)

_populate_Gui_plugin_properties(QEglFSKmsIntegrationPlugin RELEASE "egldeviceintegrations/libqeglfs-kms-integration.so")

list(APPEND Qt5Gui_PLUGINS Qt5::QEglFSKmsIntegrationPlugin)
