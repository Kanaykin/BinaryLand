#include "ExplorerPanel.h"
#include "gen/ExplorerPanel.h"
#include "DiagramItem.h"
#include "QtPropertyBrowser/qttreepropertybrowser.h"
#include "QtPropertyBrowser/qtpropertymanager.h"
#include "QtPropertyBrowser/qteditorfactory.h"

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
	layout->addWidget(mPropertyBrowser, 0, 0);
}

//-----------------------------------------------
QTreeWidgetItem* ExplorerPanel::addTreeRoot(const QString& name)
{
	QTreeWidgetItem *treeItem = new QTreeWidgetItem(mProjectTree);
	treeItem->setText(0, name);
	return treeItem;
}

//-----------------------------------------------
void ExplorerPanel::showProjectPropertyTree()
{
	QtProperty *item0 = mGroupManager->addProperty("QObject");
	QtProperty *item1 = mStringManager->addProperty("objectName");
	item0->addSubProperty(item1);
	QtProperty *item2 = mBoolManager->addProperty("enabled");
	item0->addSubProperty(item2);

	mPropertyBrowser->addProperty(item0);
}

//-----------------------------------------------
void ExplorerPanel::onItemPressed(QTreeWidgetItem* item, int column)
{
	mPropertyBrowser->clear();
	if (mProjectRoot == item) {
		showProjectPropertyTree();
	}
	else {

	}
}

//-----------------------------------------------
void ExplorerPanel::onCreateScene(DiagramScene* scene)
{
	if (mProjectRoot)
		delete mProjectRoot;
	mProjectRoot = addTreeRoot("Project");
	mScene = scene;
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
