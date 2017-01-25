
#include "lua_module_extend.h"
#include "Statistic.h"
#include "Advertisement.h"
#include "LuaBasicConversions.h"

//--------------------------------------
int lua_cocos2dx_Statistic_sendEvent(lua_State* tolua_S)
{
    int argc = 0;
    myextend::Statistic* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"extend.Statistic",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (myextend::Statistic*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_extension_ScrollView_setClippingToBounds'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 2)
    {
        std::string arg0;
        
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "myextend:Statistic:sendEvent");
        if(!ok)
            return 0;
        
        std::string arg2;
        
        ok &= luaval_to_std_string(tolua_S, 3,&arg2, "myextend:Statistic:sendEvent");
        if(!ok)
            return 0;
        cobj->sendEvent(arg0, arg2);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "myextend:Statistic:sendEvent",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_Statistic_sendEvent'.",&tolua_err);
#endif
    
    return 0;
}

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
int lua_cocos2dx_Advertisement_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"extend.Advertisement",0,&tolua_err)) goto tolua_lerror;
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (argc == 0)
    {
        if(!ok)
            return 0;
        myextend::Advertisement* ret = myextend::Advertisement::getInstance();
        object_to_luaval<myextend::Advertisement>(tolua_S, "extend.Advertisement", (myextend::Advertisement*)ret);
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
int lua_cocos2dx_Advertisement_showADS(lua_State* tolua_S)
{
    myextend::Advertisement* cobj = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"extend.Advertisement",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (myextend::Advertisement*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_extension_ScrollView_setClippingToBounds'", nullptr);
        return 0;
    }
#endif
    
    cobj->showADS();
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_Advertisement_showADS'.",&tolua_err);
#endif
    
    return 0;
}

//--------------------------------------
int lua_register_advertisement(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"extend.Advertisement");
    tolua_cclass(tolua_S,"Advertisement","extend.Advertisement","",nullptr);
    
    tolua_beginmodule(tolua_S,"Advertisement");
    tolua_function(tolua_S, "getInstance", lua_cocos2dx_Advertisement_getInstance);
    tolua_function(tolua_S, "showADS", lua_cocos2dx_Advertisement_showADS);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(myextend::Advertisement).name();
    g_luaType[typeName] = "extend.Advertisement";
    g_typeCast["Advertisement"] = "extend.Advertisement";

    return 1;
}


//--------------------------------------
int lua_register_statistic(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"extend.Statistic");
    tolua_cclass(tolua_S,"Statistic","extend.Statistic","",nullptr);
    
    tolua_beginmodule(tolua_S,"Statistic");
    tolua_function(tolua_S, "getInstance", lua_cocos2dx_Statistic_getInstance);
    tolua_function(tolua_S, "sendEvent", lua_cocos2dx_Statistic_sendEvent);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(myextend::Statistic).name();
    g_luaType[typeName] = "extend.Statistic";
    g_typeCast["Statistic"] = "extend.Statistic";
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
        lua_register_advertisement(L);
        
        tolua_endmodule(L);

    }
    lua_pop(L, 1);
    
    return 1;
}
