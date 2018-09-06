#include "AndroidBilling.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

#define  CLASS_NAME "org/myextend/MyExtendHelper"


namespace myextend {
    namespace android {

//------------------------------
    bool AndroidBilling::purchase(const std::string& skuId)
    {
        cocos2d::JniMethodInfo methodInfo;

        if (!getJNIStaticMethodInfo(methodInfo, "purchase", "(Ljava/lang/String;)V")) {
            return false;
        }

        jstring stringskuId = methodInfo.env->NewStringUTF(skuId.c_str());

        methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID,
                                                               stringskuId);
        methodInfo.env->DeleteLocalRef(methodInfo.classID);
        return true;
    }

//-------------------------------
    bool AndroidBilling::getJNIStaticMethodInfo(cocos2d::JniMethodInfo &methodinfo,
                                                 const char *methodName,
                                                 const char *paramCode) {
            return cocos2d::JniHelper::getStaticMethodInfo(methodinfo,
                                                           CLASS_NAME,
                                                           methodName,
                                                           paramCode);
        }

    }
}