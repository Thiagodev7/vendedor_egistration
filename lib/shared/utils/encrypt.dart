import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 caracteres
  static final _iv = encrypt.IV.fromLength(16); // Vetor de inicialização

  static String encryptCPF(String cpf) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(cpf, iv: _iv);
    return encrypted.base64;
  }

  static String decryptCPF(String encryptedCPF) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedCPF, iv: _iv);
    return decrypted;
  }
}
