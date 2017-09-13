#include <jni.h>
#include "CCLuaEngine.h"
#include "JniHelper.h"
/*
 * Class:     Logger
 * Method:    nativeLogError
 * Signature: (Ljava/lang/String;)V
 */
extern "C" JNIEXPORT void JNICALL Java_org_myextend_Logger_nativeLogError
  (JNIEnv * env, jclass, jstring str)
{
    CCLOG("ERROR: %s ", extract_jni_string(env, str).c_str());
}

/*
 * Class:     Logger
 * Method:    nativeLogDebug
 * Signature: (Ljava/lang/String;)V
 */
extern "C" JNIEXPORT void JNICALL Java_org_myextend_Logger_nativeLogDebug
  (JNIEnv * env, jclass, jstring str)
{
    CCLOG("DEBUG: %s ", extract_jni_string(env, str).c_str());
}

/*
 * Class:     Logger
 * Method:    nativeLogVerbose
 * Signature: (Ljava/lang/String;)V
 */
extern "C" JNIEXPORT void JNICALL Java_org_myextend_Logger_nativeLogVerbose
  (JNIEnv * env, jclass, jstring str)
{
    CCLOG("VERBOSE: %s ", extract_jni_string(env, str).c_str());
}

/*
 * Class:     Logger
 * Method:    nativeLogWarn
 * Signature: (Ljava/lang/String;)V
 */
extern "C" JNIEXPORT void JNICALL Java_org_myextend_Logger_nativeLogWarn
  (JNIEnv * env, jclass, jstring str)
{
    CCLOG("WARN: %s ", extract_jni_string(env, str).c_str());
}

/*
 * Class:     Logger
 * Method:    nativeLogInfo
 * Signature: (Ljava/lang/String;)V
 */
extern "C" JNIEXPORT void JNICALL Java_org_myextend_Logger_nativeLogInfo
  (JNIEnv * env, jclass, jstring str)
{
    CCLOG("INFO: %s ", extract_jni_string(env, str).c_str());
}

/*
 * Class:     Logger
 * Method:    nativeLogFatal
 * Signature: (Ljava/lang/String;)V
 */
extern "C" JNIEXPORT void JNICALL Java_org_myextend_Logger_nativeLogFatal
  (JNIEnv * env, jclass, jstring str)
{
    CCLOG("FATAL: %s ", extract_jni_string(env, str).c_str());
}

