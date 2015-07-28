#include <QtGui/QtGui>
#include <QtWidgets/QGraphicsSceneMouseEvent>
#include <QtWidgets/QMessageBox>

#include "diagramscene.h"
//#include "diagramitem.h"
#include "DiagramItem.h"

const int DiagramScene::CELL_SIZE = 50;
static QString  BEGIN_FILE = "local map = {";
static QString END_FILE = "} return {m=map";

#define CELL_POS(X, Y, W) ((X) + (W * Y))

DiagramScene::DiagramScene(QObject *parent)
	: QGraphicsScene(parent),
	mTypeItem(DiagramItem::BUSH_ITEM)
{
}

bool DiagramScene::checkUniqueItemExists(const QPoint& cellPoint)
{
	if (mTypeItem != DiagramItem::FOXGIRL_ITEM && mTypeItem != DiagramItem::FOX_ITEM && mTypeItem != DiagramItem::FOXY_ITEM)
		return false;
	const int count = mSize.width() * mSize.height();
	for (int i = 0; i != (count); i++){
		if (mItems[i] != 0 && mItems[i]->getItemType() == mTypeItem)
			return true;
	}
	return false;
}

void DiagramScene::createItem(DiagramItem::eTypeItem	typeItem, const QPoint& cellPoint)
{
	QPixmap pixmap(DiagramItem::getIconByType(typeItem).c_str());
	QPixmap pixmapScaled = pixmap.scaled(QSize(DiagramScene::CELL_SIZE, DiagramScene::CELL_SIZE), Qt::KeepAspectRatio);
	QSize pixmapSize = pixmapScaled.size();

	QPointF delta((DiagramScene::CELL_SIZE - pixmapSize.width()) / 2.0f, (DiagramScene::CELL_SIZE - pixmapSize.height()) / 2.0f);

	if (mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())])
	{
		QMessageBox msgBox;
		msgBox.setText("The cell is already filled.");
		msgBox.exec();
		return;
	}

	if (checkUniqueItemExists(cellPoint))
	{
		QMessageBox msgBox;
		msgBox.setText("The item already exists.");
		msgBox.exec();
		return;
	}

	DiagramItem *item = new DiagramItem(typeItem);
	item->setPixmap(pixmapScaled);
	addItem(item);

	item->setPos(DiagramScene::convertCellToScenePosition(cellPoint) + delta);
	mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())] = item;

}

void DiagramScene::deleteItem(const QPoint& cellPoint)
{
	if (mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())]) {
		DiagramItem* item = mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())];
		removeItem(item);
		delete item;
		mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())] = 0;
	}
}

void DiagramScene::mousePressEvent(QGraphicsSceneMouseEvent *event)
{
	if (mTypeItem == DiagramItem::DELETE_ITEM){
		deleteItem(DiagramScene::convertToCellPosition(event->scenePos()));
	}
	else
		createItem(mTypeItem, DiagramScene::convertToCellPosition(event->scenePos()));

	QGraphicsScene::mousePressEvent(event);
}

void DiagramScene::loadFromStr(const QString& str)
{
	QString result(str);
	if (!str.startsWith(BEGIN_FILE))
		return;
	result.remove(0, BEGIN_FILE.length());

	const int ind = result.indexOf(END_FILE);
	QString midStr = result.mid(0, ind);
	std::string str2 = midStr.toStdString();

	QString endStr = result.mid(ind);
	str2 = endStr.toStdString();
	endStr.remove(0, END_FILE.length() + 1);
	str2 = endStr.toStdString();

	QStringList list1 = endStr.split(',');
	QString widthStr = list1.at(0);
	widthStr.remove(0, 2); // remove 'w='
	std::string temp = widthStr.toStdString();
	QString heightStr = list1.at(1);
	heightStr.remove(0, 2); // remove 'h='
	heightStr.remove(heightStr.length() - 1, 1); // remove '}'
	temp = heightStr.toStdString();
	reset(QSize(widthStr.toInt(), heightStr.toInt()));

	QStringList listItems = midStr.split(',');

	for (int i = 0; i < listItems.size(); ++i){
		int type = listItems.at(i).toInt();
		if (type != 0)
			createItem((DiagramItem::eTypeItem)type, QPoint(i % mSize.width(), i / mSize.width()));
	}
}

QString DiagramScene::convertSceneToStr() const
{
	QString  result = BEGIN_FILE;
	for (int j = 0; j < mSize.height(); j++){
		for (int i = 0; i < mSize.width(); i++) {
			if (!(i == 0 && j == 0))
				result += QString(",");
			if (!mItems[CELL_POS(i, j, mSize.width())]) {
				result += QString("0");
			}
			else
				result += QString::number(mItems[CELL_POS(i, j, mSize.width())]->getItemType());
		}
	}
	result += END_FILE;
	result += QString(",w=") + QString::number(mSize.width());
	result += QString(",h=") + QString::number(mSize.height());
	result += "}";
	return result;
}

void DiagramScene::reset(const QSize& size)
{
	clear();
	mItems.clear();
	mSize = size;
	mItems.resize(size.width() * size.height(), 0);
}

QPointF DiagramScene::convertCellToScenePosition(const QPoint& cellPos)
{
	QPointF scenePos(float(cellPos.x() * DiagramScene::CELL_SIZE), float(cellPos.y() * DiagramScene::CELL_SIZE));
	return scenePos;
}

QPoint DiagramScene::convertToCellPosition(const QPointF& mousePos)
{
	QPoint cellPos(int(mousePos.x()) / DiagramScene::CELL_SIZE, int(mousePos.y()) / DiagramScene::CELL_SIZE);
	return cellPos;
}

void DiagramScene::mouseReleaseEvent(QGraphicsSceneMouseEvent *event)
{
	/*if (movingItem != 0 && event->button() == Qt::LeftButton) {
		if (oldPos != movingItem->pos())
			emit itemMoved(qgraphicsitem_cast<DiagramItem *>(movingItem),
			oldPos);
		movingItem = 0;
	}
	QGraphicsScene::mouseReleaseEvent(event);*/
}
