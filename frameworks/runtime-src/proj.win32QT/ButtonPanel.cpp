#include "ButtonPanel.h"
#include "gen/ButtonPanel.h"
#include "mainwindow.h"
#include "DiagramItem.h"

ButtonPanel::ButtonPanel(MainWindow* mainWnd) :
mSignalMapper(0)
{
	Ui_ButtonsForm form;
	form.setupUi(this);
	
	QButtonGroup* group = new QButtonGroup(this);
	mSignalMapper = new QSignalMapper(mainWnd);
	initButton(group, DiagramItem::BUSH_ITEM, "treeButton");
	initButton(group, DiagramItem::HUNTER_ITEM, "hunterButton");
	initButton(group, DiagramItem::DOG_ITEM, "dogButton");
	initButton(group, DiagramItem::CAGE_ITEM, "cageButton");
	initButton(group, DiagramItem::FOXGIRL_ITEM, "foxGirlButton");
	initButton(group, DiagramItem::FOX_ITEM, "foxButton");
	initButton(group, DiagramItem::COIN_ITEM, "coinButton");
	initButton(group, DiagramItem::FOXY_ITEM, "foxyButton");
	initButton(group, DiagramItem::DELETE_ITEM, "deleteButton");
	initButton(group, DiagramItem::ARROW_ITEM, "arrowButton");
	initButton(group, DiagramItem::TIME_BONUS_ITEM, "timeButton");
	initButton(group, DiagramItem::CHEST_BONUS_ITEN, "chestButton");
	
	connect(mSignalMapper, SIGNAL(mapped(int)), mainWnd, SLOT(onButtonCheck(int)));
	
	group->setExclusive(true);
}

void ButtonPanel::initButton(QButtonGroup* group, int type, const std::string& tag)
{
	QPushButton *button = this->findChild<QPushButton *>(tag.c_str());

	if (button){
		QPixmap pixmap(DiagramItem::getIconByType((DiagramItem::eTypeItem)type).c_str());
		QIcon ButtonIcon(pixmap);
		button->setIcon(ButtonIcon);
		connect(button, SIGNAL(clicked()), mSignalMapper, SLOT(map()));
		mSignalMapper->setMapping(button, type);
		group->addButton(button);
	}
}

ButtonPanel::~ButtonPanel()
{
}
