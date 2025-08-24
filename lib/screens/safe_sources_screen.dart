import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../l10n/app_localizations.dart';

class SafeSourcesScreen extends StatefulWidget {
  const SafeSourcesScreen({super.key});

  @override
  State<SafeSourcesScreen> createState() => _SafeSourcesScreenState();
}

class _SafeSourcesScreenState extends State<SafeSourcesScreen> {
  TextEditingController searchController = TextEditingController();
  late List<Map<String, dynamic>> allSources;
  List<Map<String, dynamic>> filteredSources = [];

  // ✅ Localized sources list
  List<Map<String, dynamic>> getAllSources(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return [
      {
        "name": t.river,
        "status": t.statusGood,
        "distance": "2 km",
        "reliability": 0.9,
      },
      {
        "name": t.well,
        "status": t.statusModerate,
        "distance": "1.5 km",
        "reliability": 0.75,
      },
      {
        "name": t.pond,
        "status": t.statusSafe,
        "distance": "3 km",
        "reliability": 0.85,
      },
      {
        "name": t.stream,
        "status": t.statusUnsafe,
        "distance": "2.5 km",
        "reliability": 0.4,
      },
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ Initialize localized data here so it updates with language
    allSources = getAllSources(context);
    filteredSources = allSources;
  }

  void filterSources(String query) {
    setState(() {
      filteredSources = allSources
          .where((source) =>
              source["name"].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // ✅ localization

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          t.safeWaterSourcesTitle, // ✅ localized title
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 32, 152, 219),
              Color.fromARGB(255, 14, 112, 173),
              Color.fromARGB(255, 32, 152, 219),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
          child: Column(
            children: [
              _glassCard(_buildSearchBar(t)),
              const SizedBox(height: 20),
              ...filteredSources.map((source) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _glassCard(_buildSourceCard(source, t)),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassCard(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations t) {
    return TextField(
      controller: searchController,
      onChanged: filterSources,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: t.searchSourcesHint, // ✅ localized
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 16),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSourceCard(Map<String, dynamic> source, AppLocalizations t) {
    Color statusColor;
    switch (source["status"]) {
      case "Good":
      case "Safe":
      case "अच्छा":
      case "নিরাপদ":
        statusColor = Colors.greenAccent;
        break;
      case "Moderate":
      case "मध्यम":
      case "মধ্যম":
        statusColor = Colors.orangeAccent;
        break;
      default:
        statusColor = Colors.redAccent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          source["name"],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${t.status}: ${source["status"]} | ${t.distance}: ${source["distance"]}", // ✅ localized labels
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ),
        const SizedBox(height: 14),
        LinearPercentIndicator(
          lineHeight: 18,
          percent: source["reliability"],
          center: Text(
            "${(source["reliability"] * 100).toInt()}%",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          progressColor: Colors.tealAccent,
          backgroundColor: Colors.white30,
          barRadius: const Radius.circular(10),
        ),
      ],
    );
  }
}
