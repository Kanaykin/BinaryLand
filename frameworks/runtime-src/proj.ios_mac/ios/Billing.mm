
#include "Billing.h"

using namespace myextend;

static Billing *s_pBilling = 0;

Billing* Billing::getInstance()
{
	if (! s_pBilling) {
		s_pBilling = new Billing();
	}
	
	return s_pBilling;
}
