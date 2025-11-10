import 'package:timezone/timezone.dart' as tz;
import 'package:device_calendar/device_calendar.dart';

class CalendarUtils {
  static final DeviceCalendarPlugin _deviceCalendarPlugin =
  DeviceCalendarPlugin();

  static Future<bool> requestCalendarPermission() async {
    final permissionsGranted = await _deviceCalendarPlugin.hasPermissions();

    if (permissionsGranted.isSuccess && permissionsGranted.data == true) {
      print("✅ Calendar permission already granted");
      return true;
    }

    final result = await _deviceCalendarPlugin.requestPermissions();
    final granted = result.isSuccess && result.data == true;
    print(granted
        ? "✅ Calendar permission granted"
        : "❌ Calendar permission denied");
    return granted;
  }

  static Future<void> addAppointmentsToSystemCalendar(
      DateTime startDateTime,DateTime endDateTime,String eventName,String desc) async {
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    final calendar = calendarsResult.data?.firstWhere(
          (cal) => cal.isDefault ?? false,
      // orElse: () => calendarsResult.data?.first,
    );
    final locationTimeZone = tz.getLocation('Asia/Riyadh');
    if (calendar == null) return;

      final existingEventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendar.id,
        RetrieveEventsParams(
          startDate: startDateTime,
          endDate: endDateTime,
        ),
      );

      final isDuplicate = existingEventsResult.data?.any((e) =>
      e.title == eventName &&
          e.start?.isAtSameMomentAs(startDateTime) == true &&
          e.end?.isAtSameMomentAs(endDateTime) == true) ??
          false;

      if (isDuplicate) {
        print(
            "📅 Skipped duplicate: ${eventName}");
        return ;
      }

      final event = Event(
        calendar.id,
        title: eventName,
        description: 'with ${desc}',
        start: tz.TZDateTime.from(startDateTime, locationTimeZone),
        end: tz.TZDateTime.from(endDateTime, locationTimeZone),
        reminders: [
          Reminder(minutes: 60),
          Reminder(minutes: 30),
          Reminder(minutes: 15),
          Reminder(minutes: 5),
        ],
      );

      await _deviceCalendarPlugin.createOrUpdateEvent(event);
      print("📅 Event added: ${eventName}");
  }
}