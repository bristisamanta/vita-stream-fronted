import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart'; // ✅ Localization import

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

  void _showAboutDialog(BuildContext context, AppLocalizations t) {
    showAboutDialog(
      context: context,
      applicationName: "VitaStream",
      applicationVersion: "1.0.0",
      applicationIcon: const Icon(Icons.water_drop, color: Colors.teal),
      children: [
        Text(t.aboutAppDescription), // localized description
        const SizedBox(height: 8),
        Text(t.developedBy),
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

    // TODO: call your app-level locale setter here
    setState(() => _selectedLanguage = languageCode);
    _saveSetting("language", languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // ✅ localization

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
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
            title: const Text("Bristi Samanta"), // You can make dynamic later
            subtitle: const Text("bristi@example.com"),
            trailing: const Icon(Icons.edit),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.profileEditTapped)),
              );
            },
          ),
          const Divider(),

          // Password Reset
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.teal),
            title: Text(t.resetPassword),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.resetPasswordComingSoon)),
              );
            },
          ),
          const Divider(),

          // Notifications toggle
          SwitchListTile(
            secondary: const Icon(Icons.notifications, color: Colors.teal),
            title: Text(t.notifications),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              _saveSetting("notifications", val);
            },
          ),
          const Divider(),

          // Language selection
          ListTile(
            leading: const Icon(Icons.language, color: Colors.teal),
            title: Text(t.language),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: "English", child: Text(t.english)),
                DropdownMenuItem(value: "Hindi", child: Text(t.hindi)),
                DropdownMenuItem(value: "Bengali", child: Text(t.bengali)),
              ],
              onChanged: (value) {
                if (value != null) _changeLanguage(value);
              },
            ),
          ),
          const Divider(),

          // Measurement units
          ListTile(
            leading: const Icon(Icons.straighten, color: Colors.teal),
            title: Text(t.measurementUnits),
            trailing: DropdownButton<String>(
              value: _measurementUnit,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(
                    value: "Metric", child: Text(t.metricUnits)),
                DropdownMenuItem(
                    value: "Imperial", child: Text(t.imperialUnits)),
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

          // Farm profile
          ListTile(
            leading: const Icon(Icons.agriculture, color: Colors.teal),
            title: Text(t.cropType),
            trailing: DropdownButton<String>(
              value: _selectedCrop,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: "Rice", child: Text(t.rice)),
                DropdownMenuItem(value: "Wheat", child: Text(t.wheat)),
                DropdownMenuItem(value: "Maize", child: Text(t.maize)),
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
            title: Text(t.season),
            trailing: DropdownButton<String>(
              value: _season,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: "Kharif", child: Text(t.kharif)),
                DropdownMenuItem(value: "Rabi", child: Text(t.rabi)),
                DropdownMenuItem(value: "Zaid", child: Text(t.zaid)),
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
            title: Text(t.waterSource),
            trailing: DropdownButton<String>(
              value: _waterSource,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: "Well", child: Text(t.well)),
                DropdownMenuItem(value: "Tubewell", child: Text(t.tubewell)),
                DropdownMenuItem(value: "Canal", child: Text(t.canal)),
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
            title: Text(t.soilType),
            trailing: DropdownButton<String>(
              value: _soilType,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: "Loamy", child: Text(t.loamy)),
                DropdownMenuItem(value: "Clay", child: Text(t.clay)),
                DropdownMenuItem(value: "Sandy", child: Text(t.sandy)),
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

          // About app
          ListTile(
            leading: const Icon(Icons.info, color: Colors.teal),
            title: Text(t.aboutApp),
            onTap: () => _showAboutDialog(context, t),
          ),
          const Divider(),

          // Help & Support
          ListTile(
            leading: const Icon(Icons.help, color: Colors.teal),
            title: Text(t.helpSupport),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.supportComingSoon)),
              );
            },
          ),
          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(t.logout),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
