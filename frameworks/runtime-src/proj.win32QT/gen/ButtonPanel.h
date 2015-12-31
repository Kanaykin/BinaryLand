/********************************************************************************
** Form generated from reading UI file 'ButtonPanel.ui'
**
** Created by: Qt User Interface Compiler version 5.5.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef BUTTONPANEL_H
#define BUTTONPANEL_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QFrame>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_ButtonsForm
{
public:
    QGridLayout *gridLayout;
    QFrame *frame;
    QGridLayout *gridLayout_3;
    QPushButton *treeButton;
    QPushButton *foxButton;
    QPushButton *coinButton;
    QPushButton *deleteButton;
    QPushButton *cageButton;
    QPushButton *foxyButton;
    QPushButton *hunterButton;
    QPushButton *dogButton;
    QPushButton *foxGirlButton;
    QPushButton *arrowButton;
    QPushButton *timeButton;
    QPushButton *chestButton;
    QPushButton *hiddenTrapButton;

    void setupUi(QWidget *ButtonsForm)
    {
        if (ButtonsForm->objectName().isEmpty())
            ButtonsForm->setObjectName(QStringLiteral("ButtonsForm"));
        ButtonsForm->resize(330, 524);
        gridLayout = new QGridLayout(ButtonsForm);
        gridLayout->setObjectName(QStringLiteral("gridLayout"));
        frame = new QFrame(ButtonsForm);
        frame->setObjectName(QStringLiteral("frame"));
        frame->setFrameShape(QFrame::StyledPanel);
        frame->setFrameShadow(QFrame::Raised);
        gridLayout_3 = new QGridLayout(frame);
        gridLayout_3->setObjectName(QStringLiteral("gridLayout_3"));
        treeButton = new QPushButton(frame);
        treeButton->setObjectName(QStringLiteral("treeButton"));
        treeButton->setMinimumSize(QSize(90, 90));
        treeButton->setMaximumSize(QSize(90, 90));
        treeButton->setIconSize(QSize(80, 80));
        treeButton->setCheckable(true);
        treeButton->setChecked(true);

        gridLayout_3->addWidget(treeButton, 0, 0, 1, 1);

        foxButton = new QPushButton(frame);
        foxButton->setObjectName(QStringLiteral("foxButton"));
        foxButton->setMinimumSize(QSize(90, 90));
        foxButton->setMaximumSize(QSize(90, 90));
        foxButton->setIconSize(QSize(80, 80));
        foxButton->setCheckable(true);

        gridLayout_3->addWidget(foxButton, 3, 1, 1, 1);

        coinButton = new QPushButton(frame);
        coinButton->setObjectName(QStringLiteral("coinButton"));
        coinButton->setMinimumSize(QSize(90, 90));
        coinButton->setMaximumSize(QSize(90, 90));
        coinButton->setIconSize(QSize(80, 80));
        coinButton->setCheckable(true);

        gridLayout_3->addWidget(coinButton, 4, 0, 1, 1);

        deleteButton = new QPushButton(frame);
        deleteButton->setObjectName(QStringLiteral("deleteButton"));
        deleteButton->setMinimumSize(QSize(90, 90));
        deleteButton->setMaximumSize(QSize(90, 90));
        deleteButton->setIconSize(QSize(80, 80));
        deleteButton->setCheckable(true);

        gridLayout_3->addWidget(deleteButton, 5, 0, 1, 1);

        cageButton = new QPushButton(frame);
        cageButton->setObjectName(QStringLiteral("cageButton"));
        cageButton->setMinimumSize(QSize(90, 90));
        cageButton->setMaximumSize(QSize(90, 90));
        cageButton->setIconSize(QSize(80, 80));
        cageButton->setCheckable(true);

        gridLayout_3->addWidget(cageButton, 2, 1, 1, 1);

        foxyButton = new QPushButton(frame);
        foxyButton->setObjectName(QStringLiteral("foxyButton"));
        foxyButton->setMinimumSize(QSize(90, 90));
        foxyButton->setMaximumSize(QSize(90, 90));
        foxyButton->setIconSize(QSize(80, 80));
        foxyButton->setCheckable(true);

        gridLayout_3->addWidget(foxyButton, 4, 1, 1, 1);

        hunterButton = new QPushButton(frame);
        hunterButton->setObjectName(QStringLiteral("hunterButton"));
        hunterButton->setMinimumSize(QSize(90, 90));
        hunterButton->setMaximumSize(QSize(90, 90));
        hunterButton->setIconSize(QSize(80, 80));
        hunterButton->setCheckable(true);

        gridLayout_3->addWidget(hunterButton, 0, 1, 1, 1);

        dogButton = new QPushButton(frame);
        dogButton->setObjectName(QStringLiteral("dogButton"));
        dogButton->setMinimumSize(QSize(90, 90));
        dogButton->setMaximumSize(QSize(90, 90));
        dogButton->setIconSize(QSize(80, 80));
        dogButton->setCheckable(true);

        gridLayout_3->addWidget(dogButton, 2, 0, 1, 1);

        foxGirlButton = new QPushButton(frame);
        foxGirlButton->setObjectName(QStringLiteral("foxGirlButton"));
        foxGirlButton->setMinimumSize(QSize(90, 90));
        foxGirlButton->setMaximumSize(QSize(90, 90));
        foxGirlButton->setIconSize(QSize(80, 80));
        foxGirlButton->setCheckable(true);

        gridLayout_3->addWidget(foxGirlButton, 3, 0, 1, 1);

        arrowButton = new QPushButton(frame);
        arrowButton->setObjectName(QStringLiteral("arrowButton"));
        arrowButton->setMinimumSize(QSize(90, 90));
        arrowButton->setMaximumSize(QSize(90, 90));
        arrowButton->setIconSize(QSize(80, 80));
        arrowButton->setCheckable(true);

        gridLayout_3->addWidget(arrowButton, 5, 1, 1, 1);

        timeButton = new QPushButton(frame);
        timeButton->setObjectName(QStringLiteral("timeButton"));
        timeButton->setMinimumSize(QSize(90, 90));
        timeButton->setMaximumSize(QSize(90, 90));
        timeButton->setIconSize(QSize(80, 80));
        timeButton->setCheckable(true);

        gridLayout_3->addWidget(timeButton, 0, 2, 1, 1);

        chestButton = new QPushButton(frame);
        chestButton->setObjectName(QStringLiteral("chestButton"));
        chestButton->setMinimumSize(QSize(90, 90));
        chestButton->setMaximumSize(QSize(90, 90));
        chestButton->setIconSize(QSize(80, 80));
        chestButton->setCheckable(true);

        gridLayout_3->addWidget(chestButton, 2, 2, 1, 1);

        hiddenTrapButton = new QPushButton(frame);
        hiddenTrapButton->setObjectName(QStringLiteral("hiddenTrapButton"));
        hiddenTrapButton->setMinimumSize(QSize(90, 90));
        hiddenTrapButton->setMaximumSize(QSize(90, 90));
        hiddenTrapButton->setIconSize(QSize(80, 80));
        hiddenTrapButton->setCheckable(true);

        gridLayout_3->addWidget(hiddenTrapButton, 3, 2, 1, 1);


        gridLayout->addWidget(frame, 0, 1, 1, 1);


        retranslateUi(ButtonsForm);

        QMetaObject::connectSlotsByName(ButtonsForm);
    } // setupUi

    void retranslateUi(QWidget *ButtonsForm)
    {
        ButtonsForm->setWindowTitle(QApplication::translate("ButtonsForm", "Form", 0));
        treeButton->setText(QString());
        foxButton->setText(QString());
        coinButton->setText(QString());
        deleteButton->setText(QString());
        cageButton->setText(QString());
        foxyButton->setText(QString());
        hunterButton->setText(QString());
        dogButton->setText(QString());
        foxGirlButton->setText(QString());
        arrowButton->setText(QString());
        timeButton->setText(QString());
        chestButton->setText(QString());
        hiddenTrapButton->setText(QString());
    } // retranslateUi

};

namespace Ui {
    class ButtonsForm: public Ui_ButtonsForm {};
} // namespace Ui

QT_END_NAMESPACE

#endif // BUTTONPANEL_H
