#include "mainwindow.h"
//#include "window.h"
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMessageBox>
#include <QtWidgets/QGraphicsView>
#include <QtWidgets/QFileDialog>
#include <QtCore/QTextStream>
#include "GlWindow.h"
#include <QtWidgets/QHBoxLayout>
#include "diagramscene.h"
#include "GettingSizeDialog.h"
#include "ButtonPanel.h"
#include "ExplorerPanel.h"
#include "cocos2d.h"
#include "QtApplication.h"
#include <QtCore/QTimer>

static const int MAX_SIZE(500);

class ResizableWidget : public QWidget
{
public:
	explicit ResizableWidget(MainWindow* parent) :mWnd(parent){};
	void resizeEvent(QResizeEvent * event)
	{
		QWidget::resizeEvent(event);
		mWnd->onResize();
	}
private:
	MainWindow* mWnd;
};

MainWindow::MainWindow():
mDiagramScene(0),
mParentView(0)
{
	QMenuBar *menuBar = new QMenuBar;
	createFileMenu(menuBar);
	createSceneMenu(menuBar);

	setMenuBar(menuBar);

	mDiagramScene = new DiagramScene;
	QBrush pixmapBrush(QPixmap(":/images/cross.png"));
	mDiagramScene->setBackgroundBrush(pixmapBrush);
	//diagramScene->setSceneRect(QRect(0, 0, 500, 500));
	mDiagramScene->addText("bogotobogo.com", QFont("Arial", 20));


	QBrush greenBrush(Qt::green);
	QBrush blueBrush(Qt::blue);
	QPen outlinePen(Qt::black);
	outlinePen.setWidth(2);
	mDiagramScene->addRect(0, 0, 80, 80, outlinePen, blueBrush);

	//onAddNew();
	setWindowTitle("Undo Framework");
	mParentView = new ResizableWidget(this);
	mParentView->setMinimumSize(MAX_SIZE, MAX_SIZE);
	QGraphicsView *view = new QGraphicsView(mDiagramScene);

	QHBoxLayout *container = new QHBoxLayout;

	ExplorerPanel *widgetExplorer = new ExplorerPanel();
	container->addWidget(widgetExplorer);
	QObject::connect(mDiagramScene, SIGNAL(sigCreateScene(DiagramScene*)), widgetExplorer, SLOT(onCreateScene(DiagramScene*)));
	QObject::connect(mDiagramScene, SIGNAL(sigCreateItem(DiagramItem*)), widgetExplorer, SLOT(onCreateItem(DiagramItem*)));
	QObject::connect(mDiagramScene, SIGNAL(sigDeleteItem(DiagramItem*)), widgetExplorer, SLOT(onDeleteItem(DiagramItem*)));
	QObject::connect(mDiagramScene, SIGNAL(sigSelectItem(DiagramItem*)), widgetExplorer, SLOT(onSelectItem(DiagramItem*)));
	QObject::connect(widgetExplorer, SIGNAL(sigSelectItem(DiagramItem*)), mDiagramScene, SLOT(onSelectItem(DiagramItem*)));

	QHBoxLayout *container2 = new QHBoxLayout;
	container->addWidget(mParentView);
	container2->addWidget(view);
	mParentView->setLayout(container2);

	QWidget *widgetButtons = new ButtonPanel(this);
	container->addWidget(widgetButtons);

	//setCentralWidget(view);

	QWidget *w = new QWidget;
	w->setLayout(container);

	resize(700, 500);

	setCentralWidget(w);

	view->setAlignment(Qt::AlignLeft | Qt::AlignTop);
	//view->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
	//view->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
	mView = view;
	updateSize(0, 0);
}

void MainWindow::createFileMenu(QMenuBar *menuBar)
{
	QMenu *menuWindow = menuBar->addMenu(tr("&File"));
	QAction *addNew = new QAction(menuWindow);
	addNew->setText(tr("New"));
	menuWindow->addAction(addNew);
	connect(addNew, SIGNAL(triggered()), this, SLOT(onAddNew()));

	QAction *saveAction = new QAction(menuWindow);
	saveAction->setText(tr("Save"));
	menuWindow->addAction(saveAction);
	connect(saveAction, SIGNAL(triggered()), this, SLOT(onSave()));

	QAction *openAction = new QAction(menuWindow);
	openAction->setText(tr("Open"));
	menuWindow->addAction(openAction);
	connect(openAction, SIGNAL(triggered()), this, SLOT(onOpen()));
}

void MainWindow::createSceneMenu(QMenuBar *menuBar)
{
	QMenu *menuWindow = menuBar->addMenu(tr("&Scene"));
	QAction *actApply = new QAction(menuWindow);
	actApply->setText(tr("Apply"));
	menuWindow->addAction(actApply);

	connect(actApply, SIGNAL(triggered()), this, SLOT(onApplyScene()));

	QAction *actReset = new QAction(menuWindow);
	actReset->setText(tr("Reset"));
	menuWindow->addAction(actReset);

	connect(actReset, SIGNAL(triggered()), this, SLOT(onResetScene()));
}

void MainWindow::onButtonCheck(int button)
{
	mDiagramScene->setTypeItem((DiagramItem::eTypeItem)button);
}

