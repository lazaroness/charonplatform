// Copyright 2016 The Charon Platform Authors.
// All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <lua/lua.hpp>
#include <charon/base64>

using charon::base64;

static int lua_charon_base64_decode( lua_State *L ) {
  const char * data = luaL_checkstring(L, 1);
  char * decoded = base64::decode(data);
  lua_pushstring( L, decoded );
  delete[] decoded;
  return 1;
}

static int lua_charon_base64_encode( lua_State *L ) {
  size_t size;
  const char * data = luaL_checklstring(L, 1, &size);
  char * encoded = base64::encode(data, size);
  lua_pushstring( L, encoded );
  delete[] encoded;
  return 1;
}

extern "C" {
  int luaopen_charon_base64( lua_State *L ) {
    static const luaL_reg Map[] = {
      {"encode", lua_charon_base64_encode},
      {"decode", lua_charon_base64_decode},
      {NULL, NULL}
    };
    luaL_newmetatable(L, "base64");
    luaL_register(L, NULL, Map);
    lua_pushvalue(L, -1);
    lua_setfield(L, -1, "__index");
    return 1;
  }
}
