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

TARGET = QSqlDatabase
DESTDIR = ../../../../clib

win32:LIBS += ../../../../vendors/lua51.dll

# Input
SOURCES += QSqlDatabase.cpp
