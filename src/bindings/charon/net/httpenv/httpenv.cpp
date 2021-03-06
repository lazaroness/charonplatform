// Copyright 2016 The Charon Platform Authors.
// All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <lua/lua.hpp>
#include <charon/base>
#include <QtCore>
#include <iostream>
#include <QByteArray>

using charon::net::HttpEnv;

/**
 * checkHttpEnv
 */

HttpEnv *
checkHttpEnv( lua_State *L ) {
  return *(HttpEnv **) luaL_checkudata(L, 1, "HttpEnv.metatable");
}

/**
 * ClassMethods
 */

static int
lua_HttpEnvClassMethodNew( lua_State *L ) {
  size_t len;
  const char *data  = luaL_checklstring(L, 1, &len);
  HttpEnv **ptr = (HttpEnv **)lua_newuserdata(L, sizeof(HttpEnv*));
  *ptr= new HttpEnv(data, len);
  luaL_getmetatable(L, "HttpEnv.metatable");
  lua_setmetatable(L, -2);
  return 1;
}

static const luaL_reg HttpEnvClassMethods[] = {
  {"new", lua_HttpEnvClassMethodNew},
  {NULL, NULL}
};

void static
registerHttpEnvClassMethods( lua_State *L ) {
  luaL_newmetatable(L, "HttpEnv");
  luaL_register(L, NULL, HttpEnvClassMethods);
  lua_pushvalue(L, -1);
  lua_setfield(L, -1, "__index");
}

/**
 * InstanceMethods
 */

static int
lua_HttpEnvInstanceMethodData( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  lua_pushstring(L, udata->data());
  return 1;
}

static int
lua_HttpEnvInstanceMethodField( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  const char  *field = luaL_checkstring(L, 2);
  lua_pushstring(L, udata->field(field));
  return 1;
}

static int
lua_HttpEnvInstanceMethodFragment( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  if( udata->fragment() == NULL ) {
    lua_pushnil(L);
  } else {
    lua_pushstring(L, udata->fragment());
  }
  return 1;
}

static int
lua_HttpEnvInstanceMethodHttpVersion( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  lua_pushstring(L, udata->httpVersion());
  return 1;
}

static int
lua_HttpEnvInstanceMethodRequestUri( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  lua_pushstring(L, udata->requestUri());
  return 1;
}

static int
lua_HttpEnvInstanceMethodRequestPath( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  lua_pushstring(L, udata->requestPath());
  return 1;
}

static int
lua_HttpEnvInstanceMethodRequestMethod( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  lua_pushstring(L, udata->requestMethod());
  return 1;
}

static int
lua_HttpEnvInstanceMethodQueryString( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  lua_pushstring(L, udata->queryString());
  return 1;
}

static int
lua_HttpEnvInstanceMethodHeaderDone( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  if( udata->headerDoneLength() == 0 ) {
    lua_pushnil(L);
  } else {
    lua_pushlstring(L, udata->headerDone(), udata->headerDoneLength() );
  }
  return 1;
}

static int
lua_HttpEnvInstanceMethodHeaderDoneLength( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  lua_pushinteger(L, udata->headerDoneLength());
  return 1;
}

static int
lua_HttpEnvInstanceMethodDestruct( lua_State *L ) {
  HttpEnv *udata = checkHttpEnv( L );
  delete udata;
  return 0;
}

static const
luaL_reg HttpEnvInstanceMethods[] = {
  {"data", lua_HttpEnvInstanceMethodData},
  {"field", lua_HttpEnvInstanceMethodField},
  {"fragment", lua_HttpEnvInstanceMethodFragment},
  {"headerDone", lua_HttpEnvInstanceMethodHeaderDone},
  {"headerDoneLength", lua_HttpEnvInstanceMethodHeaderDoneLength},
  {"httpVersion", lua_HttpEnvInstanceMethodHttpVersion},
  {"requestUri", lua_HttpEnvInstanceMethodRequestUri},
  {"requestMethod", lua_HttpEnvInstanceMethodRequestMethod},
  {"requestPath", lua_HttpEnvInstanceMethodRequestPath},
  {"queryString", lua_HttpEnvInstanceMethodQueryString},
  {"__gc", lua_HttpEnvInstanceMethodDestruct},
  {NULL, NULL}
};

void static
registerHttpEnvInstanceMethods( lua_State *L ) {
  luaL_newmetatable(L, "HttpEnv.metatable");
  luaL_register(L, NULL, HttpEnvInstanceMethods);
  lua_pushvalue(L, -1);
  lua_setfield(L, -1, "__index");
}

extern "C" {
  int
  luaopen_charon_net_HttpEnv( lua_State *L ) {
    registerHttpEnvInstanceMethods(L);
    registerHttpEnvClassMethods(L);
    return 1;
  }
}
