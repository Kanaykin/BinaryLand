#include "DiagramItem.h"


DiagramItem::DiagramItem(eTypeItem itemType):
mItemType(itemType)
{
}


DiagramItem::~DiagramItem()
{
}

std::string DiagramItem::getIconByType(eTypeItem itemType)
{
	switch (itemType) {
	case DiagramItem::BUSH_ITEM:
		return ":/images/bush.png";
	case DiagramItem::HUNTER_ITEM:
		return ":/images/Hunter.png";
	case DiagramItem::DOG_ITEM:
		return ":/images/Dog.png";
	case DiagramItem::CAGE_ITEM:
		return ":images/cage.png";
	case DiagramItem::FOXGIRL_ITEM:
		return ":images/FoxGirl.png";
	case DiagramItem::FOX_ITEM:
		return ":images/Fox.png";
	case DiagramItem::COIN_ITEM:
		return ":images/Coin.png";
	case DiagramItem::FOXY_ITEM:
		return ":images/save_baby.png";
	case DiagramItem::DELETE_ITEM:
		return ":images/delete.png";
	};
}
