#ifndef __CC_QT_APPLICATION_H__
#define __CC_QT_APPLICATION_H__

#include "AppDelegate.h"
#include <QtWidgets/QMainWindow>

class MainWindow;

class QTAplication : public AppDelegate {
public:
	explicit QTAplication(MainWindow* wnd);
	cocos2d::GLView* initView() const;

private:
	MainWindow* mMainWind;
};

#endif __CC_QT_APPLICATION_H__
