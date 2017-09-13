/********************************************************************************
** Form generated from reading UI file 'GettingSize.ui'
**
** Created by: Qt User Interface Compiler version 5.5.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef GETTINGSIZE_H
#define GETTINGSIZE_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QDialog>
#include <QtWidgets/QDialogButtonBox>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QSpinBox>

QT_BEGIN_NAMESPACE

class Ui_GettingSizeDialog
{
public:
    QGridLayout *gridLayout_2;
    QGridLayout *gridLayout;
    QDialogButtonBox *buttonBox;
    QGroupBox *groupBox;
    QGridLayout *gridLayout_3;
    QSpinBox *widthEdit;
    QGroupBox *groupBox_2;
    QGridLayout *gridLayout_4;
    QSpinBox *heightEdit;

    void setupUi(QDialog *GettingSizeDialog)
    {
        if (GettingSizeDialog->objectName().isEmpty())
            GettingSizeDialog->setObjectName(QStringLiteral("GettingSizeDialog"));
        GettingSizeDialog->resize(217, 190);
        gridLayout_2 = new QGridLayout(GettingSizeDialog);
        gridLayout_2->setObjectName(QStringLiteral("gridLayout_2"));
        gridLayout = new QGridLayout();
        gridLayout->setObjectName(QStringLiteral("gridLayout"));
        buttonBox = new QDialogButtonBox(GettingSizeDialog);
        buttonBox->setObjectName(QStringLiteral("buttonBox"));
        buttonBox->setOrientation(Qt::Horizontal);
        buttonBox->setStandardButtons(QDialogButtonBox::Cancel|QDialogButtonBox::Ok);

        gridLayout->addWidget(buttonBox, 2, 0, 1, 1);

        groupBox = new QGroupBox(GettingSizeDialog);
        groupBox->setObjectName(QStringLiteral("groupBox"));
        gridLayout_3 = new QGridLayout(groupBox);
        gridLayout_3->setObjectName(QStringLiteral("gridLayout_3"));
        widthEdit = new QSpinBox(groupBox);
        widthEdit->setObjectName(QStringLiteral("widthEdit"));
        widthEdit->setMaximum(15);

        gridLayout_3->addWidget(widthEdit, 0, 0, 1, 1);


        gridLayout->addWidget(groupBox, 0, 0, 1, 1);

        groupBox_2 = new QGroupBox(GettingSizeDialog);
        groupBox_2->setObjectName(QStringLiteral("groupBox_2"));
        gridLayout_4 = new QGridLayout(groupBox_2);
        gridLayout_4->setObjectName(QStringLiteral("gridLayout_4"));
        heightEdit = new QSpinBox(groupBox_2);
        heightEdit->setObjectName(QStringLiteral("heightEdit"));

        gridLayout_4->addWidget(heightEdit, 0, 0, 1, 1);


        gridLayout->addWidget(groupBox_2, 1, 0, 1, 1);


        gridLayout_2->addLayout(gridLayout, 0, 0, 1, 1);


        retranslateUi(GettingSizeDialog);
        QObject::connect(buttonBox, SIGNAL(accepted()), GettingSizeDialog, SLOT(accept()));
        QObject::connect(buttonBox, SIGNAL(rejected()), GettingSizeDialog, SLOT(reject()));

        QMetaObject::connectSlotsByName(GettingSizeDialog);
    } // setupUi

    void retranslateUi(QDialog *GettingSizeDialog)
    {
        GettingSizeDialog->setWindowTitle(QApplication::translate("GettingSizeDialog", "Enter the size of field.", 0));
        groupBox->setTitle(QApplication::translate("GettingSizeDialog", "Width", 0));
        groupBox_2->setTitle(QApplication::translate("GettingSizeDialog", "Height", 0));
    } // retranslateUi

};

namespace Ui {
    class GettingSizeDialog: public Ui_GettingSizeDialog {};
} // namespace Ui

QT_END_NAMESPACE

#endif // GETTINGSIZE_H
