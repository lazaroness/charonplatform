######################################################################
# Automatically generated by qmake (3.0) dom jan 24 22:51:13 2016
######################################################################
QT += core sql
TEMPLATE = lib
CONFIG += plugin
CONFIG += no_plugin_name_prefix

INCLUDEPATH += .
INCLUDEPATH += ../../../../../include
INCLUDEPATH += ../../../../../deps/include

TARGET = CHttpClient
DESTDIR = ../../../../../clib/

LIBS += -L ../../../../../deps -lcharon -llua -lcurl

# Input
SOURCES += CHttpClient.cpp

mac:QMAKE_POST_LINK += install_name_tool -change liblua.so  @executable_path/../deps/liblua.so ../../../../../clib/CHttpClient.dylib; install_name_tool -change libcharon.1.dylib  @executable_path/../deps/libcharon.1.dylib ../../../../../clib/CHttpClient.dylib
