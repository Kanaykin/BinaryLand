#include "ExplorerPanel.h"
#include "gen/ExplorerPanel.h"
#include "DiagramItem.h"

//-----------------------------------------------
ExplorerPanel::ExplorerPanel():
mProjecrTree(0),
mProjectRoot(0)
{
	Ui_ExplorerPanel form;
	form.setupUi(this);

	mProjecrTree = this->findChild<QTreeWidget *>("ProjectExplorerTree");
}

//-----------------------------------------------
QTreeWidgetItem* ExplorerPanel::addTreeRoot(const QString& name)
{
	QTreeWidgetItem *treeItem = new QTreeWidgetItem(mProjecrTree);
	treeItem->setText(0, name);
	return treeItem;
}

//-----------------------------------------------
void ExplorerPanel::onCreateScene(DiagramScene* scene)
{
	if (mProjectRoot)
		delete mProjectRoot;
	mProjectRoot = addTreeRoot("Project");
}

//-----------------------------------------------
void ExplorerPanel::onCreateItem(DiagramItem *movedItem)
{
	std::string name = DiagramItem::getNameByType(movedItem->getItemType());
	QTreeWidgetItem* item = addTreeChild(mProjectRoot, QString::fromStdString(name));
	mItems.insert(std::make_pair(movedItem, item));
}

//-----------------------------------------------
void ExplorerPanel::onDeleteItem(DiagramItem *movedItem)
{
	QTreeWidgetItem* item = removeTreeItemByDiagramItem(movedItem);
	if (item)
		delete item;
}

//-----------------------------------------------
QTreeWidgetItem* ExplorerPanel::removeTreeItemByDiagramItem(DiagramItem *movedItem)
{
	QTreeWidgetItem* result(0);
	ItemsMap_t::iterator citer = mItems.find(movedItem);
	if (citer != mItems.end()) {
		result = (*citer).second;
		mItems.erase(citer);
	}
	return result;
}

//-----------------------------------------------
QTreeWidgetItem* ExplorerPanel::addTreeChild(QTreeWidgetItem* parent, const QString& name)
{
	QTreeWidgetItem *treeItem = new QTreeWidgetItem();
	treeItem->setText(0, name);
	parent->addChild(treeItem);

	return treeItem;
}

//-----------------------------------------------
ExplorerPanel::~ExplorerPanel()
{
}
