#include "DiagramItem.h"

typedef std::map<DiagramItem::eTypeItem, DiagramItem::ItemData> ItemsDataMap_t;
ItemsDataMap_t fillItemsData() {
	ItemsDataMap_t result;

	result[DiagramItem::BUSH_ITEM] = { ":/images/bush.png", "Bush", -1 };
	result[DiagramItem::HUNTER_ITEM] = { ":/images/Hunter.png", "Hunter", 106 };
	result[DiagramItem::DOG_ITEM] = { ":/images/Dog.png", "Dog", 107 };
	result[DiagramItem::CAGE_ITEM] = { ":images/cage.png", "Cage", 104 };
	result[DiagramItem::FOXGIRL_ITEM] = { ":images/FoxGirl.png", "FoxGirl", 109 };
	result[DiagramItem::FOX_ITEM] = { ":images/Fox.png", "Fox", 108 };
	result[DiagramItem::COIN_ITEM] = { ":images/Coin.png", "Coin", 110 };
	result[DiagramItem::FOXY_ITEM] = { ":images/save_baby.png", "Baby", 103 };
	result[DiagramItem::DELETE_ITEM] = { ":images/delete.png", "", 0 };
	result[DiagramItem::ARROW_ITEM] = { ":images/arrow.png", "", 0 };

	return result;
};
static const ItemsDataMap_t  itemsData = fillItemsData();

//-----------------------------------------------------------
DiagramItem::DiagramItem(eTypeItem itemType, const QPoint& cellPoint) :
mItemType(itemType),
mPoint(cellPoint)
{
	if (itemType == DiagramItem::COIN_ITEM){
		mProperties.insert(std::make_pair("Count", QVariant(10)));
	}
	else if (itemType == DiagramItem::HUNTER_ITEM) {
		mProperties.insert(std::make_pair("CanAttack", QVariant(false)));
	}
	else if (itemType == DiagramItem::DOG_ITEM) {
		mProperties.insert(std::make_pair("CanSearch", QVariant(false)));
	}
}


//-----------------------------------------------------------
DiagramItem::~DiagramItem()
{
}

//-----------------------------------------------------------
std::string DiagramItem::getNameByType(eTypeItem itemType)
{
	ItemsDataMap_t::const_iterator citer = itemsData.find(itemType);
	if (citer != itemsData.end()) {
		return (*citer).second.mName;
	}
	return std::string();
}

//-----------------------------------------------------------
void DiagramItem::setProperty(const std::string& name, const QVariant& variant)
{
	mProperties[name] = variant;
}

//-----------------------------------------------------------
int DiagramItem::getIdByType(eTypeItem itemType)
{
	ItemsDataMap_t::const_iterator citer = itemsData.find(itemType);
	if (citer != itemsData.end()) {
		return (*citer).second.mId;
	}
	return 0;
}

//-----------------------------------------------------------
std::string DiagramItem::getIconByType(eTypeItem itemType)
{
	ItemsDataMap_t::const_iterator citer = itemsData.find(itemType);
	if (citer != itemsData.end()) {
		return (*citer).second.mIconName;
	}
	return std::string();
}
