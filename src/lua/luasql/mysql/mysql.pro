######################################################################
# Automatically generated by qmake (3.0) qua jan 4 16:36:37 2017
######################################################################

TEMPLATE = lib
CONFIG += plugin
CONFIG += no_plugin_name_prefix
TARGET = mysql-driver

INCLUDEPATH += .
INCLUDEPATH += ../
INCLUDEPATH += ../../../../deps/include

TARGET = mysql

DESTDIR = ../../../../clib/luasql

LIBS += -L ../../../../deps -llua -lm -lmysqlclient -ldl

# Input
SOURCES += ls_mysql.c \
           ../luasql.c
