#ifndef DIAGRAMSCENE_H
#define DIAGRAMSCENE_H

#include <QtCore/QObject>
#include <QtWidgets/QGraphicsScene>
#include "DiagramItem.h"

class QGraphicsSceneDragDropEvent;
class QGraphicsViewItem;

class DiagramScene : public QGraphicsScene
{
	Q_OBJECT

public:
	typedef std::vector<DiagramItem*> DiagramItemVec_t;

	explicit DiagramScene(QObject *parent = 0);
	void reset(const QSize& size);
	void setTypeItem(DiagramItem::eTypeItem typeItem);

	QString convertSceneToStr() const;
	QString convertScenePropToStr() const;
	QString convertObjectsPropToStr() const;
	void autoSetDogToHunter();

	void loadFromStr(const QString& str);
	void loadFromFile(const QString& file);
	QSize getSize() const { return mSize;  }
	void setTime(const QVariant& time);
	int getTime() const { return mTime; }
	static const int CELL_SIZE;
signals:
	void itemMoved(DiagramItem *movedItem, const QPointF &movedFromPosition);
	void sigCreateScene(DiagramScene* scene);
	void sigCreateItem(DiagramItem *movedItem);
	void sigDeleteItem(DiagramItem *movedItem);
	void sigSelectItem(DiagramItem *movedItem);

protected slots:
	void onSelectItem(DiagramItem *movedItem);
protected:
	void mousePressEvent(QGraphicsSceneMouseEvent *event);
	void mouseReleaseEvent(QGraphicsSceneMouseEvent *event);
	void createItem(DiagramItem::eTypeItem	typeItem, const QPoint& cellPoint);
	void deleteItem(const QPoint& cellPoint);
	void selectItem(const QPoint& cellPoint);
	void selectItem(DiagramItem *movedItem);
	bool checkUniqueItemExists(const QPoint& cellPoint);
	QString convertToId(const QPoint& point, DiagramItem::eTypeItem type) const;

	DiagramItem* createItemImpl(const QPoint& cellPoint, const QString& iconName, DiagramItem::eTypeItem typeItem);

	static QPoint convertToCellPosition(const QPointF& mousePos);
	static QPointF convertCellToScenePosition(const QPoint& cellPos);
private:

	DiagramItemVec_t			mItems;
	QSize						mSize;
	DiagramItem::eTypeItem		mTypeItem;
	DiagramItem*				mSelector;

	//-------------------------------------------
	// Scene properties
	int							mTime;
};

#endif
