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
	result[DiagramItem::TIME_BONUS_ITEM] = { ":images/Time.png", "Time", 111 };
	result[DiagramItem::CHEST_BONUS_ITEN] = { ":images/Chest.png", "Chest", 113 };
	result[DiagramItem::HIDDEN_TRAP_ITEN] = { ":images/trap.png", "HiddenTrap", 114 };
	result[DiagramItem::BONUS_TREE_ITEN] = { ":images/BonusBush.png", "BonusTree", 112 };
	result[DiagramItem::BONUS_DOOR_ITEN] = { ":images/BonusDoor.png", "BonusDoor", 112 };

	return result;
};
static const ItemsDataMap_t  itemsData = fillItemsData();

//-----------------------------------------------------------
DiagramItem::DiagramItem(eTypeItem itemType, const QPoint& cellPoint) :
mItemType(itemType),
mPoint(cellPoint)
{
	switch (itemType){
	case DiagramItem::COIN_ITEM: {
			mProperties.insert(std::make_pair("Count", QVariant(10)));
	}break;
	case DiagramItem::HUNTER_ITEM: {
			mProperties.insert(std::make_pair("CanAttack", QVariant(false)));
	}break;
	case DiagramItem::DOG_ITEM: {
			mProperties.insert(std::make_pair("CanSearch", QVariant(false)));
	}break;
	case DiagramItem::TIME_BONUS_ITEM: {
			mProperties.insert(std::make_pair("Count", QVariant(10)));
	}break;
	case DiagramItem::FOX_ITEM: 
	case DiagramItem::FOXGIRL_ITEM:
	{
		mProperties.insert(std::make_pair("InTrap", QVariant(false)));
	}break;
	case DiagramItem::CHEST_BONUS_ITEN: {
			mProperties.insert(std::make_pair("Count", QVariant(10)));
			mProperty.reset(new CustomProperty);
			mProperty->mIntVal = 0;
			mProperties.insert(std::make_pair("ChestType", QVariant(QVariant::UserType, mProperty.get())));
	}break;
	default: break;
	};
}

//-----------------------------------------------------------
void DiagramItem::removeProperty(const std::string& name)
{
	VariantMap_t::iterator iter = mProperties.find(name);
	if (iter != mProperties.end()) {
		mProperties.erase(iter);
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
	if (name == "ChestType" && variant.type() != QVariant::UserType) {
		mProperty.reset(new CustomProperty);
		mProperty->mIntVal = variant.toInt();
		mProperties[name] = QVariant(QVariant::UserType, mProperty.get());
	}
	else {
		mProperties[name] = variant;
	}
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
