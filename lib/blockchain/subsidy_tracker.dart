import 'dart:convert';
import 'package:http/http.dart' as http;

class SubsidyTracker {
  final String apiUrl = "https://gov-database.com/subsidy"; // replace with real API

  Future<bool> checkSubsidyEligibility(String userId) async {
    final response = await http.get(Uri.parse("$apiUrl/$userId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["eligible"] ?? false;
    } else {
      throw Exception("Failed to fetch subsidy data");
    }
  }
}
