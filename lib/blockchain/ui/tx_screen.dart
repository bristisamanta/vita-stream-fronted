// lib/blockchain/ui/tx_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tx_provider.dart';
import '../providers/wallet_provider.dart';

class TxScreen extends StatefulWidget {
  const TxScreen({super.key});
  @override
  State<TxScreen> createState() => _TxScreenState();
}

class _TxScreenState extends State<TxScreen> {
  final _toCtrl = TextEditingController();
  final _amtCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final wp = context.watch<WalletProvider>();
    final txp = context.watch<TxProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Send Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(controller: _toCtrl, decoration: const InputDecoration(labelText: 'To address')),
            TextFormField(controller: _amtCtrl, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
            TextFormField(controller: _noteCtrl, decoration: const InputDecoration(labelText: 'Note (optional)')),
            const SizedBox(height: 12),
            txp.sending ? const CircularProgressIndicator() : ElevatedButton(
              onPressed: () async {
                if (wp.address == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Load/import wallet first')));
                  return;
                }
                final to = _toCtrl.text.trim();
                final amount = double.tryParse(_amtCtrl.text.trim());
                if (to.isEmpty || amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid to & amount')));
                  return;
                }
                await txp.sendTx(wp.address!, to, amount, note: _noteCtrl.text.trim());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction submitted')));
                _toCtrl.clear();
                _amtCtrl.clear();
                _noteCtrl.clear();
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
