#ifndef AndroidBilling_h
#define AndroidBilling_h

#include "Billing.h"
#include "platform/android/jni/JniHelper.h"

namespace myextend {
    namespace android {

        class AndroidBilling: public Billing
        {
        public:
            bool purchase(const std::string& skuId) override ;
        private:
            //-------------------------------
            bool getJNIStaticMethodInfo(cocos2d::JniMethodInfo &methodinfo,
                                        const char *methodName,
                                        const char *paramCode);

        };

    }
}

#endif /* FacebookADS_hpp */