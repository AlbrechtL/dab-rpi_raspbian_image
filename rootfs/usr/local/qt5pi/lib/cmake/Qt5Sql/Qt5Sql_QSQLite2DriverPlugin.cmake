
add_library(Qt5::QSQLite2DriverPlugin MODULE IMPORTED)

_populate_Sql_plugin_properties(QSQLite2DriverPlugin RELEASE "sqldrivers/libqsqlite2.so")

list(APPEND Qt5Sql_PLUGINS Qt5::QSQLite2DriverPlugin)
