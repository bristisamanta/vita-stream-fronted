import 'dart:convert';
import 'package:http/http.dart' as http;

class TxSubmitter {
  final String nodeUrl = "https://your-blockchain-node.com/submit"; // replace with real node

  Future<String> submitTransaction(Map<String, dynamic> txData) async {
    final response = await http.post(
      Uri.parse(nodeUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(txData),
    );

    if (response.statusCode == 200) {
      return "Transaction submitted successfully: ${response.body}";
    } else {
      throw Exception("Failed to submit transaction: ${response.body}");
    }
  }
}
