// Copyright 2016 The Charon Platform Authors.
// All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <lua/lua.hpp>
#include <charon/mvm>

using charon::mvm;

static int
charon_mvm_gc(lua_State *L) {
  lua_pushinteger(L, mvm::gc());
  return 1;
}

static int
charon_mvm_reload(lua_State *L) {
  mvm::reload();
  lua_pushinteger(L, mvm::version());
  return 0;
}

static int
charon_mvm_clear(lua_State *L) {
  lua_pushnumber(L, mvm::clear());
  return 1;
}

static int
charon_mvm_version(lua_State *L) {
  lua_pushnumber(L, mvm::version());
  return 1;
}

extern "C" {
  int luaopen_charon_mvm( lua_State *L ) {
    static const luaL_reg Map[] = {
      {"gc",      charon_mvm_gc},
      {"version", charon_mvm_version},
      {"reload",  charon_mvm_reload},
      {"clear",   charon_mvm_clear},
      {NULL, NULL}
    };
    luaL_newmetatable(L, "mvm");
    luaL_register(L, NULL, Map);
    lua_pushvalue(L, -1);
    lua_setfield(L, -1, "__index");
    return 1;
  }
}