void MainWindow::onResize()
{
	updateSize(mSceneSize.width(), mSceneSize.height());
}

void MainWindow::onOpen()
{
	QString fileName = QFileDialog::getOpenFileName(this, tr("Open File"),
		"",
		tr("Scene File (*.lua )"));
	QFile file(fileName);
	if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
		return;
	mCurrentFile = file.fileName();

	QString result;
	QTextStream instream(&file);
	while (!instream.atEnd()) {
		QString line = instream.readLine();
		result += line;
	}
	file.close();

	//mDiagramScene->loadFromStr(result);
	QFileInfo infoFile(mCurrentFile);
	mDiagramScene->loadFromFile(infoFile.fileName());
	const QSize size = mDiagramScene->getSize();
	updateSize(size.width(), size.height());
}

void MainWindow::onTimer()
{
	runCocos();
	//cocos2d::Application::getInstance()->run();
}

void MainWindow::runCocos()
{
	if (mApp) {
		mApp.reset();

		cocos2d::Director* dir = cocos2d::Director::getInstance();
		if (dir)
			dir->release();
	}
	mApp = std::make_shared<QTAplication>(this);
	int ret = cocos2d::Application::getInstance()->run();
}

bool MainWindow::saveRunningScript(const QString& dataStr)
{
	QString filePath = QDir::currentPath() + "\\src\\levels\\editor_scene.lua";
	QFile file(filePath);
	std::string dir = filePath.toStdString();
	if (!file.exists()) {
		return false;
	}
	file.open(QIODevice::WriteOnly);

	QString data = dataStr;
	QTextStream outstream(&file);
	outstream << data;
	file.close();

	return true;
}

void MainWindow::onResetScene()
{
	if (!saveRunningScript(QString(" ") )){
		QMessageBox msgBox;
		msgBox.setText("Can't write editor_scene.lua");
		msgBox.exec();
		return;
	}

	restartGame();
}

void MainWindow::restartGame()
{
	cocos2d::Director* director = cocos2d::Director::getInstance();
	if (director) {
		cocos2d::GLView* glview = director->getOpenGLView();
		if (glview) {
			//glview->end();
			cocos2d::Director::getInstance()->end();
			QTimer::singleShot(200, this, SLOT(onTimer()));
		}
	}
}

void MainWindow::onApplyScene()
{
	// check file exists
	QFileInfo infoFile(mCurrentFile);
	QFile file(QDir::currentPath() + "\\src\\levels\\" + infoFile.fileName());
	if (!file.exists()) {
		QMessageBox msgBox;
		msgBox.setText("Please save file to src/levels/");
		msgBox.exec();
		return;
	}

	QFileInfo info(file);
	if (!saveRunningScript(QString("return require ") + "\"src/levels/" +info.baseName() + "\"")){
		QMessageBox msgBox;
		msgBox.setText("Can't write editor_scene.lua");
		msgBox.exec();
		return;
	}

	restartGame();
}

void MainWindow::onSave()
{
	QString filename = QFileDialog::getSaveFileName(this, tr("Save File"),
		"",
		tr("Scene File (*.lua )"));
	QFile f(filename);
	mCurrentFile = f.fileName();
	f.open(QIODevice::WriteOnly);
	// store data in f
	QString data = mDiagramScene->convertSceneToStr();
	QTextStream outstream(&f);
	outstream << data;
	f.close();
}

void MainWindow::onAddNew()
{
	GettingSizeDialog* dlg = new GettingSizeDialog(this);

	QObject::connect(dlg, SIGNAL(sigDataAccept(int, int)), this, SLOT(onDataAccept(int, int)));

	dlg->exec();
}

void MainWindow::updateSize(int width, int height)
{
	mSceneSize = QSize(width, height);
	QSize sizeView = mParentView->size();

	QSize size(DiagramScene::CELL_SIZE * width, DiagramScene::CELL_SIZE * height);
	mDiagramScene->setSceneRect(QRect(0, 0, size.width(), size.height()));

	mView->setSceneRect(QRect(0, 0, size.width(), size.height()));
	const int MaxSizeX = sizeView.width() - 10;
	const int MaxSizeY = sizeView.height() - 10;
	const int deltaWidth = (size.height() > MaxSizeX) ? 22 : 2;
	const int deltaHeight = (size.width() > MaxSizeY) ? 22 : 2;

	if (size.width() > MaxSizeX) {
		size.setWidth(MaxSizeX);
		mView->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOn);
	}
	else {
		size.setWidth(size.width() + deltaWidth);
		mView->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
	}
	if (size.height() > MaxSizeY) {
		size.setHeight(MaxSizeY);
		mView->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOn);
	}
	else {
		size.setHeight(size.height() + deltaHeight);
		mView->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
	}
	mView->setMaximumSize(size);
	mView->setMinimumSize(size);

	//mView->setAlignment(Qt::AlignLeft | Qt::AlignTop);
}

void MainWindow::onDataAccept(int width, int height)
{
	if (width > 0 && height > 0) {
		mDiagramScene->reset(QSize(width, height));
		updateSize(width, height);
	}
}
