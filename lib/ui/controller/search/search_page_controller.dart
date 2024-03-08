import 'package:book_report/data/model/user_model.dart';
import 'package:book_report/data/provider/user_provider.dart';
import 'package:book_report/data/repository/mapping_repository.dart';
import 'package:book_report/data/repository/user_repository.dart';
import 'package:get/get.dart';

import '../../../data/model/mapping_model.dart';
import '../../../data/model/user_access_enum.dart';
import '../../../data/provider/mapping_provider.dart';

class SearchPageController extends GetxController {
  final users = <String, User>{}.obs;
  final found = <User>[].obs;
  final mapping = Mapping(mapping: {}).obs;

  init(uid) async => await getMapping(uid);

  getMapping(uid) async {
    final repo = MappingRepository(provider: MappingProvider());
    mapping(await repo.getAll());
    for(var key in mapping.value.mapping.keys) {
      if(mapping.value.mapping[key] == uid) continue;
      final User? res = await UserRepository(provider: UserProvider(
          uid: mapping.value.mapping[key]!
      )).getUser();
      if(res != null && res.getAccess() == UserAccess.public) {
        users[key] = res;
      }
    }
    users.refresh();
  }

  search(String query) async {
    found.clear();
    if(users.containsKey(query)) {
      final user = users[query]!;
      if(user.getAccess() == UserAccess.public) found.add(users[query]!);
    } else {
      for(var user in users.values) {
        if(user.getUsername().contains(query) && user.access == UserAccess.public) {
          found.add(user);
        }
      }
    }
    found.refresh();
  }

  hasData() => found.isNotEmpty;
  getLength() => found.length;

  User getData(int index) => found[index];

  String? getUid(String key) {
      return mapping.value.mapping[key];
  }
}
