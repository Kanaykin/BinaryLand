
#ifndef BinaryLand_GoogleAnalitics_h
#define BinaryLand_GoogleAnalitics_h

#include "Statistic.h"

namespace myextend {
    namespace win {
        
        class GoogleAnalitics: public Statistic
        {
        public:
            void sendEvent(const std::string& eventName, const std::string& eventValue);
        };
        
    }
}

#endif
