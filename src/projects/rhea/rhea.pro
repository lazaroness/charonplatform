######################################################################
# Automatically generated by qmake (3.0) seg jan 25 10:12:08 2016
######################################################################

QT += core
QT -= gui

CONFIG += c++11
CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

TARGET = rhea
DESTDIR = ../../../bin

INCLUDEPATH += .
INCLUDEPATH += ../../../include
INCLUDEPATH += ../../../vendors/include


QMAKE_RPATHDIR += ../vendors

LIBS += -L ../../../vendors -llua -loberon -lcurl

# Input
SOURCES += main.cpp ../oberon/oberon.cpp
mac:QMAKE_POST_LINK += install_name_tool -change liboberon.1.dylib  @executable_path/../vendors/liboberon.1.dylib ../../../bin/rhea ; install_name_tool -change liblua.so  @executable_path/../vendors/liblua.so ../../../bin/rhea
