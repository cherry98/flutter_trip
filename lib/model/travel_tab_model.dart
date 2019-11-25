class TravelTabModel {
  String url;
  Map params;
  List<TravelTab> tabs;

  TravelTabModel({this.url, this.params, this.tabs});

  factory TravelTabModel.fromJson(Map<String, dynamic> json) {
    var dataJson = json['tabs'] as List;
    List<TravelTab> data =
        dataJson.map((item) => TravelTab.fromJson(item)).toList();
    return TravelTabModel(url: json['url'], params: json['params'], tabs: data);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = url;
    data['tabs'] = tabs.map((v) => v.toJson()).toList();
    data['params'] = params;
    return data;
  }
}

class PagePara {
  int pageIndex;
  int pageSize;
  int sortType;
  int sortDirection;

  PagePara({this.pageIndex, this.pageSize, this.sortType, this.sortDirection});

  factory PagePara.fromJson(Map<String, dynamic> json) {
    return PagePara(
      pageIndex: json['pageIndex'],
      pageSize: json['pageSize'],
      sortType: json['sortType'],
      sortDirection: json['sortDirection'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['pageIndex'] = pageIndex;
    data['pageSize'] = pageSize;
    data['sortType'] = sortType;
    data['sortDirection'] = sortDirection;
    return data;
  }
}

class Head {
  String cid;
  String ctok;
  String cver;
  String lang;
  String sid;
  String syscode;
  String auth;
  List<Extension> extension;

  Head(
      {this.cid,
      this.ctok,
      this.cver,
      this.lang,
      this.sid,
      this.syscode,
      this.auth,
      this.extension});

  factory Head.fromJson(Map<String, dynamic> json) {
    var dataJson = json['extension'] as List;
    List<Extension> data =
        dataJson.map((value) => Extension.fromJson(value)).toList();
    return Head(
        cid: json['cid'],
        ctok: json['ctok'],
        cver: json['cver'],
        lang: json['lang'],
        syscode: json['syscode'],
        sid: json['sid'],
        auth: json['auth'],
        extension: data);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['cid'] = cid;
    data['ctok'] = ctok;
    data['cver'] = cver;
    data['lang'] = lang;
    data['syscode'] = syscode;
    data['sid'] = sid;
    data['auth'] = auth;
    data['extension'] = extension.map((value) => value.toJson()).toList();
    return data;
  }
}

class Extension {
  String name;
  String value;

  Extension({this.name, this.value});

  factory Extension.fromJson(Map<String, dynamic> json) {
    return Extension(
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}

class TravelTab {
  String labelName;
  String groupChannelCode;
  int type;

  TravelTab({this.labelName, this.groupChannelCode, this.type});

  factory TravelTab.fromJson(Map<String, dynamic> json) {
    return TravelTab(
      labelName: json['labelName'],
      groupChannelCode: json['groupChannelCode'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['labelName'] = labelName;
    data['groupChannelCode'] = groupChannelCode;
    data['type'] = type;
    return data;
  }
}
