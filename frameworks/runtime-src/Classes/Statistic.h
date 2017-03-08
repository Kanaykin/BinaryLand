
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
        
        virtual void sendEvent(const std::string& category, const std::string& action,
                               const std::string& label, int value) = 0;
        
        virtual void sendScreenName(const std::string& screenName) = 0;
        
        virtual void sendTime(const std::string& category, const std::string& label,
                              const std::string& variable, int value) = 0;
        
        virtual ~Statistic(){}
    };
}

#endif
