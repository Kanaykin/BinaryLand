#ifndef DIAGRAMITEM_H
#define DIAGRAMITEM_H

#include <QtWidgets/QGraphicsPixmapItem >

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
		TIME_BONUS_ITEM
	};
	struct ItemData {
		std::string mIconName;
		std::string	mName;
		int mId;
	};
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
	eTypeItem		mItemType;
	VariantMap_t	mProperties;
	QPoint			mPoint;
};

#endif