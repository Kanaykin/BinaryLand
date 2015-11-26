if not exist gen mkdir gen

echo %QTDIR%
"%QTDIR%/bin/moc.exe" DiagramScene.h -o gen/moc_DiagramScene.cpp
"%QTDIR%/bin/moc.exe" GlWindow.h -o gen/moc_GlWindow.cpp
"%QTDIR%/bin/moc.exe" MainWindow.h -o gen/moc_MainWindow.cpp
"%QTDIR%/bin/moc.exe" GettingSizeDialog.h -o gen/moc_GettingSizeDialog.cpp
"%QTDIR%/bin/moc.exe" ExplorerPanel.h -o gen/moc_ExplorerPanel.cpp

"%QTDIR%/bin/moc.exe" QtPropertyBrowser/qtbuttonpropertybrowser.h -o gen/moc_qtbuttonpropertybrowser.cpp
"%QTDIR%/bin/moc.exe" QtPropertyBrowser/qteditorfactory.h -o gen/moc_qteditorfactory.cpp
"%QTDIR%/bin/moc.exe" QtPropertyBrowser/qtgroupboxpropertybrowser.h -o gen/moc_qtgroupboxpropertybrowser.cpp
"%QTDIR%/bin/moc.exe" QtPropertyBrowser/qtpropertybrowser.h -o gen/moc_qtpropertybrowser.cpp
"%QTDIR%/bin/moc.exe" QtPropertyBrowser/qtpropertybrowserutils_p.h -o gen/moc_qtpropertybrowserutils_p.cpp
"%QTDIR%/bin/moc.exe" QtPropertyBrowser/qtpropertymanager.h -o gen/moc_qtpropertymanager.cpp
"%QTDIR%/bin/moc.exe" QtPropertyBrowser/qttreepropertybrowser.h -o gen/moc_qttreepropertybrowser.cpp
"%QTDIR%/bin/moc.exe" QtPropertyBrowser/qtvariantproperty.h -o gen/moc_qtvariantproperty.cpp

"%QTDIR%/bin/rcc.exe" -name resources res/resorces.qrc -o gen/rc_resorces.cpp

"%QTDIR%/bin/uic.exe" res/ui/GettingSize.ui -o gen/GettingSize.h
"%QTDIR%/bin/uic.exe" res/ui/ButtonPanel.ui -o gen/ButtonPanel.h
"%QTDIR%/bin/uic.exe" res/ui/ExplorerPanel.ui -o gen/ExplorerPanel.h