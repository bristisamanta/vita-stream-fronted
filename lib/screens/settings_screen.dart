import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 // your localization import

// Fallback localization class used when the generated `S` is not available.
// You can remove this once your project's generated localization class `S`
// is available via the appropriate import.
class S {
  final BuildContext context;
  S._(this.context);
  static S of(BuildContext context) => S._(context);

  String get settings => 'Settings';
  String get notifications => 'Notifications';
  String get language => 'Language';
  String get measurementUnits => 'Measurement Units';
  String get cropType => 'Crop Type';
  String get season => 'Season';
  String get waterSource => 'Water Source';
  String get soilType => 'Soil Type';
  String get aboutApp => 'About App';
  String get helpSupport => 'Help & Support';
  String get logout => 'Logout';
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = "English";
  String _measurementUnit = "Metric";
  String _selectedCrop = "Rice";
  String _season = "Kharif";
  String _waterSource = "Well";
  String _soilType = "Loamy";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // ✅ Load saved settings
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool("notifications") ?? true;
      _selectedLanguage = prefs.getString("language") ?? "English";
      _measurementUnit = prefs.getString("unit") ?? "Metric";
      _selectedCrop = prefs.getString("crop") ?? "Rice";
      _season = prefs.getString("season") ?? "Kharif";
      _waterSource = prefs.getString("waterSource") ?? "Well";
      _soilType = prefs.getString("soilType") ?? "Loamy";
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "VitaStream",
      applicationVersion: "1.0.0",
      applicationIcon: const Icon(Icons.water_drop, color: Colors.teal),
      children: [
        const Text("VitaStream is your water safety and health companion app."),
        const SizedBox(height: 8),
        const Text("Developed by Bristi & Amit 💙"),
      ],
    );
  }

  void _changeLanguage(String languageCode) {
    Locale newLocale;
    if (languageCode == "English") {
      newLocale = const Locale("en");
    } else if (languageCode == "Hindi") {
      newLocale = const Locale("hi");
    } else {
      newLocale = const Locale("bn");
    }

    // TODO: implement app-level locale change, e.g. call MyApp.setLocale(context, newLocale)
    // If your main app exposes a static setter like MyApp.setLocale, import that file and call it here.
    // For now we update local selection and persist it.
    setState(() => _selectedLanguage = languageCode);
    _saveSetting("language", languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings), // localized title
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Profile Section
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: const Text("Bristi Samanta"),
            subtitle: const Text("bristi@example.com"),
            trailing: const Icon(Icons.edit),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile edit coming soon!")),
              );
            },
          ),
          const Divider(),

          // Password Reset
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.teal),
            title: const Text("Reset Password"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password reset coming soon!")),
              );
            },
          ),
          const Divider(),

          // ✅ Notifications toggle
          SwitchListTile(
            secondary: const Icon(Icons.notifications, color: Colors.teal),
            title: Text(S.of(context).notifications),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              _saveSetting("notifications", val);
            },
          ),
          const Divider(),

          // ✅ Language Selection (Merged multilingual support here)
          ListTile(
            leading: const Icon(Icons.language, color: Colors.teal),
            title: Text(S.of(context).language),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: "English", child: Text("English")),
                DropdownMenuItem(value: "Hindi", child: Text("हिन्दी")),
                DropdownMenuItem(value: "Bengali", child: Text("বাংলা")),
              ],
              onChanged: (value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
          ),
          const Divider(),

          // ✅ Measurement Units
          ListTile(
            leading: const Icon(Icons.straighten, color: Colors.teal),
            title: Text(S.of(context).measurementUnits),
            trailing: DropdownButton<String>(
              value: _measurementUnit,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: "Metric", child: Text("Metric (°C, Ltr)")),
                DropdownMenuItem(value: "Imperial", child: Text("Imperial (°F, Gallon)")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _measurementUnit = value);
                  _saveSetting("unit", value);
                }
              },
            ),
          ),
          const Divider(),

          // ✅ Farm Profile
          ListTile(
            leading: const Icon(Icons.agriculture, color: Colors.teal),
            title: Text(S.of(context).cropType),
            trailing: DropdownButton<String>(
              value: _selectedCrop,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: "Rice", child: Text("Rice")),
                DropdownMenuItem(value: "Wheat", child: Text("Wheat")),
                DropdownMenuItem(value: "Maize", child: Text("Maize")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCrop = value);
                  _saveSetting("crop", value);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.teal),
            title: Text(S.of(context).season),
            trailing: DropdownButton<String>(
              value: _season,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: "Kharif", child: Text("Kharif")),
                DropdownMenuItem(value: "Rabi", child: Text("Rabi")),
                DropdownMenuItem(value: "Zaid", child: Text("Zaid")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _season = value);
                  _saveSetting("season", value);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.water, color: Colors.teal),
            title: Text(S.of(context).waterSource),
            trailing: DropdownButton<String>(
              value: _waterSource,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: "Well", child: Text("Well")),
                DropdownMenuItem(value: "Tubewell", child: Text("Tubewell")),
                DropdownMenuItem(value: "Canal", child: Text("Canal")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _waterSource = value);
                  _saveSetting("waterSource", value);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.landscape, color: Colors.teal),
            title: Text(S.of(context).soilType),
            trailing: DropdownButton<String>(
              value: _soilType,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: "Loamy", child: Text("Loamy")),
                DropdownMenuItem(value: "Clay", child: Text("Clay")),
                DropdownMenuItem(value: "Sandy", child: Text("Sandy")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _soilType = value);
                  _saveSetting("soilType", value);
                }
              },
            ),
          ),
          const Divider(),

          // About App
          ListTile(
            leading: const Icon(Icons.info, color: Colors.teal),
            title: Text(S.of(context).aboutApp),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(),

          // Help & Support
          ListTile(
            leading: const Icon(Icons.help, color: Colors.teal),
            title: Text(S.of(context).helpSupport),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Support page coming soon!")),
              );
            },
          ),
          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(S.of(context).logout),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
