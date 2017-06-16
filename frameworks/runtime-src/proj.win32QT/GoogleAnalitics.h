
#ifndef BinaryLand_GoogleAnalitics_h
#define BinaryLand_GoogleAnalitics_h

#include "Statistic.h"

namespace myextend {
    namespace win {
        
        class GoogleAnalitics: public Statistic
        {
        public:
			void sendEvent(const std::string& category, const std::string& action,
				const std::string& label, int value) override;

			void sendScreenName(const std::string& screenName) override;

			void sendTime(const std::string& category, const std::string& label,
				const std::string& variable, int value) override;

			void sendException(const std::string& description, bool fatal) override;
        };
        
    }
}

#endif
