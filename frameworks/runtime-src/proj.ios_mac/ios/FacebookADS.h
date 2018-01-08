#ifndef FacebookADS_hpp
#define FacebookADS_hpp

#include "Advertisement.h"

namespace myextend {
    namespace ios {
        
        class FacebookADS: public Advertisement
        {
        public:
            bool showADS();
			int getStatusADS();
			void cancelADS();
        };
        
    }
}

#endif /* FacebookADS_hpp */
