import '/data/provider/mapping_provider.dart';

import '../model/mapping_model.dart';

class MappingRepository {
  final MappingProvider provider;
  MappingRepository({required this.provider});

  set(Object data) async {
    return await provider.set(data);
  }

  update(Map<String, dynamic> data) async {
    return await provider.update(data);
  }

  remove(String reference) async {
    return await provider.remove(reference);
  }

  Future<String?> get(reference) async {
    try {
      return await provider.get(reference);
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<Mapping?> getAll() async {
    try {
      return await provider.getAll();
    } catch(e) {

      throw Exception(e);
    }
  }
}