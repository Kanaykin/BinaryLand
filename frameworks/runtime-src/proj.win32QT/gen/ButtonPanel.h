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
#include <QtWidgets/QFormLayout>
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
    QFormLayout *formLayout;
    QPushButton *treeButton;
    QPushButton *hunterButton;
    QPushButton *dogButton;
    QPushButton *cageButton;
    QPushButton *foxGirlButton;
    QPushButton *foxButton;
    QPushButton *coinButton;
    QPushButton *foxyButton;
    QPushButton *deleteButton;
    QPushButton *arrowButton;

    void setupUi(QWidget *ButtonsForm)
    {
        if (ButtonsForm->objectName().isEmpty())
            ButtonsForm->setObjectName(QStringLiteral("ButtonsForm"));
        ButtonsForm->resize(234, 524);
        gridLayout = new QGridLayout(ButtonsForm);
        gridLayout->setObjectName(QStringLiteral("gridLayout"));
        frame = new QFrame(ButtonsForm);
        frame->setObjectName(QStringLiteral("frame"));
        frame->setFrameShape(QFrame::StyledPanel);
        frame->setFrameShadow(QFrame::Raised);
        formLayout = new QFormLayout(frame);
        formLayout->setObjectName(QStringLiteral("formLayout"));
        treeButton = new QPushButton(frame);
        treeButton->setObjectName(QStringLiteral("treeButton"));
        treeButton->setMinimumSize(QSize(90, 90));
        treeButton->setIconSize(QSize(80, 80));
        treeButton->setCheckable(true);
        treeButton->setChecked(true);

        formLayout->setWidget(0, QFormLayout::LabelRole, treeButton);

        hunterButton = new QPushButton(frame);
        hunterButton->setObjectName(QStringLiteral("hunterButton"));
        hunterButton->setMinimumSize(QSize(90, 90));
        hunterButton->setIconSize(QSize(80, 80));
        hunterButton->setCheckable(true);

        formLayout->setWidget(0, QFormLayout::FieldRole, hunterButton);

        dogButton = new QPushButton(frame);
        dogButton->setObjectName(QStringLiteral("dogButton"));
        dogButton->setMinimumSize(QSize(90, 90));
        dogButton->setIconSize(QSize(80, 80));
        dogButton->setCheckable(true);

        formLayout->setWidget(1, QFormLayout::LabelRole, dogButton);

        cageButton = new QPushButton(frame);
        cageButton->setObjectName(QStringLiteral("cageButton"));
        cageButton->setMinimumSize(QSize(90, 90));
        cageButton->setIconSize(QSize(80, 80));
        cageButton->setCheckable(true);

        formLayout->setWidget(1, QFormLayout::FieldRole, cageButton);

        foxGirlButton = new QPushButton(frame);
        foxGirlButton->setObjectName(QStringLiteral("foxGirlButton"));
        foxGirlButton->setMinimumSize(QSize(90, 90));
        foxGirlButton->setIconSize(QSize(80, 80));
        foxGirlButton->setCheckable(true);

        formLayout->setWidget(2, QFormLayout::LabelRole, foxGirlButton);

        foxButton = new QPushButton(frame);
        foxButton->setObjectName(QStringLiteral("foxButton"));
        foxButton->setMinimumSize(QSize(90, 90));
        foxButton->setIconSize(QSize(80, 80));
        foxButton->setCheckable(true);

        formLayout->setWidget(2, QFormLayout::FieldRole, foxButton);

        coinButton = new QPushButton(frame);
        coinButton->setObjectName(QStringLiteral("coinButton"));
        coinButton->setMinimumSize(QSize(90, 90));
        coinButton->setIconSize(QSize(80, 80));
        coinButton->setCheckable(true);

        formLayout->setWidget(3, QFormLayout::LabelRole, coinButton);

        foxyButton = new QPushButton(frame);
        foxyButton->setObjectName(QStringLiteral("foxyButton"));
        foxyButton->setMinimumSize(QSize(90, 90));
        foxyButton->setIconSize(QSize(80, 80));
        foxyButton->setCheckable(true);

        formLayout->setWidget(3, QFormLayout::FieldRole, foxyButton);

        deleteButton = new QPushButton(frame);
        deleteButton->setObjectName(QStringLiteral("deleteButton"));
        deleteButton->setMinimumSize(QSize(90, 90));
        deleteButton->setIconSize(QSize(80, 80));
        deleteButton->setCheckable(true);

        formLayout->setWidget(4, QFormLayout::LabelRole, deleteButton);

        arrowButton = new QPushButton(frame);
        arrowButton->setObjectName(QStringLiteral("arrowButton"));
        arrowButton->setMinimumSize(QSize(90, 90));
        arrowButton->setIconSize(QSize(80, 80));
        arrowButton->setCheckable(true);

        formLayout->setWidget(4, QFormLayout::FieldRole, arrowButton);


        gridLayout->addWidget(frame, 0, 0, 1, 1);


        retranslateUi(ButtonsForm);

        QMetaObject::connectSlotsByName(ButtonsForm);
    } // setupUi

    void retranslateUi(QWidget *ButtonsForm)
    {
        ButtonsForm->setWindowTitle(QApplication::translate("ButtonsForm", "Form", 0));
        treeButton->setText(QString());
        hunterButton->setText(QString());
        dogButton->setText(QString());
        cageButton->setText(QString());
        foxGirlButton->setText(QString());
        foxButton->setText(QString());
        coinButton->setText(QString());
        foxyButton->setText(QString());
        deleteButton->setText(QString());
        arrowButton->setText(QString());
    } // retranslateUi

};

namespace Ui {
    class ButtonsForm: public Ui_ButtonsForm {};
} // namespace Ui

QT_END_NAMESPACE

#endif // BUTTONPANEL_H
