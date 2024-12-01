#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "clock.h"

void awesome() {
    qDebug() << "Hello!";
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    Clock clock1("Clock1", 10, true);
    QObject::connect(&clock1, &Clock::timeout, &awesome);

    engine.rootContext()->setContextProperty("clock1", &clock1);

    engine.loadFromModule("clockit", "Main");
    return app.exec();
}
