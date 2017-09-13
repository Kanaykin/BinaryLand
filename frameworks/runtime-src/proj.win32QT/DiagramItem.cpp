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
	result[DiagramItem::TORNADO_ITEN] = { ":images/Tornado.png", "Tornado", 116 };
	result[DiagramItem::ICE_GROUND_ITEN] = { ":images/IceGround.png", "IceGround", 117 };
	result[DiagramItem::SWAMP_GROUND_ITEN] = { ":images/SwampGround.png", "SwampGround", 118 };

	return result;
};
static const ItemsDataMap_t  itemsData = fillItemsData();

DiagramItem::CustomProperty::CustomProperty():
mType(TP_TYPE_BONUS)
{}

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
			QVariant tmp;
			CustomProperty val;
			val.setVal(0);
			tmp.setValue(val);
			//mProperties.insert(std::make_pair("ChestType", QVariant(QVariant::UserType, mProperty.get())));
			mProperties.insert(std::make_pair("ChestType", tmp));
	}break;
	case DiagramItem::BONUS_TREE_ITEN:
	case DiagramItem::BONUS_DOOR_ITEN:
	{
		QVariant property;
		CustomProperty val;
		val.setVal("");
		val.setType(CustomProperty::TP_TYPE_FILE);
		property.setValue(val);
		mProperties.insert(std::make_pair("BonusFile", QVariant("")));
	}break;
	case DiagramItem::TORNADO_ITEN:
	{
		mProperties.insert(std::make_pair("DestPoint", QVariant("1,1")));
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
		QVariant tmp;
		CustomProperty val;
		val.setVal(variant.toInt());
		tmp.setValue(val);

		mProperties[name] = tmp;
	}
	else if (name == "BonusFile" && variant.type() != QVariant::UserType) {
		QVariant tmp;
		CustomProperty val;
		val.setType(CustomProperty::TP_TYPE_FILE);
		val.setVal(variant.toString());
		tmp.setValue(val);

		mProperties[name] = tmp;
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
