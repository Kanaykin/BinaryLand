#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QtWidgets/QMainWindow>
class DiagramScene;
class QGraphicsView;
class MainWindow : public QMainWindow
{
	Q_OBJECT
public:
	MainWindow();

	void onResize();

private slots:
	void onAddNew();
	void onSave();
	void onOpen();
	void onDataAccept(int width, int height);
	void onButtonCheck(int button);
private:
	void updateSize(int width, int height);
	DiagramScene*	mDiagramScene;
	QGraphicsView*	mView;
	QWidget*		mParentView;
	QSize			mSceneSize;
};

#endif
