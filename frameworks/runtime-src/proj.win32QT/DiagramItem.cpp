#include "DiagramItem.h"

typedef std::map<DiagramItem::eTypeItem, DiagramItem::ItemData> ItemsDataMap_t;
ItemsDataMap_t fillItemsData() {
	ItemsDataMap_t result;

	result[DiagramItem::BUSH_ITEM] = { ":/images/bush.png", "Bush" };
	result[DiagramItem::HUNTER_ITEM] = { ":/images/Hunter.png", "Hunter" };
	result[DiagramItem::DOG_ITEM] = { ":/images/Dog.png", "Dog" };
	result[DiagramItem::CAGE_ITEM] = { ":images/cage.png", "Cage" };
	result[DiagramItem::FOXGIRL_ITEM] = { ":images/FoxGirl.png", "FoxGirl" };
	result[DiagramItem::FOX_ITEM] = { ":images/Fox.png", "Fox" };
	result[DiagramItem::COIN_ITEM] = { ":images/Coin.png", "Coin" };
	result[DiagramItem::FOXY_ITEM] = { ":images/save_baby.png", "Baby" };
	result[DiagramItem::DELETE_ITEM] = { ":images/delete.png", "" };
	result[DiagramItem::ARROW_ITEM] = { ":images/arrow.png", "" };

	return result;
};
static const ItemsDataMap_t  itemsData = fillItemsData();


DiagramItem::DiagramItem(eTypeItem itemType):
mItemType(itemType)
{
}


DiagramItem::~DiagramItem()
{
}

std::string DiagramItem::getNameByType(eTypeItem itemType)
{
	ItemsDataMap_t::const_iterator citer = itemsData.find(itemType);
	if (citer != itemsData.end()) {
		return (*citer).second.mName;
	}
	return std::string();
}

std::string DiagramItem::getIconByType(eTypeItem itemType)
{
	ItemsDataMap_t::const_iterator citer = itemsData.find(itemType);
	if (citer != itemsData.end()) {
		return (*citer).second.mIconName;
	}
	return std::string();
}
