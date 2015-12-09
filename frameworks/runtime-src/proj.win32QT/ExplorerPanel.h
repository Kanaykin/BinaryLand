#ifndef Explorer_panel_H
#define Explorer_panel_H

#include <QtWidgets/QWidget>
#include <QtWidgets/QTreeWidget>
#include <functional>

class DiagramScene;
class DiagramItem;
class QtAbstractPropertyBrowser;

class QtBoolPropertyManager;
class QtIntPropertyManager;
class QtStringPropertyManager;
class QtSizePropertyManager;
class QtRectPropertyManager;
class QtSizePolicyPropertyManager;
class QtEnumPropertyManager;
class QtGroupPropertyManager;
class QtProperty;

class ExplorerPanel : public QWidget
{
	Q_OBJECT
public:
	typedef std::map<DiagramItem*, QTreeWidgetItem*> ItemsMap_t;

	ExplorerPanel();
	~ExplorerPanel();

private slots:
	void onCreateScene(DiagramScene* scene);
	void onCreateItem(DiagramItem *movedItem);
	void onDeleteItem(DiagramItem *movedItem);
	void onItemPressed(QTreeWidgetItem* item, int column);
	void onSelectItem(DiagramItem *movedItem);
	void onIntValueChanged(QtProperty* prop, int val);
	void onBoolValueChanged(QtProperty* prop, bool val);
signals:
	void sigSelectItem(DiagramItem* item);

protected:
	void showProjectPropertyTree();
	void resetSelectedItems();
	void showItemProperty(DiagramItem* item);
	static bool isVisibleProperty(const std::string& name);

private:
	typedef std::function<void(const QVariant&)> PropertySetFunc_t;
	typedef std::map<QtProperty*, PropertySetFunc_t> PropertySetMap_t;
	PropertySetFunc_t getSetterByProperty(QtProperty* prop)const;

	QTreeWidgetItem* addTreeRoot(const QString& name);
	QTreeWidgetItem* addTreeChild(QTreeWidgetItem* parent, const QString& name);
	QTreeWidgetItem* removeTreeItemByDiagramItem(DiagramItem *movedItem);
	QTreeWidgetItem* getTreeItemByDiagramItem(DiagramItem *movedItem);
	DiagramItem*	getDiagramItemByTreeItem(QTreeWidgetItem* item);

	QTreeWidget* mProjectTree;
	QTreeWidgetItem* mProjectRoot;
	DiagramScene*	mScene;

	QtAbstractPropertyBrowser* mPropertyBrowser;

	/////////////////////////////////
	QtBoolPropertyManager * mBoolManager;
	QtIntPropertyManager * mIntManager;
	QtStringPropertyManager * mStringManager;
	QtSizePropertyManager * mSizeManager;
	QtRectPropertyManager * mRectManager;
	QtSizePolicyPropertyManager * mSizePolicyManager;
	QtEnumPropertyManager * mEnumManager;
	QtGroupPropertyManager *mGroupManager;
	/////////////////////////////////

	ItemsMap_t mItems;
	PropertySetMap_t	mPropertySetters;
};

#endif
