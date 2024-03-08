class Mapping {
  Map<String, String> mapping;
  Mapping({required this.mapping});

  factory Mapping.fromJson(Map<String, dynamic> json) {
    Map<String, String> tmp = {};
    for(var uid in json.keys) {
      tmp[uid] = json[uid];
    }
    return Mapping(mapping: tmp);
  }
}