// lib/blockchain/ui/tx_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tx_provider.dart';
import '../providers/wallet_provider.dart';

class TxHistoryScreen extends StatelessWidget {
  const TxHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final txp = context.watch<TxProvider>();
    final wp = context.watch<WalletProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: wp.address == null ? null : () => txp.fetchHistory(wp.address!),
            child: const Text('Refresh History'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: txp.history.length,
              itemBuilder: (_, i) {
                final t = txp.history[i];
                Color col = t.status == 'success' ? Colors.green : (t.status == 'pending' ? Colors.orange : Colors.red);
                return ListTile(
                  title: Text('${t.amount} → ${t.to}'),
                  subtitle: Text('${t.time.toLocal()} • ${t.note ?? ''}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: col.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Text(t.status.toUpperCase(), style: TextStyle(color: col)),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
