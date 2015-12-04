#include <QtGui/QtGui>
#include <QtWidgets/QGraphicsSceneMouseEvent>
#include <QtWidgets/QMessageBox>

#include "diagramscene.h"
//#include "diagramitem.h"
#include "DiagramItem.h"
#include "SceneLoader.h"

const int DiagramScene::CELL_SIZE = 50;
static QString  BEGIN_MAP = "local map = {";
static QString END_MAP = "}\n";

static QString  BEGIN_LEVEL_PROPERTIES = "local level = {\n";
static QString END_LEVEL_PROPERTIES = "}\n";

static QString  BEGIN_CUSTOM_PROPERTIES = "local CustomProperties = {\n";
static QString END_CUSTOM_PROPERTIES = "}\n";

#define CELL_POS(X, Y, W) ((X) + (W * Y))

DiagramScene::DiagramScene(QObject *parent)
	: QGraphicsScene(parent),
	mTypeItem(DiagramItem::BUSH_ITEM),
	mSelector(0),
	mTime(120)
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

DiagramItem* DiagramScene::createItemImpl(const QPoint& cellPoint, const QString& iconName, DiagramItem::eTypeItem typeItem)
{
	QPixmap pixmap(iconName);
	QPixmap pixmapScaled = pixmap.scaled(QSize(DiagramScene::CELL_SIZE, DiagramScene::CELL_SIZE), Qt::KeepAspectRatio);
	QSize pixmapSize = pixmapScaled.size();

	QPointF delta((DiagramScene::CELL_SIZE - pixmapSize.width()) / 2.0f, (DiagramScene::CELL_SIZE - pixmapSize.height()) / 2.0f);

	DiagramItem *item = new DiagramItem(typeItem, cellPoint);
	item->setPixmap(pixmapScaled);
	addItem(item);

	item->setPos(DiagramScene::convertCellToScenePosition(cellPoint) + delta);
	return item;
}

void DiagramScene::createItem(DiagramItem::eTypeItem typeItem, const QPoint& cellPoint)
{
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
	DiagramItem *item = createItemImpl(cellPoint, DiagramItem::getIconByType(typeItem).c_str(), typeItem);
	
	mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())] = item;

	emit sigCreateItem(item);
}

void DiagramScene::selectItem(const QPoint& cellPoint)
{
	if (mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())]) {
		DiagramItem* item = mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())];
		
		if (mSelector)
			delete mSelector;
		mSelector = createItemImpl(cellPoint, ":images/border.png", DiagramItem::ARROW_ITEM);
		emit sigSelectItem(item);
	}
}

void DiagramScene::selectItem(DiagramItem *movedItem)
{
	QPointF pos = movedItem->scenePos();
	if (mSelector)
		delete mSelector;
	mSelector = createItemImpl(QPoint(pos.x() / DiagramScene::CELL_SIZE, pos.y() / DiagramScene::CELL_SIZE), ":images/border.png", DiagramItem::ARROW_ITEM);
}

void DiagramScene::setTypeItem(DiagramItem::eTypeItem typeItem)
{
	mTypeItem = typeItem;
	if (mSelector)
		delete mSelector;
	mSelector = 0;
}

void DiagramScene::deleteItem(const QPoint& cellPoint)
{
	if (mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())]) {
		DiagramItem* item = mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())];
		removeItem(item);
		emit sigDeleteItem(item);
		delete item;
		mItems[CELL_POS(cellPoint.x(), cellPoint.y(), mSize.width())] = 0;
	}
}

void DiagramScene::mousePressEvent(QGraphicsSceneMouseEvent *event)
{
	if (mTypeItem == DiagramItem::DELETE_ITEM){
		deleteItem(DiagramScene::convertToCellPosition(event->scenePos()));
	}
	else if (mTypeItem == DiagramItem::ARROW_ITEM) {
		selectItem(DiagramScene::convertToCellPosition(event->scenePos()));
	}
	else
		createItem(mTypeItem, DiagramScene::convertToCellPosition(event->scenePos()));

	QGraphicsScene::mousePressEvent(event);
}

