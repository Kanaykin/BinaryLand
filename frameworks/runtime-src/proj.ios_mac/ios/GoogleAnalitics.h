
#ifndef BinaryLand_GoogleAnalitics_h
#define BinaryLand_GoogleAnalitics_h

#include "Statistic.h"

namespace myextend {
    namespace ios {
        
        class GoogleAnalitics: public Statistic
        {
        public:
            virtual void sendEvent(const std::string& category, const std::string& action,
                           const std::string& label) override;
            
            virtual void sendScreenName(const std::string& screenName) override;
        };
        
    }
}

#endif
