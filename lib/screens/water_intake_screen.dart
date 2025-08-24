import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../l10n/app_localizations.dart';

class WaterIntakeScreen extends StatefulWidget {
  const WaterIntakeScreen({super.key});

  @override
  State<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends State<WaterIntakeScreen> {
  int dailyGoal = 3000; // in ml
  int consumed = 1200; // sample value
  bool remindersOn = true;
  String nextReminder = "2:30 PM";

  List<Map<String, String>> intakeLogs = [
    {"time": "8:00 AM", "amount": "250 ml"},
    {"time": "10:30 AM", "amount": "300 ml"},
    {"time": "1:00 PM", "amount": "650 ml"},
  ];

  // Dummy weekly data (ml per day)
  final List<int> weeklyIntake = [2500, 2800, 3000, 1500, 2000, 3100, 2700];

  void _addWater(int amount) {
    setState(() {
      consumed += amount;
      intakeLogs.insert(0, {
        "time": TimeOfDay.now().format(context),
        "amount": "$amount ml",
      });
    });
  }

  void _setGoalDialog() {
    final t = AppLocalizations.of(context)!; // ✅
    final TextEditingController controller =
        TextEditingController(text: dailyGoal.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.setDailyGoal), // ✅ localized
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: t.enterGoal, // ✅
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel), // ✅
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                dailyGoal = int.tryParse(controller.text) ?? dailyGoal;
              });
              Navigator.pop(context);
            },
            child: Text(t.save), // ✅
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: weeklyIntake.asMap().entries.map((entry) {
            int index = entry.key;
            int value = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value.toDouble(),
                  color: Colors.blueAccent,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }).toList(),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final days = ["M", "T", "W", "T", "F", "S", "S"];
                  if (value.toInt() < days.length) {
                    return Text(days[value.toInt()]);
                  }
                  return const Text("");
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // ✅ localization
    double progress = consumed / dailyGoal;
    if (progress > 1) progress = 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.waterIntakeTitle), // ✅
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: _setGoalDialog,
            icon: const Icon(Icons.edit),
            tooltip: t.setDailyGoal, // ✅
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "${t.dailyGoal}: $dailyGoal ml", // ✅
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      color: Colors.white,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${t.consumed}: $consumed ml", // ✅
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Reminder Status
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Icon(
                  remindersOn ? Icons.alarm_on : Icons.alarm_off,
                  color: remindersOn ? Colors.green : Colors.red,
                ),
                title: Text(remindersOn
                    ? t.hydrationRemindersOn
                    : t.hydrationRemindersOff), // ✅
                subtitle: Text("${t.nextReminder}: $nextReminder"), // ✅
                trailing: Switch(
                  value: remindersOn,
                  onChanged: (val) {
                    setState(() {
                      remindersOn = val;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Weekly Chart
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(t.weeklyTrend,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)), // ✅
                    _buildWeeklyChart(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Intake Logs
            Text(t.todayLogs,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)), // ✅
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: intakeLogs.length,
                itemBuilder: (context, index) {
                  final log = intakeLogs[index];
                  return ListTile(
                    leading: const Icon(Icons.local_drink,
                        color: Colors.blueAccent),
                    title: Text(log["amount"]!),
                    subtitle: Text("At ${log["time"]}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Button to Add Water
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addWater(250), // adds 250 ml
        icon: const Icon(Icons.add),
        label: Text(t.addWater), // ✅
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
