/// What kind of event a notification represents — drives the icon/color in
/// `notification_row` (PROJECT.md 6.3) and where tapping the notification
/// deep-links to. Add new cases here as new notification-worthy events are
/// introduced, rather than hardcoding a new icon/deep-link per instance.
enum NotificationType { taskCredited, referralConverted, withdrawalQueued, streakBonus }
