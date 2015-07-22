#ifndef WINDOW_H
#define WINDOW_H

#include <QtWidgets/QWidget>

class QSlider;
class QPushButton;

class DiagramScene;
class MainWindow;

class Window : public QWidget
{
	Q_OBJECT

public:
	Window(MainWindow *mw);

protected:
	//void keyPressEvent(QKeyEvent *event) Q_DECL_OVERRIDE;

	/*private slots:
	void dockUndock();

private:
	QSlider *createSlider();

	QSlider *xSlider;
	QSlider *ySlider;
	QSlider *zSlider;
	QPushButton *dockBtn;*/
	MainWindow *mainWindow;
	DiagramScene *glWidget;
};

#endif