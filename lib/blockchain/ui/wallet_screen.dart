// lib/blockchain/ui/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _keyCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final wp = context.watch<WalletProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (wp.loading) const LinearProgressIndicator(),
            ListTile(
              title: const Text('Address'),
              subtitle: Text(wp.address ?? '-'),
            ),
            ListTile(
              title: const Text('Balance'),
              subtitle: Text(wp.balance != null ? wp.balance.toString() : '-'),
            ),
            TextField(controller: _keyCtrl, decoration: const InputDecoration(labelText: 'Private key')),
            TextField(controller: _addrCtrl, decoration: const InputDecoration(labelText: 'Address (optional)')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final key = _keyCtrl.text.trim();
                      final addr = _addrCtrl.text.trim().isEmpty ? null : _addrCtrl.text.trim();
                      if (key.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter private key')));
                        return;
                      }
                      await context.read<WalletProvider>().importPrivateKey(key, address: addr);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Key imported')));
                    },
                    child: const Text('Import Key'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: wp.address == null ? null : () => context.read<WalletProvider>().fetchBalance(),
                  child: const Text('Fetch Balance'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await context.read<WalletProvider>().clearWallet();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallet cleared')));
              },
              child: const Text('Clear Wallet'),
            ),
            if (wp.error != null) ...[
              const SizedBox(height: 8),
              Text(wp.error!, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}
