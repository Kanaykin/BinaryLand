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
#include <QtWidgets/QFrame>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QTreeWidget>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_ExplorerPanel
{
public:
    QGridLayout *gridLayout_2;
    QVBoxLayout *verticalLayout;
    QTreeWidget *ProjectExplorerTree;
    QFrame *PropertyTree;

    void setupUi(QWidget *ExplorerPanel)
    {
        if (ExplorerPanel->objectName().isEmpty())
            ExplorerPanel->setObjectName(QStringLiteral("ExplorerPanel"));
        ExplorerPanel->resize(300, 524);
        ExplorerPanel->setMinimumSize(QSize(300, 0));
        ExplorerPanel->setMaximumSize(QSize(300, 16777215));
        gridLayout_2 = new QGridLayout(ExplorerPanel);
        gridLayout_2->setObjectName(QStringLiteral("gridLayout_2"));
        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName(QStringLiteral("verticalLayout"));
        ProjectExplorerTree = new QTreeWidget(ExplorerPanel);
        QTreeWidgetItem *__qtreewidgetitem = new QTreeWidgetItem();
        __qtreewidgetitem->setText(0, QStringLiteral("1"));
        ProjectExplorerTree->setHeaderItem(__qtreewidgetitem);
        ProjectExplorerTree->setObjectName(QStringLiteral("ProjectExplorerTree"));
        ProjectExplorerTree->setMinimumSize(QSize(50, 0));
        ProjectExplorerTree->setColumnCount(1);
        ProjectExplorerTree->header()->setVisible(false);
        ProjectExplorerTree->header()->setStretchLastSection(true);

        verticalLayout->addWidget(ProjectExplorerTree);

        PropertyTree = new QFrame(ExplorerPanel);
        PropertyTree->setObjectName(QStringLiteral("PropertyTree"));
        PropertyTree->setMinimumSize(QSize(50, 200));
        PropertyTree->setFrameShape(QFrame::StyledPanel);
        PropertyTree->setFrameShadow(QFrame::Raised);

        verticalLayout->addWidget(PropertyTree);


        gridLayout_2->addLayout(verticalLayout, 0, 0, 1, 1);


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
