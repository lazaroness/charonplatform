// Copyright 2016 The Charon Platform Authors.
// All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <lua/lua.hpp>
#include <iostream>
#include <QtCore>
#include <QCoreApplication>
#include <charon/helper>
#include <CByteArray>

int charonFileLoad(lua_State *L, QFile &file)
{
  int rv;

  rv = luaL_loadfile(L, file.fileName().toLocal8Bit());
  if (rv) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
    return rv;
  }

  rv = lua_pcall(L, 0, 0, lua_gettop(L) - 1);
  if (rv) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
    return rv;
  }

  return rv;
}

int charonTaskLoad(lua_State *L, char * task)
{
  int rv;
  CByteArray lib;

  lua_settop(L, 0);
  lua_getglobal(L, "CHARON_PATH");

  lib = lua_tostring(L, 1);

  lua_pushstring(L, task);
  lua_setglobal(L, "CHARON_TASK");

  lib.append("/lib/task.lua");

  rv = luaL_loadfile(L, lib);
  if (rv) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
    return rv;
  }

  rv = lua_pcall(L, 0, 0, lua_gettop(L) - 1);
  if (rv) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
    return rv;
  }

  return rv;
}

void charonConsolePrintAround(CByteArray &buffer)
{
  buffer.remove(0, 1);
  buffer.prepend("print(");
  buffer.append(")");
}

bool charonConsoleIncrementLevel(CByteArray &row)
{
  /* if */
  if(row.startsWith("if ") or row.contains(" if ")) {
    return true;
  }

  /* for */
  if(row.startsWith("for ") or row.contains(" for ")) {
    return true;
  }

  /* while */
  if(row.startsWith("while ") or row.contains(" while ")) {
    return true;
  }

  /* function */
  if(row.startsWith("function ") or row.contains("function(")) {
    return true;
  }

  return false;
}

bool charonConsoleDecrementLevel(CByteArray &row)
{
  /* end */
  if(row.startsWith("end") or row.contains(" end ")) {
    return true;
  }

  return false;
}

/* TODO
 1) level for if, while etc
 2) set up
 3) ctrl + r
*/
int charonConsoleLoad(lua_State *L)
{
  int rv = 0;
  int level = 0;
  std::string line;
  CByteArray  row;
  CByteArray  buffer;

  while(true) {
    std::cout << "charon" << level << "> ";

    std::getline(std::cin, line);
    row = line.c_str();

    if (level == 0) {
      buffer = line.c_str();
    } else {
      buffer.append(line.c_str());
      buffer.append("\n");
    }

    if (buffer.startsWith('=')) {
      charonConsolePrintAround(buffer);
    }

    if (charonConsoleIncrementLevel(row)) {
      buffer.append("\n");
      level ++ ;
    }

    if (charonConsoleDecrementLevel(row)) {
      level -- ;
    }

    if (level == 0) {
      rv  = luaL_loadstring(L, buffer);
      rv  = lua_pcall(L, 0, 0, 0);
      if (rv) {
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
      }
    }
    if (level < 0) {
      std::cout << "invalid end statement\n";
      level = 0;
    }
  }
  return rv;
}

int main(int argc, char * argv[])
{
  int rv = 0;
  CByteArray charonPath;
  CByteArray task;
  QString    dirPath;
  QFile      file(argv[1]);
  QCoreApplication app(argc, argv);
  lua_State  * L;
  charonPath = app.applicationFilePath().toLocal8Bit().data();

  L = Charon::init(argc, argv, charonPath);
  if (L == 0) {
    fprintf(stderr, "failure allocate memory\n");
    return 1;
  }

  if (file.fileName().isEmpty()) {
    rv = charonConsoleLoad(L);
  }

  if(file.exists()) {
    rv = charonFileLoad(L, file);
  }

  if(!file.exists()) {
    rv = charonTaskLoad(L, argv[1]);
  }

  return rv;
}
