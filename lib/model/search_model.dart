class SearchModel {
  String keyword;
  final List<SearchItem> data;

  SearchModel({this.data});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    var dataJson = json['data'] as List;
    List<SearchItem> data =
        dataJson.map((item) => SearchItem.fromJson(item)).toList();
    return SearchModel(data: data);
  }
}

class SearchItem {
  final String word;
  final String type;
  final String districtname;
  final String url;
  final String price;
  final String star;
  final String zonename;

  SearchItem(
      {this.word,
      this.type,
      this.districtname,
      this.url,
      this.star,
      this.price,
      this.zonename});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
        word: json['word'],
        type: json['type'],
        districtname: json['districtname'],
        url: json['url'],
        star: json['star'],
        price: json['price'],
        zonename: json['zonename']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['word'] = word;
    data['type'] = type;
    data['districtname'] = districtname;
    data['url'] = url;
    data['price'] = price;
    data['zonename'] = zonename;
    data['star'] = star;
    return data;
  }
}
