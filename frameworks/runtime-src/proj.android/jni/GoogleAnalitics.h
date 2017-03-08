#ifndef __GOOGLE_ANALITICS_H__
#define __GOOGLE_ANALITICS_H__

#include "Statistic.h"
#include "platform/android/jni/JniHelper.h"

namespace myextend {
    namespace android {
        
        class GoogleAnalitics: public Statistic
        {
        public:
            virtual void sendEvent(const std::string& category, const std::string& action,
                           const std::string& label, int value) override;
            
            virtual void sendScreenName(const std::string& screenName) override;
            
            virtual void sendTime(const std::string& category, const std::string& label,
                                  const std::string& variable, int value) override;
        private :
            static bool getJNIStaticMethodInfo(cocos2d::JniMethodInfo &methodinfo,
                                               const char *methodName,
                                               const char *paramCode);
        };
        
    }
}

#endif
