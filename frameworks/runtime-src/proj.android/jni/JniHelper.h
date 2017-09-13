#ifndef BinaryLand_JNIHELPER_h
#define BinaryLand_JNIHELPER_h

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

#endif
