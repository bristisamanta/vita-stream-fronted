import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletManager {
  final _storage = const FlutterSecureStorage();

  // Save private key securely
  Future<void> savePrivateKey(String privateKey) async {
    await _storage.write(key: 'private_key', value: privateKey);
  }

  // Load private key
  Future<String?> getPrivateKey() async {
    return await _storage.read(key: 'private_key');
  }

  // Delete wallet
  Future<void> deleteWallet() async {
    await _storage.delete(key: 'private_key');
  }
}
