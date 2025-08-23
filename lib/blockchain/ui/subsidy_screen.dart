// lib/blockchain/ui/subsidy_screen.dart
import 'package:flutter/material.dart';
import '../../blockchain/subsidy_tracker.dart';

class SubsidyScreen extends StatefulWidget {
  const SubsidyScreen({super.key});
  @override
  State<SubsidyScreen> createState() => _SubsidyScreenState();
}

class _SubsidyScreenState extends State<SubsidyScreen> {
  final _idCtrl = TextEditingController();
  String? result;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subsidy Check')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _idCtrl, decoration: const InputDecoration(labelText: 'User ID / KYC ID')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () async {
              final id = _idCtrl.text.trim();
              if (id.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter ID'))); return; }
              setState(() { loading = true; result = null; });
              try {
                final tracker = SubsidyTracker();
                final eligible = await tracker.checkSubsidyEligibility(id);
                setState(() => result = eligible ? 'Eligible' : 'Not eligible');
              } catch (e) {
                setState(() => result = 'Error: $e');
              } finally {
                setState(() => loading = false);
              }
            }, child: loading ? const CircularProgressIndicator() : const Text('Check')),
            const SizedBox(height: 12),
            if (result != null) Text(result!, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
