// Copyright 2016 The Charon Platform Authors.
// All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <charon/base>

using charon::time::Time;

Time Time::currentTime()
{
  return (Time) QTime::currentTime();
}

Time Time::addSecs(int secs)
{
  return (Time) QTime::addSecs(secs);
}

Time Time::fromString(const char * string,  const char * format)
{
  return QTime(QTime::fromString(QString(string), QString(format)));
}

ByteArray Time::toString(const char * format)
{
  return ByteArray(QTime::toString(format).toLocal8Bit().data());
}

ByteArray Time::toString()
{
  return ByteArray(QTime::toString("hh:mm:ss.z").toLocal8Bit().data());
}

Time * Time::parse(const char * str)
{
  char format[25];
  strcpy(format, "hh:mm");

  if(str[5] == ':') {
    strcat(format, ":ss");
  }

  if(str[8] == '.') {
    strcat(format, ".z");
  }
  Time result = Time::fromString(str, format);
  if( result.isValid() ) {
    return new Time(result);
  } else {
    return 0;
  }
}
