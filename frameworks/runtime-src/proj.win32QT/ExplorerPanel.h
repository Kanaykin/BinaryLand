#ifndef Explorer_panel_H
#define Explorer_panel_H

#include <QtWidgets/QWidget>
#include <QtWidgets/QTreeWidget>

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

protected:
	void showProjectPropertyTree();
private:
	QTreeWidgetItem* addTreeRoot(const QString& name);
	QTreeWidgetItem* addTreeChild(QTreeWidgetItem* parent, const QString& name);
	QTreeWidgetItem* removeTreeItemByDiagramItem(DiagramItem *movedItem);

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
};

#endif
