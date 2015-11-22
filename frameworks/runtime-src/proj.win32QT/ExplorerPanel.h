#ifndef Explorer_panel_H
#define Explorer_panel_H

#include <QtWidgets/QWidget>
#include <QtWidgets/QTreeWidget>

class DiagramScene;
class DiagramItem;
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

private:
	QTreeWidgetItem* addTreeRoot(const QString& name);
	QTreeWidgetItem* addTreeChild(QTreeWidgetItem* parent, const QString& name);
	QTreeWidgetItem* removeTreeItemByDiagramItem(DiagramItem *movedItem);

	QTreeWidget* mProjecrTree;
	QTreeWidgetItem* mProjectRoot;

	ItemsMap_t mItems;
};

#endif
