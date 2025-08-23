import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../wallet_manager.dart';

class WalletProvider with ChangeNotifier {
  final WalletManager manager;
  final String backendBaseUrl;

  WalletProvider({required this.manager, required this.backendBaseUrl});

  String? _privateKey;
  String? _address;
  double? _balance;
  bool loading = false;
  String? error;

  String? get address => _address;
  double? get balance => _balance;

  Future<void> loadFromStorage() async {
    _privateKey = await manager.getPrivateKey();
    notifyListeners();
  }

  Future<void> importPrivateKey(String key, {String? address}) async {
    loading = true; error = null; notifyListeners();
    try {
      await manager.savePrivateKey(key);
      _privateKey = key;
      _address = address;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<void> clearWallet() async {
    await manager.deleteWallet();
    _privateKey = null;
    _address = null;
    _balance = null;
    notifyListeners();
  }

  Future<void> fetchBalance() async {
    if (_address == null) {
      error = 'No address set';
      notifyListeners();
      return;
    }
    loading = true; error = null; notifyListeners();
    try {
      final res = await http.get(Uri.parse('$backendBaseUrl/balance/$_address'));
      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        _balance = (j['balance'] as num).toDouble();
      } else {
        error = 'Failed (${res.statusCode})';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }
}
