import '/data/provider/book_provider.dart';

import '../../ui/controller/encrypter.dart';

class BookRepository {
    final BookProvider provider;

    BookRepository({required this.provider});
    getBookDatabase(Encryptor encrypter, bool isUser) async {
        return provider.getBookDatabase(encrypter, isUser);
    }

    set(String? reference, Object data) async {
        return await provider.set(reference, data);
    }

    update(String? reference, Map<String, dynamic> data) async {
        return await provider.update(reference, data);
    }

    remove(String reference) async {
        return await provider.remove(reference);
    }

    removeAll() async {
        return provider.removeAll();
    }
}