#include "ExplorerPanel.h"
#include "gen/ExplorerPanel.h"
#include "DiagramItem.h"
#include "QtPropertyBrowser/qttreepropertybrowser.h"
#include "QtPropertyBrowser/qtpropertymanager.h"
#include "QtPropertyBrowser/qteditorfactory.h"
#include "DiagramScene.h"
#include "DiagramItem.h"

//-----------------------------------------------
ExplorerPanel::ExplorerPanel():
mProjectTree(0),
mProjectRoot(0),
mScene(0),
mPropertyBrowser(0),
mBoolManager(0),
mIntManager(0),
mStringManager(0),
mSizeManager(0),
mRectManager(0),
mSizePolicyManager(0),
mEnumManager(0),
mGroupManager(0)
{
	Ui_ExplorerPanel form;
	form.setupUi(this);

	mProjectTree = this->findChild<QTreeWidget *>("ProjectExplorerTree");
	QObject::connect(mProjectTree, SIGNAL(itemPressed(QTreeWidgetItem*, int)), this, SLOT(onItemPressed(QTreeWidgetItem*, int)));

	QWidget *w = new QWidget();
	mBoolManager = new QtBoolPropertyManager(w);
	mIntManager = new QtIntPropertyManager(w);
	mStringManager = new QtStringPropertyManager(w);
	mSizeManager = new QtSizePropertyManager(w);
	mRectManager = new QtRectPropertyManager(w);
	mSizePolicyManager = new QtSizePolicyPropertyManager(w);
	mEnumManager = new QtEnumPropertyManager(w);
	mGroupManager = new QtGroupPropertyManager(w);

	mPropertyBrowser = new QtTreePropertyBrowser();

	QtCheckBoxFactory *checkBoxFactory = new QtCheckBoxFactory(w);
	QtSpinBoxFactory *spinBoxFactory = new QtSpinBoxFactory(w);
	QtSliderFactory *sliderFactory = new QtSliderFactory(w);
	QtScrollBarFactory *scrollBarFactory = new QtScrollBarFactory(w);
	QtLineEditFactory *lineEditFactory = new QtLineEditFactory(w);
	QtEnumEditorFactory *comboBoxFactory = new QtEnumEditorFactory(w);

	mPropertyBrowser->setFactoryForManager(mBoolManager, checkBoxFactory);
	mPropertyBrowser->setFactoryForManager(mIntManager, spinBoxFactory);
	mPropertyBrowser->setFactoryForManager(mStringManager, lineEditFactory);
	mPropertyBrowser->setFactoryForManager(mSizeManager->subIntPropertyManager(), spinBoxFactory);
	mPropertyBrowser->setFactoryForManager(mRectManager->subIntPropertyManager(), spinBoxFactory);
	mPropertyBrowser->setFactoryForManager(mSizePolicyManager->subIntPropertyManager(), spinBoxFactory);
	mPropertyBrowser->setFactoryForManager(mSizePolicyManager->subEnumPropertyManager(), comboBoxFactory);
	mPropertyBrowser->setFactoryForManager(mEnumManager, comboBoxFactory);

	QWidget* propertyTree = this->findChild<QWidget *>("PropertyTree");
	QGridLayout *layout = new QGridLayout(propertyTree);
	layout->setContentsMargins(0, 0, 0, 0);
	layout->addWidget(mPropertyBrowser, 0, 0);

	QObject::connect(mIntManager, SIGNAL(valueChanged(QtProperty*, int)), this, SLOT(onIntValueChanged(QtProperty*, int)));
	QObject::connect(mBoolManager, SIGNAL(valueChanged(QtProperty*, bool)), this, SLOT(onBoolValueChanged(QtProperty*, bool)));
}

//-----------------------------------------------
QTreeWidgetItem* ExplorerPanel::addTreeRoot(const QString& name)
{
	QTreeWidgetItem *treeItem = new QTreeWidgetItem(mProjectTree);
	treeItem->setText(0, name);
	return treeItem;
}

//-----------------------------------------------
ExplorerPanel::PropertySetFunc_t ExplorerPanel::getSetterByProperty(QtProperty* prop)const
{
	PropertySetMap_t::const_iterator citer = mPropertySetters.find(prop);
	if (citer != mPropertySetters.end())
		return citer->second;
	return ExplorerPanel::PropertySetFunc_t();
}

//-----------------------------------------------
void ExplorerPanel::onBoolValueChanged(QtProperty* prop, bool val)
{
	ExplorerPanel::PropertySetFunc_t func = getSetterByProperty(prop);
	if (func)
		func(QVariant(val));
}

//-----------------------------------------------
void ExplorerPanel::onIntValueChanged(QtProperty* prop, int val)
{
	ExplorerPanel::PropertySetFunc_t func = getSetterByProperty(prop);
	if (func)
		func(QVariant(val));
}

