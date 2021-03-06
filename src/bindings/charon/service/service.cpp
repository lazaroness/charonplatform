// Copyright 2016 The Charon Platform Authors.
// All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <lua/lua.hpp>
#include <charon/base>
#include <charon/service>

using charon::service;

static int
charon_service_loop(lua_State * L) {
  lua_getglobal(L, "__charon_service");
  service::worker * wkr = (service::worker *) lua_touserdata(L, -1);
  int secs;
  secs = luaL_checkint(L, 1);
  lua_pushboolean(L, wkr->loop(secs));

  return 1;
}

static int
charon_service_uuid(lua_State * L) {
  lua_getglobal(L, "__charon_service");
  service::worker * wkr = (service::worker *) lua_touserdata(L, -1);
  lua_pushstring(L, wkr->uuid());
  return 1;
}

static int
charon_service_start(lua_State *L) {
  const char * fileName = luaL_checkstring(L, 1);
  char * uuid = service::start( fileName );
  lua_pushstring(L, uuid);
  delete[] uuid;
  return 1;
}

static int
charon_service_gc(lua_State *L) {
  lua_pushinteger(L, service::gc());
  return 1;
}


extern "C" {
  int luaopen_charon_service( lua_State *L ) {
    static const luaL_reg Map[] = {
      {"gc",      charon_service_gc},
      {"loop",    charon_service_loop},
      {"start",   charon_service_start},
      {"uuid",    charon_service_uuid},
      {NULL, NULL}
    };
    luaL_newmetatable(L, "service");
    luaL_register(L, NULL, Map);
    lua_pushvalue(L, -1);
    lua_setfield(L, -1, "__index");
    return 1;
  }
}