void DiagramScene::loadFromFile(const QString& file)
{
	SceneLoader loader;
	if (loader.loadScene(file.toStdString())) {
		SceneLoader::PropertyContainer mapProps = loader.getRootContainer();
		std::map<int, int> map;
		if (mapProps.getIntContainer("m", map)){
			const int w = mapProps.getIntProperty("w");
			const int h = mapProps.getIntProperty("h");
			reset(QSize(w, h));
			for (std::map<int, int>::const_iterator citer = map.begin(); citer != map.end(); ++citer){
				const int type = (*citer).second;
				const int i = (*citer).first - 1;
				if (type != 0)
					createItem((DiagramItem::eTypeItem)type, QPoint(i % mSize.width(), i / mSize.width()));
			}
		}
		// level properties
		SceneLoader::PropertyContainer levelProps = mapProps.getContainer("levelParams");
		int time = levelProps.getIntProperty("time");
		if (time)
			mTime = time;
		// CustomProperties
		//SceneLoader::PropertyContainer customProps = mapProps.getContainer("CustomProperties");
		std::map<std::string, SceneLoader::PropertyContainer> mapProp;
		if (mapProps.getContainerContainer("CustomProperties", mapProp)){
			for (std::map<std::string, SceneLoader::PropertyContainer>::iterator citer = mapProp.begin(); citer != mapProp.end(); ++citer){
				QStringList list1 = QString::fromStdString((*citer).first).split('_');
				int x = (list1.at(0)).toInt() - 1;
				int y = mSize.height() - (list1.at(1)).toInt();
				if (x < 0 || y < 0)
					continue;
				DiagramItem* item = mItems[CELL_POS(x, y, mSize.width())];
				if (item) {
					std::map<std::string, QVariant> objProp;
					if ((*citer).second.getVariantContainer(/*(*citer).first,*/ objProp)){
						for (std::map<std::string, QVariant>::const_iterator prop = objProp.begin(); prop != objProp.end(); ++prop){
							item->setProperty((*prop).first, (*prop).second);
						}
					}
				}
			}
		}
	}
}

void DiagramScene::loadFromStr(const QString& str)
{

	QString result(str);
	if (!str.startsWith(BEGIN_MAP))
		return;
	result.remove(0, BEGIN_MAP.length());

	const int ind = result.indexOf(END_MAP);
	QString midStr = result.mid(0, ind);
	std::string str2 = midStr.toStdString();

	QString endStr = result.mid(ind);
	str2 = endStr.toStdString();
	endStr.remove(0, END_MAP.length() + 1);
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

//--------------------------------------------------
QString convertMapPropToStr(const DiagramItem::VariantMap_t& properties)
{
	QString  result;
	bool firstItem = true;
	for (DiagramItem::VariantMap_t::const_iterator ciProp = properties.begin(); ciProp != properties.end(); ++ciProp) {
		if (!firstItem)
			result += QString(",\n");
		firstItem = false;

		result += QString::fromStdString((*ciProp).first) + QString("=");
		QVariant val = (*ciProp).second;
		if (val.type() == QVariant::Bool) {
			const bool bVal = val.toBool();
			result += bVal ? QString("true") : QString("false");
		}
		else if (val.type() == QVariant::Int){
			result += QString::number(val.toInt());
		}
		//result += "\n";
	}
	return result;
}

//--------------------------------------------------
QString DiagramScene::convertObjectsPropToStr() const
{
	QString  result = BEGIN_CUSTOM_PROPERTIES;
	bool firstItem = true;
	for (DiagramItemVec_t::const_iterator citer = mItems.begin(); citer != mItems.end(); ++citer){
		DiagramItem* curr = (*citer);
		if (curr) {
			const DiagramItem::VariantMap_t& properties = curr->getProperties();
			if (!properties.empty()){
				if (!firstItem)
					result += QString(",\n");
				firstItem = false;
				QPoint point = curr->getPoint();
				result += QString("[\"") + QString::number(point.x() + 1) + QString("_") + QString::number(mSize.height() - point.y()) +
					QString("_") + QString::number(DiagramItem::getIdByType(curr->getItemType())) + QString("\"] = {\n");
				
				result += convertMapPropToStr(properties);
				result += QString("}");
			}
		}
	}
	result += END_CUSTOM_PROPERTIES;
	return result;
}

//--------------------------------------------------
QString DiagramScene::convertScenePropToStr() const
{
	QString  result = BEGIN_LEVEL_PROPERTIES;
	result += QString("time = ") + QString::number(getTime()) + QString("\n");
	result += END_LEVEL_PROPERTIES;
	return result;
}

//--------------------------------------------------
QString DiagramScene::convertSceneToStr() const
{
	QString  result = BEGIN_MAP;
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
	result += END_MAP;
	result += convertScenePropToStr();
	result += convertObjectsPropToStr();
	result += QString("return{ m = map");
	result += QString(",w=") + QString::number(mSize.width());
	result += QString(",h=") + QString::number(mSize.height());
	result += QString(",levelParams=level");
	result += QString(",CustomProperties=CustomProperties");
	result += "}";
	return result;
}

void DiagramScene::reset(const QSize& size)
{
	if (mSelector)
		delete mSelector;
	mSelector = 0;

	clear();
	mItems.clear();
	mSize = size;
	mItems.resize(size.width() * size.height(), 0);

	emit sigCreateScene(this);
}

QPointF DiagramScene::convertCellToScenePosition(const QPoint& cellPos)
{
	QPointF scenePos(float(cellPos.x() * DiagramScene::CELL_SIZE), float(cellPos.y() * DiagramScene::CELL_SIZE));
	return scenePos;
}

void DiagramScene::onSelectItem(DiagramItem *movedItem)
{
	selectItem(movedItem);
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

void DiagramScene::setTime(const QVariant& time)
{
	mTime = time.toInt();
}
