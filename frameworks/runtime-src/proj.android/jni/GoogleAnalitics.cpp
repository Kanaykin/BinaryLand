#include "GoogleAnalitics.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

#define  CLASS_NAME "org/myextend/MyExtendHelper"

namespace myextend {
    namespace android {

//-----------------------------
void GoogleAnalitics::sendEvent(const std::string& event)
{
    cocos2d::JniMethodInfo methodInfo;
    
    if (!getJNIStaticMethodInfo(methodInfo, "sendEventToStatistic", "(Ljava/lang/String;)V")) {
        return;
    }
    
    jstring stringArg = methodInfo.env->NewStringUTF(event.c_str());
    methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, stringArg);
    methodInfo.env->DeleteLocalRef(methodInfo.classID);
}

//-------------------------------
bool GoogleAnalitics::getJNIStaticMethodInfo(cocos2d::JniMethodInfo &methodinfo,
                                               const char *methodName,
                                               const char *paramCode) {
    return cocos2d::JniHelper::getStaticMethodInfo(methodinfo,
                                                   CLASS_NAME,
                                                   methodName,
                                                   paramCode);
}
        
    }
}
