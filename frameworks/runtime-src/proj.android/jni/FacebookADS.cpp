#include "FacebookADS.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

#define  CLASS_NAME "org/myextend/MyExtendHelper"


namespace myextend {
    namespace android {

//-------------------------------
void FacebookADS::showADS()
{
    cocos2d::JniMethodInfo methodInfo;
    
    if (!getJNIStaticMethodInfo(methodInfo, "showADS", "()V")) {
        return;
    }
    methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID);
    methodInfo.env->DeleteLocalRef(methodInfo.classID);
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
