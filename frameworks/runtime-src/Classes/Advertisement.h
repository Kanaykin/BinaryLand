#ifndef Advertisement_hpp
#define Advertisement_hpp

#include "cocos2d.h"

namespace myextend {
    class Advertisement
    {
    public:
        /**
         @brief Get the shared Engine object,it will new one when first time be called
         */
        static Advertisement* getInstance();
        
        virtual void showADS() = 0;
        
        virtual ~Advertisement(){}
    };
}

#endif /* Advertisement_hpp */
