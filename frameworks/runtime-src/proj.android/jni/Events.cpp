
#include <jni.h>
#include "Logger.h"
#include "CCLuaEngine.h"
#include "JniHelper.h"

/*
 * Class:     org_cocos2dx_lua_AppActivity
 * Method:    nativeSetPaths
 * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
 */
extern "C" JNIEXPORT void JNICALL Java_org_cocos2dx_lua_AppActivity_nativeSetPaths
  (JNIEnv *env, jobject obj, jstring doc) {
	myextend::Logger::setLogFile(extract_jni_string( env, doc ));

    //HANDLE_GAME_CALL(g_ptr_game->set_paths(extract_jni_string( env, apk ),
    //                                        extract_jni_string( env, doc ),
    //                                        extract_jni_string( env, cache )));
  }

  /*
   * Class:     org_cocos2dx_lua_AppActivity
   * Method:    nativeBackPressed
   * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
   */
  extern "C" JNIEXPORT jboolean JNICALL Java_org_cocos2dx_lua_AppActivity_nativeBackPressed
    (JNIEnv *env, jobject obj) {

	if(cocos2d::ScriptEngineManager::getInstance()->getScriptEngine()->executeGlobalFunction("onBackPressed"))
		return JNI_TRUE;

    return JNI_FALSE;
  }
