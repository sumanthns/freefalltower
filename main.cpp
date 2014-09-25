#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/freefalltower/main.qml"));
    viewer.showExpanded();
    viewer.setMaximumSize(QSize(1200, 1200));
    viewer.setPosition(QPoint(500,100));
    return app.exec();
}
