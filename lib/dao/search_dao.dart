import 'package:flutter_trip/model/search_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const SEARCH_URL =
    'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

class SearchDao {
  static Future<SearchModel> fetch(String word) async {
    final response = await http.get(SEARCH_URL + word);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      var model = SearchModel.fromJson(result);
      model.keyword = word;
      return model;
    } else {
      throw Exception('Failed to load search_page.json');
    }
  }
}
