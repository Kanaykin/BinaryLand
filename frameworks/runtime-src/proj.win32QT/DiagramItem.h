#ifndef DIAGRAMITEM_H
#define DIAGRAMITEM_H

#include <QtWidgets/QGraphicsPixmapItem >

class DiagramItem : public QGraphicsPixmapItem
{
public:
	enum eTypeItem {
		BUSH_ITEM = 1,
		HUNTER_ITEM,
		DOG_ITEM,
		CAGE_ITEM,
		FOXGIRL_ITEM,
		FOX_ITEM,
		COIN_ITEM,
		FOXY_ITEM,
		DELETE_ITEM
	};
	explicit DiagramItem(eTypeItem itemType);
	~DiagramItem();

	eTypeItem getItemType() const { return mItemType; }
	static std::string getIconByType(eTypeItem itemType);

private:
	eTypeItem mItemType;
};

#endif