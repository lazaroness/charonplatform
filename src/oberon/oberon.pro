######################################################################
# Automatically generated by qmake (3.0) dom jan 24 22:51:13 2016
######################################################################
QT += network
TEMPLATE = lib
INCLUDEPATH += .
INCLUDEPATH += ../../include
INCLUDEPATH += ../../vendors/include
INCLUDEPATH += ../vendors/mongrel2
INCLUDEPATH += ../vendors/ap

TARGET = oberon
DESTDIR = ../../vendors

# Input
SOURCES += base/math.cpp            \
           base/os.cpp              \
           base/string.cpp          \
           classes/OByteArray.cpp   \
           classes/OThread.cpp      \
           classes/OHttpClient.cpp  \
           classes/OHttpParser.cpp  \
           modules/base64.cpp       \
           modules/digest.cpp       \
           modules/http.cpp         \
           modules/regex.cpp        \
           modules/sha3.cpp         \
           ../vendors/mongrel2/http11/http11_parser.c \
           ../vendors/ap/ap_base64.c


unix:LIBS  += -lcurl
win32:LIBS += ../../vendors/lua51.dll
win32:LIBS += ../../vendors/libcurl.dll
