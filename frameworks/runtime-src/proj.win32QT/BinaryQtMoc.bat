if not exist gen mkdir gen

echo %QTDIR%
"%QTDIR%/bin/moc.exe" DiagramScene.h -o gen/moc_DiagramScene.cpp
"%QTDIR%/bin/moc.exe" GlWindow.h -o gen/moc_GlWindow.cpp
"%QTDIR%/bin/moc.exe" MainWindow.h -o gen/moc_MainWindow.cpp
"%QTDIR%/bin/moc.exe" GettingSizeDialog.h -o gen/moc_GettingSizeDialog.cpp
"%QTDIR%/bin/moc.exe" ExplorerPanel.h -o gen/moc_ExplorerPanel.cpp

"%QTDIR%/bin/rcc.exe" -name resources res/resorces.qrc -o gen/rc_resorces.cpp

"%QTDIR%/bin/uic.exe" res/ui/GettingSize.ui -o gen/GettingSize.h
"%QTDIR%/bin/uic.exe" res/ui/ButtonPanel.ui -o gen/ButtonPanel.h
"%QTDIR%/bin/uic.exe" res/ui/ExplorerPanel.ui -o gen/ExplorerPanel.h