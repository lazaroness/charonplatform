######################################################################
# Automatically generated by qmake (3.0) dom jan 24 22:51:13 2016
######################################################################
QT += sql
TEMPLATE = lib
CONFIG += plugin
CONFIG += no_plugin_name_prefix

INCLUDEPATH += .
INCLUDEPATH += ../../../../include
INCLUDEPATH += ../../../../vendors/include

TARGET = QSqlQuery
DESTDIR = ../../../../clib

LIBS  += -L ../../../../vendors -llua

# Input
SOURCES += QSqlQuery.cpp

mac:QMAKE_POST_LINK += install_name_tool -change liblua.so  @executable_path/../vendors/liblua.so ../../../../clib/QSqlQuery.dylib
