#include "FacebookADS.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

#define  CLASS_NAME "org/myextend/MyExtendHelper"


namespace myextend {
    namespace android {

//-------------------------------
bool FacebookADS::showADS()
{
    cocos2d::JniMethodInfo methodInfo;
    
    if (!getJNIStaticMethodInfo(methodInfo, "showADS", "()Z")) {
        return false;
    }
    jboolean ret = methodInfo.env->CallStaticBooleanMethod(methodInfo.classID, methodInfo.methodID);
    methodInfo.env->DeleteLocalRef(methodInfo.classID);
    return ret;
}

//-------------------------------
void FacebookADS::cancelADS()
{
    cocos2d::JniMethodInfo methodInfo;
    
    if (!getJNIStaticMethodInfo(methodInfo, "cancelADS", "()V")) {
        return;
    }

    methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID);
    methodInfo.env->DeleteLocalRef(methodInfo.classID);  
}

//-------------------------------
int FacebookADS::getStatusADS()
{
    cocos2d::JniMethodInfo methodInfo;
    
    if (!getJNIStaticMethodInfo(methodInfo, "getStatusADS", "()I")) {
        return false;
    }

    jint ret = methodInfo.env->CallStaticIntMethod(methodInfo.classID, methodInfo.methodID);
    methodInfo.env->DeleteLocalRef(methodInfo.classID);
    return ret;
}

//-------------------------------
bool FacebookADS::getJNIStaticMethodInfo(cocos2d::JniMethodInfo &methodinfo,
                                             const char *methodName,
                                             const char *paramCode) {
    return cocos2d::JniHelper::getStaticMethodInfo(methodinfo,
                                                   CLASS_NAME,
                                                   methodName,
                                                   paramCode);
}
        
    }
}
