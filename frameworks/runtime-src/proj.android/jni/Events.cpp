
#include <jni.h>
#include "Logger.h"
#include "CCLuaEngine.h"

inline std::string
extract_jni_string( JNIEnv* env, const jstring jstr ) {
	if ( !env || !jstr ) {
		//android_error() << "[native] extract_jni_string general error:" << std::hex << env << "/" << jstr;
		return std::string();
	}
	jsize size = env->GetStringUTFLength( jstr );
	if( size == 0 ) {
		//android_error() << "[native] extract_jni_string string length is 0";
		return std::string();
	}
	jboolean is_copy = JNI_FALSE;
	const char* psz  = env->GetStringUTFChars( jstr, &is_copy );
	if ( is_copy == JNI_FALSE || !psz ) {
		//android_info() << "[release] extract_jni_string fault";
		return std::string();
	}
	//g_android_call_stat.jni_cb += size;

	std::string result( psz, size );
	env->ReleaseStringUTFChars( jstr, psz );

	return result;
}

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
