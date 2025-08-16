import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = "English";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // ✅ Load saved settings from shared_preferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool("notifications") ?? true;
      _selectedLanguage = prefs.getString("language") ?? "English";
    });
  }

  // ✅ Save notification toggle
  Future<void> _saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notifications", value);
  }

  // ✅ Save language selection
  Future<void> _saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", lang);
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
        const Text("Developed by Bristi 💙"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
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
          ),
          const Divider(),

          // ✅ Notifications toggle
          SwitchListTile(
            secondary: const Icon(Icons.notifications, color: Colors.teal),
            title: const Text("Notifications"),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              _saveNotifications(val);
            },
          ),
          const Divider(),

          // ✅ Language Selection
          ListTile(
            leading: const Icon(Icons.language, color: Colors.teal),
            title: const Text("Language"),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: "English", child: Text("English")),
                DropdownMenuItem(value: "Hindi", child: Text("Hindi")),
                DropdownMenuItem(value: "Bengali", child: Text("Bengali")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLanguage = value);
                  _saveLanguage(value);
                }
              },
            ),
          ),
          const Divider(),

          // About App
          ListTile(
            leading: const Icon(Icons.info, color: Colors.teal),
            title: const Text("About App"),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(),

          // Help & Support
          ListTile(
            leading: const Icon(Icons.help, color: Colors.teal),
            title: const Text("Help & Support"),
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
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
