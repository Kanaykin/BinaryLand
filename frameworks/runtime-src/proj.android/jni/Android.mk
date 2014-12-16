LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := hellolua/main.cpp \
                   ../../Classes/AppDelegate.cpp \
		   ../../Classes/lua_module_extend.cpp \
		   ../../Classes/Logger.cpp \
		   Statistic.cpp \
		   GoogleAnalitics.cpp \
		   Events.cpp


LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes
					
LOCAL_STATIC_LIBRARIES := cocos2d_lua_static

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)
