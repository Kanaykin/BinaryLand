
#ifndef BinaryLand_Statistic_h
#define BinaryLand_Statistic_h

#include "cocos2d.h"

namespace myextend {
    class Statistic
    {
    public:
        /**
         @brief Get the shared Engine object,it will new one when first time be called
         */
        static Statistic* getInstance();
        
        virtual void sendEvent(const std::string& eventName, const std::string& eventValue) = 0;
        
        virtual ~Statistic(){}
    };
}

#endif
