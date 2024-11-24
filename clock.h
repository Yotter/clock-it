#ifndef CLOCK_H
#define CLOCK_H

#include <QObject>
#include <QDateTime>
#include <QTimer>

/**
 * @brief The main Clock class. Objects of this type represent a single, continuously counting
 * down timer. Internally, all that is needed to represent a clock is the time it started
 * counting down at and how long the clock should run for (IE time left is not stored and is
 * always calculated.
 */
class Clock : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(int intervalSeconds READ getIntervalSeconds WRITE setIntervalSeconds
                   NOTIFY intervalChanged FINAL)
    Q_PROPERTY(int timeLeftSeconds READ getTimeLeftSeconds NOTIFY ticks FINAL)
    Q_PROPERTY(int nCompletions READ getNCompletions NOTIFY nCompletionsChanged FINAL)
public:

    explicit Clock(QString name,
                   int intervalInSeconds,
                   bool isActive,
                   QDateTime startedAt = QDateTime(),
                   QObject *parent = nullptr);

public slots:
    /**
     * Q_PROPERTY getters
     */
    QString getName();
    int getTimeLeftSeconds();
    int getNCompletions();
    int getIntervalSeconds();

    /**
     * Q_PROPERTY setters
     */
    void setName(QString newName);
    void setIntervalSeconds(int newInterval);

    /**
     * @brief Stop the clock and begin counting anew from the top
     */
    void reset();


signals:
    /**
     * @brief Emits when the clock hits 0
     */
    void timeout();
    /**
     * @brief Emits every second that this clock is active
     */
    void ticks();
    /**
     * @brief Emits when the name of this clock has been changed
     */
    void nameChanged();
    /**
     * @brief Emits when the number of times this clock has been "completed" changes
     */
    void nCompletionsChanged();
    /**
     * @brief Emits when the interval is changed.
     */
    void intervalChanged();

private:
    int intervalInSeconds;
    QDateTime startedAt; // Can be null if clock not active.
    bool isActive;
    QTimer expirationTimer;
    QTimer tickTimer;
    QString name;
    int nCompletions;
};

#endif // CLOCK_H
