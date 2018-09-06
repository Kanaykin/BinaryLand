
#ifndef Billing_hpp
#define Billing_hpp

#include "cocos2d.h"

namespace myextend {
	class Billing
	{    public:
		/**
		 @brief Get the shared Engine object,it will new one when first time be called
		 */
		static Billing* getInstance();
		
		virtual ~Billing(){}
		
		virtual bool purchase(const std::string& /*skuId*/){ return false; }
		
	};

}
#endif /* Advertisement_hpp */
	
