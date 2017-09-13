#include "QtApplication.h"
#include <qpa/qplatformnativeinterface.h>
#include <QtGui/QGuiApplication>
#include "mainwindow.h"
//#include "glwidget.h"
#include "mainwindow.h"
#include "GLWindow.h"


QTAplication::QTAplication(MainWindow* wnd) :
mMainWind(wnd)
{

}

cocos2d::GLView* QTAplication::initView() const
{
	if (QWindow *whd = mMainWind->windowHandle()) {
		HWND hwnd =
			(HWND)QGuiApplication::platformNativeInterface()->nativeResourceForWindow(QByteArrayLiteral("handle"),
			whd);
		//GLViewQt* view = new GLViewQt(hwnd, mMainWind->getWnd()->getGLWidget());
		cocos2d::GLView* view = cocos2d::GLViewImpl::create("Endless");
		return view;
	}

	return 0;
	//glview->setFrameSize(800, 600);     // or whatever
	//director->setOpenGLView(glview);
}
