#ifndef DIAGRAMITEM_H
#define DIAGRAMITEM_H

#include <memory>
#include <QtWidgets/QGraphicsPixmapItem >
#include <QtCore/QMetaType>

class DiagramItem : public QGraphicsPixmapItem
{
public:
	typedef std::map<std::string, QVariant> VariantMap_t;
	enum eTypeItem {
		BUSH_ITEM = 1,
		HUNTER_ITEM,
		DOG_ITEM,
		CAGE_ITEM,
		FOXGIRL_ITEM,
		FOX_ITEM,
		COIN_ITEM,
		FOXY_ITEM,
		DELETE_ITEM,
		ARROW_ITEM,
		TIME_BONUS_ITEM,
		CHEST_BONUS_ITEN,
		HIDDEN_TRAP_ITEN,
		BONUS_TREE_ITEN,
		BONUS_DOOR_ITEN,
		TORNADO_ITEN,
		ICE_GROUND_ITEN
	};
	struct ItemData {
		std::string mIconName;
		std::string	mName;
		int mId;
	};
	class CustomProperty
	{
	public:
		enum TypeProperty {
			TP_TYPE_BONUS,
			TP_TYPE_FILE
		};
		CustomProperty();
		TypeProperty getType() const { return mType; }
		void setType(TypeProperty type) { mType = type; }
		QVariant getVal() const { return mVal; }
		void setVal(const QVariant& val){ mVal = val; }
	private:
		QVariant		mVal;
		TypeProperty	mType;
	};

	typedef std::shared_ptr<CustomProperty> CustomPropertyPtr;
	explicit DiagramItem(eTypeItem itemType, const QPoint& cellPoint);
	~DiagramItem();

	eTypeItem getItemType() const { return mItemType; }
	static std::string getIconByType(eTypeItem itemType);
	static std::string getNameByType(eTypeItem itemType);
	static int getIdByType(eTypeItem itemType);

	const VariantMap_t& getProperties() const { return mProperties; }
	void setProperty(const std::string& name, const QVariant& variant);
	void removeProperty(const std::string& name);
	QPoint getPoint() const { return mPoint; }
private:
	eTypeItem			mItemType;
	VariantMap_t		mProperties;
	QPoint				mPoint;
};

Q_DECLARE_METATYPE(DiagramItem::CustomProperty)

#endif