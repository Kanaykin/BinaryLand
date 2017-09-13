#include "GettingSizeDialog.h"
#include "gen/GettingSize.h"

GettingSizeDialog::GettingSizeDialog(QWidget *parent):
QDialog(parent)
{
	Ui_GettingSizeDialog ui;
	ui.setupUi(this);

	mWidthEdit = this->findChild<QSpinBox *>("widthEdit");
	mHeightEdit = this->findChild<QSpinBox *>("heightEdit");
}

void GettingSizeDialog::accept() 
{
	QDialog::accept();

	if (mWidthEdit && mHeightEdit){
		const int width = mWidthEdit->value();
		const int height = mHeightEdit->value();
		emit sigDataAccept(width, height);
	}
}
