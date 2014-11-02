
#include "lua_module_extend.h"
#include "Statistic.h"
#include "LuaBasicConversions.h"

//--------------------------------------
int lua_cocos2dx_Statistic_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"extend.Statistic",0,&tolua_err)) goto tolua_lerror;
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (argc == 0)
    {
        if(!ok)
            return 0;
        myextend::Statistic* ret = myextend::Statistic::getInstance();
        object_to_luaval<myextend::Statistic>(tolua_S, "extend.Statistic", (myextend::Statistic*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "extend.Statistic:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_Statistic_getInstance'.",&tolua_err);
#endif
    return 0;
}


//--------------------------------------
int lua_register_statistic(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"extend.Statistic");
    tolua_cclass(tolua_S,"Statistic","extend.Statistic","",nullptr);
    
    tolua_beginmodule(tolua_S,"Statistic");
    tolua_function(tolua_S, "getInstance", lua_cocos2dx_Statistic_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(cocos2d::Mesh).name();
    g_luaType[typeName] = "extend.Statistic";
    g_typeCast["Mesh"] = "extend.Statistic";
    return 1;

    
    return 1;
}

//--------------------------------------
int register_extend_module(lua_State* L)
{
    lua_getglobal(L, "_G");
    if (lua_istable(L,-1))//stack:...,_G,
    {
        tolua_open(L);
        
        tolua_module(L, "extend", 0);
        tolua_beginmodule(L, "extend");
        
        lua_register_statistic(L);
        
        tolua_endmodule(L);

    }
    lua_pop(L, 1);
    
    return 1;
}
