#include <oberon/base>
#include <oberon/string/oberon_string_append.hpp>
#include <oberon/string/oberon_string_contains.hpp>
#include <oberon/string/oberon_string_insert.hpp>
#include <oberon/string/oberon_string_endsWith.hpp>
#include <oberon/string/oberon_string_lastIndexOf.hpp>
#include <oberon/string/oberon_string_mid.hpp>
#include <oberon/string/oberon_string_repeated.hpp>
#include <oberon/string/oberon_string_replace.hpp>
#include <oberon/string/oberon_string_right.hpp>
#include <oberon/string/oberon_string_simplified.hpp>
#include <oberon/string/oberon_string_startsWith.hpp>
#include <oberon/string/oberon_string_trimmed.hpp>
#include <oberon/string/oberon_string_truncate.hpp>
#include <oberon/string/oberon_string_underscore.hpp>

char * string::append(const char * string, const char * str)
{
  return oberon_string_append(string, str);
}

bool string::contains(const char * string, const char * str)
{
  return oberon_string_contains(string, str);
}

char * string::insert(const char * string, int len, const char * ba)
{
  return oberon_string_insert(string, len, ba);
}

bool string::endsWith(const char * string, const char * str)
{
  return oberon_string_endsWith(string, str);
}

int string::lastIndexOf(const char * string, const char * str)
{
  return oberon_string_lastIndexOf(string, str);
}

char * string::mid(const char * string, size_t string_len, int pos, int len = -1)
{
  return oberon_string_mid(string, string_len, pos, len);
}

char * string::repeated(char *string, int times)
{
  return oberon_string_repeated(string, times);
}

char * string::replace(const char *string, const char before, const char * after)
{
  return oberon_string_replace(string, before, after);
}

char * string::right(char *string, int len)
{
  return oberon_string_right(string, len);
}

char * string::simplified(char *string)
{
  return oberon_string_simplified(string);
}

bool string::startsWith(const char *string, const char *str)
{
  return oberon_string_startsWith(string, str);
}

char * string::trimmed(const char *string)
{
  return oberon_string_trimmed(string);
}

char * string::truncate(const char *string, int pos)
{
  return oberon_string_truncate(string, pos);
}

char * string::underscore(const char *string)
{
  return oberon_string_underscore(string);
}
