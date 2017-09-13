#ifndef Button_panel_H
#define Button_panel_H

#include <QtWidgets/QWidget>
#include <QtCore/QSignalMapper>

class QButtonGroup;
class MainWindow;
class ButtonPanel : public QWidget
{
public:
	explicit ButtonPanel(MainWindow* mainWnd);
	~ButtonPanel();

protected:
	void initButton(QButtonGroup* group, int type, const std::string& tag);

private:
	QSignalMapper* mSignalMapper;
};

#endif