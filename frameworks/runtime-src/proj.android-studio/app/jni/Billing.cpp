#include "AndroidBilling.h"

using namespace myextend;

static Billing *s_pBilling = 0;

Billing* Billing::getInstance()
{
    if (! s_pBilling) {
        s_pBilling = new android::AndroidBilling();
    }

    return s_pBilling;
}
