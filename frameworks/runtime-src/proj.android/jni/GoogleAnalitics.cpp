#include "GoogleAnalitics.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

#define  CLASS_NAME "org/myextend/MyExtendHelper"

namespace myextend {
    namespace android {

//-----------------------------
void GoogleAnalitics::sendEvent(const std::string& category, const std::string& action,
                                        const std::string& label)
{
    cocos2d::JniMethodInfo methodInfo;
    
    if (!getJNIStaticMethodInfo(methodInfo, "sendEventToStatistic", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")) {
        return;
    }
    
    jstring stringCategory = methodInfo.env->NewStringUTF(category.c_str());
    jstring stringAction = methodInfo.env->NewStringUTF(action.c_str());
    jstring stringLabel = methodInfo.env->NewStringUTF(label.c_str());
    methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, stringCategory,
                                         stringAction, stringLabel);
    methodInfo.env->DeleteLocalRef(methodInfo.classID);
}
        
//-----------------------------
void GoogleAnalitics::sendScreenName(const std::string& screenName)
{
    cocos2d::JniMethodInfo methodInfo;
    
    if (!getJNIStaticMethodInfo(methodInfo, "sendScreenNameToStatistic", "(Ljava/lang/String;)V")) {
        return;
    }
    
    jstring stringScreenName = methodInfo.env->NewStringUTF(screenName.c_str());
    
    methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, stringScreenName);
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
