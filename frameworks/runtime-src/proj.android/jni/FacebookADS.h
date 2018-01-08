#ifndef FacebookADS_h
#define FacebookADS_h

#include "Advertisement.h"
#include "platform/android/jni/JniHelper.h"

namespace myextend {
    namespace android {
        
        class FacebookADS: public Advertisement
        {
        public:
            bool showADS();

            int getStatusADS();

            void cancelADS();
            
        private:
            //-------------------------------
            bool getJNIStaticMethodInfo(cocos2d::JniMethodInfo &methodinfo,
                                                     const char *methodName,
                                                     const char *paramCode);

        };
        
    }
}

#endif /* FacebookADS_hpp */
