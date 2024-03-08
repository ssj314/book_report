import '/ui/controller/universal_controller.dart';
import 'package:http/http.dart';

import '../../constant/string.dart';

class RestAPIProvider {

  sendRequest({required RequestMethod method, required String query}) async {
    try {
      switch(method) {
        case RequestMethod.aladin:
          var uri = Uri.http("www.aladin.co.kr", "ttb/api/ItemLookUp.aspx",
              {'ttbkey': aladinAPIKey, 'ItemId': query, 'ItemIdType': 'ISBN13', 'Cover': 'Big', 'Output': 'JS'});
          return await _request(uri);
        case RequestMethod.kakao:
          var uri = Uri.parse("https://dapi.kakao.com/v3/search/book?query=$query");
          return await _request(uri, header: "KakaoAK $kakaoAPIKey");
        case RequestMethod.url:
          break;
      }
    } catch(e) {
      return null;
    }
  }

  _request(Uri uri, {String header = ""}) async {
    try {
      if(getPlatform() == UserPlatform.android ||
        getPlatform() == UserPlatform.ios) {
        var headers = {"Authorization": header};
        var response = await get(uri, headers: headers);
        return response.body.replaceAll(';', '').replaceAll("\\", "");
      } else {
        var root = Uri.parse("https://proxy.cors.sh/$uri");
        var headers = {'x-cors-api-key': 'temp_4cc4a95bde915180d40ce6ac0ed89cec'};
        if(header.isNotEmpty) {
          headers["Authorization"] = header;
        }
        var response = await get(root,
            headers: headers
        );
        var result = response.body;
        return result.replaceAll(';', '').replaceAll("\\", "");

      }
    } catch(e) {
      throw Exception(e.toString());
    }
  }
}

enum RequestMethod {
  aladin,
  kakao,
  url;
}
