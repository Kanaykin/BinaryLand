#ifndef __CC_GETTINGSIZEDIALOG_H__
#define __CC_GETTINGSIZEDIALOG_H__

#include <QtWidgets/QDialog>
#include <QtWidgets/QSpinBox>

class GettingSizeDialog : public QDialog
{
	Q_OBJECT
public:
	explicit GettingSizeDialog(QWidget *parent = 0);

private slots:
	void accept();

signals:
	void sigDataAccept(int width, int height);

private:
	QSpinBox *mWidthEdit;
	QSpinBox *mHeightEdit;
};

#endif
