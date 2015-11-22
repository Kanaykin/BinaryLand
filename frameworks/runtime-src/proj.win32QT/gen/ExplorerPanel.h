/********************************************************************************
** Form generated from reading UI file 'ExplorerPanel.ui'
**
** Created by: Qt User Interface Compiler version 5.5.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef EXPLORERPANEL_H
#define EXPLORERPANEL_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QTreeWidget>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_ExplorerPanel
{
public:
    QGridLayout *gridLayout_2;
    QGridLayout *gridLayout;
    QWidget *widget;
    QTreeWidget *ProjectExplorerTree;

    void setupUi(QWidget *ExplorerPanel)
    {
        if (ExplorerPanel->objectName().isEmpty())
            ExplorerPanel->setObjectName(QStringLiteral("ExplorerPanel"));
        ExplorerPanel->resize(242, 524);
        ExplorerPanel->setMinimumSize(QSize(242, 0));
        ExplorerPanel->setMaximumSize(QSize(242, 16777215));
        gridLayout_2 = new QGridLayout(ExplorerPanel);
        gridLayout_2->setObjectName(QStringLiteral("gridLayout_2"));
        gridLayout = new QGridLayout();
        gridLayout->setObjectName(QStringLiteral("gridLayout"));
        widget = new QWidget(ExplorerPanel);
        widget->setObjectName(QStringLiteral("widget"));

        gridLayout->addWidget(widget, 1, 0, 1, 1);

        ProjectExplorerTree = new QTreeWidget(ExplorerPanel);
        QTreeWidgetItem *__qtreewidgetitem = new QTreeWidgetItem();
        __qtreewidgetitem->setText(0, QStringLiteral("1"));
        ProjectExplorerTree->setHeaderItem(__qtreewidgetitem);
        ProjectExplorerTree->setObjectName(QStringLiteral("ProjectExplorerTree"));
        ProjectExplorerTree->setMinimumSize(QSize(50, 0));
        ProjectExplorerTree->setColumnCount(1);
        ProjectExplorerTree->header()->setVisible(false);
        ProjectExplorerTree->header()->setStretchLastSection(true);

        gridLayout->addWidget(ProjectExplorerTree, 0, 0, 1, 1);


        gridLayout_2->addLayout(gridLayout, 0, 0, 1, 1);


        retranslateUi(ExplorerPanel);

        QMetaObject::connectSlotsByName(ExplorerPanel);
    } // setupUi

    void retranslateUi(QWidget *ExplorerPanel)
    {
        ExplorerPanel->setWindowTitle(QApplication::translate("ExplorerPanel", "Form", 0));
    } // retranslateUi

};

namespace Ui {
    class ExplorerPanel: public Ui_ExplorerPanel {};
} // namespace Ui

QT_END_NAMESPACE

#endif // EXPLORERPANEL_H
