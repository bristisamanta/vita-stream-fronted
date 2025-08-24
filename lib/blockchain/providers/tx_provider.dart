import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../tx_submitter.dart';

class TxItem {
  String id;
  final String from;
  final String to;
  final double amount;
  String status;
  final DateTime time;
  final String? note;

  TxItem({required this.id, required this.from, required this.to, required this.amount, required this.status, required this.time, this.note});
}

class TxProvider with ChangeNotifier {
  final TxSubmitter submitter;
  final FlutterLocalNotificationsPlugin notifications;

  TxProvider({required this.submitter, required this.notifications});

  List<TxItem> history = [];
  bool sending = false;
  final Map<String, Timer> _pollers = {};

  Future<void> sendTx(String from, String to, double amount, {String? note}) async {
    sending = true; notifyListeners();
    try {
      final txId = await submitter.submitTransaction({'from': from, 'to': to, 'amount': amount, 'note': note});
      final item = TxItem(id: txId, from: from, to: to, amount: amount, status: 'pending', time: DateTime.now(), note: note);
      history.insert(0, item);
      notifyListeners();
      _startPolling(txId);
    } finally {
      sending = false; notifyListeners();
    }
  }

  void _startPolling(String txId) {
    _pollers[txId]?.cancel();
    _pollers[txId] = Timer.periodic(const Duration(seconds: 5), (t) async {
      try {
        final status = await submitter.getTxStatus(txId);
        final idx = history.indexWhere((h) => h.id == txId);
        if (idx != -1) {
          history[idx].status = status;
          notifyListeners();
        }
        if (status == 'success' || status == 'failed') {
          await notifications.show(
            txId.hashCode,
            'Transaction ${status.toUpperCase()}',
            'Tx $txId is $status',
            const NotificationDetails(
              android: AndroidNotificationDetails('tx_channel', 'Transactions', importance: Importance.high),
            ),
          );
          _pollers[txId]?.cancel();
        }
      } catch (_) {
        // network error -> will retry on next tick
      }
    });
  }

  Future<void> fetchHistory(String address) async {
    final list = await submitter.fetchHistory(address);
    history = list.map((m) => TxItem(
      id: m['id'] as String,
      from: m['from'] as String,
      to: m['to'] as String,
      amount: (m['amount'] as num).toDouble(),
      status: m['status'] as String,
      time: DateTime.parse(m['time'] as String),
      note: m['note'] as String?,
    )).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    for (final t in _pollers.values) {
      t.cancel();
    }
    super.dispose();
  }
}
