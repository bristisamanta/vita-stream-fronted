import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

// ✅ Import localization
import '../l10n/app_localizations.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen>
    with SingleTickerProviderStateMixin {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<Map<String, TimeOfDay>> reminders = [];
  TimeOfDay recommendedStart = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay recommendedStop = const TimeOfDay(hour: 8, minute: 0);

  TimeOfDay? customStart;
  TimeOfDay? customStop;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    initNotifications();
    loadReminders();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('reminder_'));
    setState(() {
      reminders = keys.map((key) {
        final timeString = prefs.getString(key)!;
        final parts = timeString.split(':');
        return {
          'start':
              TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
          'stop':
              TimeOfDay(hour: int.parse(parts[2]), minute: int.parse(parts[3])),
        };
      }).toList();
    });
  }

  Future<void> saveReminder(TimeOfDay start, TimeOfDay stop) async {
    final prefs = await SharedPreferences.getInstance();
    final id = reminders.length + 1;
    await prefs.setString(
        'reminder_$id',
        '${start.hour}:${start.minute}:${stop.hour}:${stop.minute}');
    setState(() {
      reminders.add({'start': start, 'stop': stop});
    });
    scheduleReminder(id, 'Start Watering', start);
    scheduleReminder(id + 100, 'Stop Watering', stop);
  }

  Future<void> pickCustomTime(BuildContext context, bool isStart) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          customStart = time;
        } else {
          customStop = time;
        }
      });
    }
  }

  Future<void> scheduleReminder(int id, String title, TimeOfDay time) async {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Water Reminder',
      title,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'water_channel',
          'Water Reminders',
          channelDescription: 'Reminders to water crops',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Widget _glassCard(Widget child, {double margin = 10}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, childWidget) {
        return Opacity(
          opacity: _animationController.value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - _animationController.value)),
            child: childWidget,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: margin),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // ✅ localization

    return Scaffold(
      appBar: AppBar(title: Text(t.remindersTitle)),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(182, 110, 197, 255),
              Color.fromARGB(127, 2, 96, 172),
              Color.fromARGB(223, 147, 202, 232)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _glassCard(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.recommendedTimes,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 10),
                    Text('${t.start}: ${recommendedStart.format(context)}',
                        style: const TextStyle(fontSize: 18)),
                    Text('${t.stop}: ${recommendedStop.format(context)}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                )),
                _glassCard(Column(
                  children: [
                    Text(t.setCustomTimes,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.75),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 14),
                          ),
                          onPressed: () => pickCustomTime(context, true),
                          child: Text(
                              '${t.start}: ${customStart != null ? customStart!.format(context) : t.select}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.75),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 14),
                          ),
                          onPressed: () => pickCustomTime(context, false),
                          child: Text(
                              '${t.stop}: ${customStop != null ? customStop!.format(context) : t.select}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.withOpacity(0.75),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 42, vertical: 14),
                      ),
                      onPressed: (customStart != null && customStop != null)
                          ? () => saveReminder(customStart!, customStop!)
                          : null,
                      child: Text(t.saveReminder,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(t.activeReminders,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                ...reminders.map((reminder) => _glassCard(
                      ListTile(
                        leading: const Icon(Icons.alarm, color: Colors.white),
                        title: Text(
                            '${t.start}: ${reminder['start']!.format(context)} - ${t.stop}: ${reminder['stop']!.format(context)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final index = reminders.indexOf(reminder);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('reminder_${index + 1}');
                            await flutterLocalNotificationsPlugin
                                .cancel(index + 1);
                            await flutterLocalNotificationsPlugin
                                .cancel(index + 101);
                            setState(() {
                              reminders.removeAt(index);
                            });
                          },
                        ),
                      ),
                    )),
                const SizedBox(height: 18),
                _glassCard(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.tipsAlerts,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 10),
                    Text('- ${t.tip1}', style: const TextStyle(fontSize: 16)),
                    Text('- ${t.tip2}', style: const TextStyle(fontSize: 16)),
                    Text('- ${t.tip3}', style: const TextStyle(fontSize: 16)),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
