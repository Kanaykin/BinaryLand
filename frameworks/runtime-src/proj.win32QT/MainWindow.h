#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QtWidgets/QMainWindow>
#include <memory>

class DiagramScene;
class QGraphicsView;
class QTAplication;

class MainWindow : public QMainWindow
{
	Q_OBJECT
public:
	MainWindow();

	void onResize();

	void runCocos();
private slots:
	void onAddNew();
	void onSave();
	void onOpen();
	void onApplyScene();
	void onResetScene();
	void onDataAccept(int width, int height);
	void onButtonCheck(int button);
	void onTimer();

protected:
	void createFileMenu(QMenuBar *menuBar);
	void createSceneMenu(QMenuBar *menuBar);
	bool saveRunningScript(const QString& data);
	void restartGame();
private:
	void updateSize(int width, int height);
	DiagramScene*	mDiagramScene;
	QGraphicsView*	mView;
	QWidget*		mParentView;
	QSize			mSceneSize;
	QString			mCurrentFile;

	std::shared_ptr<QTAplication> mApp;
};

#endif
