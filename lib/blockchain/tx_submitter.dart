// lib/blockchain/tx_submitter.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class TxSubmitter {
  final String baseUrl;
  TxSubmitter({required this.baseUrl});

  // submit transaction -> returns txId (expects backend returns {"txId": "..."} )
  Future<String> submitTransaction(Map<String, dynamic> txData) async {
    final res = await http.post(
      Uri.parse('$baseUrl/tx_submit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(txData),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final j = jsonDecode(res.body);
      if (j is Map && j['txId'] != null) return j['txId'] as String;
      return res.body;
    } else {
      throw Exception('Submit failed (${res.statusCode}): ${res.body}');
    }
  }

  // query status -> expects {"status":"pending"|"success"|"failed"}
  Future<String> getTxStatus(String txId) async {
    final res = await http.get(Uri.parse('$baseUrl/tx_status/$txId'));
    if (res.statusCode == 200) {
      final j = jsonDecode(res.body);
      return j['status'] as String? ?? 'unknown';
    } else {
      throw Exception('Status fetch failed: ${res.body}');
    }
  }

  // fetch history -> expects list of tx objects
  Future<List<Map<String, dynamic>>> fetchHistory(String address) async {
    final res = await http.get(Uri.parse('$baseUrl/transactions?wallet=$address'));
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return List<Map<String, dynamic>>.from(list);
    } else {
      throw Exception('History fetch failed: ${res.body}');
    }
  }
}
