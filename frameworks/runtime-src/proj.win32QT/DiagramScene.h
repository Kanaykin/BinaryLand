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
	explicit DiagramScene(QObject *parent = 0);
	void reset(const QSize& size);
	void setTypeItem(DiagramItem::eTypeItem typeItem){ mTypeItem = typeItem; }
	QString convertSceneToStr() const;
	void loadFromStr(const QString& str);
	QSize getSize() const { return mSize;  }
	static const int CELL_SIZE;
signals:
	void itemMoved(DiagramItem *movedItem, const QPointF &movedFromPosition);

protected:
	void mousePressEvent(QGraphicsSceneMouseEvent *event);
	void mouseReleaseEvent(QGraphicsSceneMouseEvent *event);
	void createItem(DiagramItem::eTypeItem	typeItem, const QPoint& cellPoint);
	void deleteItem(const QPoint& cellPoint);
	bool checkUniqueItemExists(const QPoint& cellPoint);

	static QPoint convertToCellPosition(const QPointF& mousePos);
	static QPointF convertCellToScenePosition(const QPoint& cellPos);
private:
	typedef std::vector<DiagramItem*> DiagramItemVec_t;

	DiagramItemVec_t			mItems;
	QSize						mSize;
	DiagramItem::eTypeItem		mTypeItem;
};

#endif
