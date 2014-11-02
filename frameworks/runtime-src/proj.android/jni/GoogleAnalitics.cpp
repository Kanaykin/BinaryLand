#include "GoogleAnalitics.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

#define  CLASS_NAME "org/cocos2dx/lib/Cocos2dxHelper"

namespace myextend {
    namespace android {

//-----------------------------
void GoogleAnalitics::sendEvent(const std::string& event)
{
    cocos2d::JniMethodInfo methodInfo;
    
    if (! getJNIStaticMethodInfo(methodInfo, "sendEventToStatistic", "()V")) {
        return;
    }
    
    methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID);
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
