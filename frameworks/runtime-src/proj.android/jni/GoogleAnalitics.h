#ifndef __GOOGLE_ANALITICS_H__
#define __GOOGLE_ANALITICS_H__

#include "Statistic.h"
#include "platform/android/jni/JniHelper.h"

namespace myextend {
    namespace android {
        
        class GoogleAnalitics: public Statistic
        {
        public:
            void sendEvent(const std::string& event);
            
        private :
            static bool getJNIStaticMethodInfo(cocos2d::JniMethodInfo &methodinfo,
                                               const char *methodName,
                                               const char *paramCode);
        };
        
    }
}

#endif
