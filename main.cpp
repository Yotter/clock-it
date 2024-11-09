#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "clock.h"

void awesome() {
    qDebug() << "Hello!";
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Clock clock1("Clock1", 10, true);
    QObject::connect(&clock1, &Clock::timeout, &awesome);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("clockit", "Main");

    return app.exec();
}
