import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 caracteres
  static final _iv = encrypt.IV.fromUtf8('my16bytesiv00001'); // IV fixo de 16 caracteres

  static String encryptCPF(String cpf) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(cpf, iv: _iv);
    return encrypted.base64;
  }

  static String decryptCPF(String encryptedCPF) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      return encrypter.decrypt64(encryptedCPF, iv: _iv);
    } catch (e) {
      throw Exception('Erro na descriptografia: $e');
    }
  }
}
