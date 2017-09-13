
#include "Statistic.h"
#include "GoogleAnalitics.h"

using namespace myextend;

static Statistic *s_pEngine = 0;

Statistic* Statistic::getInstance()
{
    if (! s_pEngine) {
        s_pEngine = new android::GoogleAnalitics();
    }
    
    return s_pEngine;
}