//-----------------------------------------------
void ExplorerPanel::showProjectPropertyTree()
{
	/*QtProperty *item0 = mGroupManager->addProperty("QObject");
	QtProperty *item1 = mStringManager->addProperty("objectName");
	item0->addSubProperty(item1);
	QtProperty *item2 = mBoolManager->addProperty("enabled");
	item0->addSubProperty(item2);*/
	mPropertySetters.clear();
	QtProperty *item0 = mIntManager->addProperty("Time");
	mIntManager->setValue(item0, mScene->getTime());

	mPropertyBrowser->addProperty(item0);

	PropertySetFunc_t func = std::bind(&DiagramScene::setTime, mScene, std::placeholders::_1);
	mPropertySetters.insert(std::make_pair(item0, func));
}

//-----------------------------------------------
void ExplorerPanel::showItemProperty(DiagramItem* item)
{
	mPropertySetters.clear();
	const DiagramItem::VariantMap_t& properties = item->getProperties();
	for (DiagramItem::VariantMap_t::const_iterator citer = properties.begin(); citer != properties.end(); ++citer){
		if ((*citer).second.type() == QVariant::Bool){
			QtProperty *item0 = mBoolManager->addProperty(QString::fromStdString((*citer).first));
			mBoolManager->setValue(item0, (*citer).second.toBool());

			mPropertyBrowser->addProperty(item0);

			PropertySetFunc_t func = std::bind(&DiagramItem::setProperty, item, (*citer).first, std::placeholders::_1);
			mPropertySetters.insert(std::make_pair(item0, func));
		}
		else if ((*citer).second.type() == QVariant::Int){
			QtProperty *item0 = mIntManager->addProperty(QString::fromStdString((*citer).first));
			mIntManager->setValue(item0, (*citer).second.toInt());

			mPropertyBrowser->addProperty(item0);

			PropertySetFunc_t func = std::bind(&DiagramItem::setProperty, item, (*citer).first, std::placeholders::_1);
			mPropertySetters.insert(std::make_pair(item0, func));
		}
	}
}

//-----------------------------------------------
void ExplorerPanel::onItemPressed(QTreeWidgetItem* item, int column)
{
	mPropertyBrowser->clear();
	if (mProjectRoot == item) {
		showProjectPropertyTree();
	}
	else {
		DiagramItem * giagramItem = getDiagramItemByTreeItem(item);
		if (giagramItem)
			emit sigSelectItem(giagramItem);
		showItemProperty(giagramItem);
	}
}

//-----------------------------------------------
void ExplorerPanel::onCreateScene(DiagramScene* scene)
{
	if (mProjectRoot)
		delete mProjectRoot;
	mProjectRoot = addTreeRoot("Project");
	mScene = scene;
	mPropertyBrowser->clear();
	mPropertySetters.clear();
}

//-----------------------------------------------
void ExplorerPanel::onCreateItem(DiagramItem *movedItem)
{
	mPropertyBrowser->clear();
	resetSelectedItems();
	std::string name = DiagramItem::getNameByType(movedItem->getItemType());
	QTreeWidgetItem* item = addTreeChild(mProjectRoot, QString::fromStdString(name));
	mItems.insert(std::make_pair(movedItem, item));
}

//-----------------------------------------------
void ExplorerPanel::onSelectItem(DiagramItem *movedItem)
{
	resetSelectedItems();
	mPropertyBrowser->clear();
	QTreeWidgetItem* item = getTreeItemByDiagramItem(movedItem);
	if (item) 
		item->setSelected(true);
	showItemProperty(movedItem);
}

//-----------------------------------------------
void ExplorerPanel::onDeleteItem(DiagramItem *movedItem)
{
	mPropertyBrowser->clear();
	resetSelectedItems();
	QTreeWidgetItem* item = removeTreeItemByDiagramItem(movedItem);
	if (item)
		delete item;
}

//-----------------------------------------------
DiagramItem* ExplorerPanel::getDiagramItemByTreeItem(QTreeWidgetItem* item)
{
	for (ItemsMap_t::iterator citer = mItems.begin(); citer != mItems.end(); ++citer)
	{
		if ((*citer).second == item)
			return (*citer).first;
	}
	return 0;
}

//-----------------------------------------------
QTreeWidgetItem* ExplorerPanel::getTreeItemByDiagramItem(DiagramItem* movedItem)
{
	QTreeWidgetItem* result(0);
	ItemsMap_t::iterator citer = mItems.find(movedItem);
	if (citer != mItems.end()) {
		result = (*citer).second;
	}
	return result;
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
void ExplorerPanel::resetSelectedItems()
{
	QList<QTreeWidgetItem*> selectedItems = mProjectTree->selectedItems();
	for (int i = 0; i < selectedItems.size(); ++i) {
		selectedItems.at(i)->setSelected(false);
	}
}

//-----------------------------------------------
QTreeWidgetItem* ExplorerPanel::addTreeChild(QTreeWidgetItem* parent, const QString& name)
{
	QTreeWidgetItem *treeItem = new QTreeWidgetItem();
	treeItem->setText(0, name);
	parent->addChild(treeItem);

//	treeItem->setSelected(true);
	parent->setExpanded(true);
	return treeItem;
}

//-----------------------------------------------
ExplorerPanel::~ExplorerPanel()
{
}
