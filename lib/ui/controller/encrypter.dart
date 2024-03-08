import 'package:encrypt/encrypt.dart';

class Encryptor {
  final String userKey;
  Encryptor({required this.userKey});

  encrypt(value) {
    return value;
    // final key = Key.fromUtf8("$userKey$userKey$userKey$userKey");
    // final iv = IV.fromLength(16);
    // final encryptor = Encrypter(AES(key));
    // return encryptor.encrypt(value, iv: iv).base64;
  }

  decrypt(String enc) {
    return enc;
    // try {
    //   final key = Key.fromUtf8("$userKey$userKey$userKey$userKey");
    //   final iv = IV.allZerosOfLength(16);
    //   final encryptor = Encrypter(AES(key));
    //   return encryptor.decrypt64(enc, iv: iv);
    // } catch (e) {
    //   print(e);
    //   throw Exception(e);
    // }
  }
 }