#include "clock.h"

Clock::Clock(QString name,
             int intervalInSeconds,
             bool isActive,
             QDateTime startedAt,
             QObject *parent)
    :
    name(name),
    intervalInSeconds(intervalInSeconds),
    isActive(isActive),
    QObject{parent}
{
    connect(&tickTimer, &QTimer::timeout, this, &Clock::ticks);
    connect(&expirationTimer, &QTimer::timeout, this, &Clock::timeout);
    expirationTimer.setInterval(intervalInSeconds * 1000);
    expirationTimer.setSingleShot(true);
    if (isActive) {
        // Start counting down
        if (startedAt.isNull()) {
            startedAt = QDateTime::currentDateTime();
        } else {
            startedAt = startedAt;
        }
        expirationTimer.start();
        tickTimer.start();
    } else {
        startedAt = QDateTime();
    }
}

QString Clock::getName()
{
    return name;
}

int Clock::getTimeLeftSeconds()
{
    if (startedAt.isNull()) {
        return intervalInSeconds;
    } else {
        QDateTime currTime = QDateTime::currentDateTime();
        return intervalInSeconds - (startedAt.msecsTo(currTime));
    }
}

int Clock::getNCompletions()
{
    return nCompletions;
}

int Clock::getIntervalSeconds()
{
    return intervalInSeconds;
}

void Clock::reset()
{
    // Stop clock
    expirationTimer.stop();
    tickTimer.stop();
    nCompletions++;
    emit nCompletionsChanged();

    // Restart clock
    startedAt = QDateTime::currentDateTime();
    emit ticks();
    expirationTimer.start();
    tickTimer.start();
}

void Clock::setName(QString newName)
{
    name = newName;
    emit nameChanged();
}

void Clock::setIntervalSeconds(int newInterval)
{
    intervalInSeconds = newInterval;
    emit intervalChanged();
}
