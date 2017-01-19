#include "Advertisement.h"
#include "FacebookADS.h"

using namespace myextend;

static Advertisement *s_pAdvertisement = 0;

Advertisement* Advertisement::getInstance()
{
    if (! s_pAdvertisement) {
        s_pAdvertisement = new ios::FacebookADS();
    }
    
    return s_pAdvertisement;
}
