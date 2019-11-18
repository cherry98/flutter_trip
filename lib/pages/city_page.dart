import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:lpinyin/lpinyin.dart';

class CityPage extends StatefulWidget {
  final String city;

  CityPage({Key key, this.city}) : super(key: key);

  @override
  _CityPageState createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  List<CityInfo> _cityList = List();
  String _suspensionTag = "";
  int _itemHeight = 50;
  int _suspensionHeight = 40;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  //加载城市数据
  void _loadData() async {
    try {
      var value = await rootBundle.loadString('assets/data/cities.json');
      List list = json.decode(value);
      list.forEach((value) {
        _cityList.add(CityInfo(name: value['name']));
      });
      _handleList(_cityList);
      setState(() {
        _cityList = _cityList;
      });
    } catch (e) {
      print(e);
    }
  }

  //自定义头部
  Widget _buildHeader() {
    List<CityInfo> hotCityList = List();
    hotCityList.addAll([
      CityInfo(name: '北京市'),
      CityInfo(name: '上海市'),
      CityInfo(name: '广州市'),
      CityInfo(name: '深圳市'),
      CityInfo(name: '杭州市'),
      CityInfo(name: '成都市'),
    ]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        //流式布局
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 10,
        children: hotCityList.map((e) {
          return OutlineButton(
            //边框按钮
            onPressed: () {
              Navigator.pop(context, e.name);
            },
            child: Text(e.name),
            borderSide: BorderSide(color: Colors.grey[300], width: 0.5),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('选择城市'),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              title: Text('定位城市'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    //trailing设置拖尾 将在列表的末尾放置一个图像
                    Icons.place,
                    size: 20,
                  ),
                  Text(widget.city ?? '')
                ],
              ),
            ),
            Divider(
              height: 0.1,
            ),
            Expanded(
              flex: 1,
              child: AzListView(
                data: _cityList,
                itemBuilder: (context, model) => _buildListItem(model),
                suspensionWidget: _buildSusWidget(_suspensionTag),
                //悬停的widget
                isUseRealIndex: true,
                itemHeight: _itemHeight,
                suspensionHeight: _suspensionHeight,
                onSusTagChanged: _onSusTagChanged,
                header: AzListViewHeader(
                  tag: '★',
                  height: 140,
                  builder: (context) {
                    return _buildHeader();
                  },
                ),
                indexHintBuilder: (context, hint) {
                  return Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.black54, shape: BoxShape.circle),
                    child: Text(
                      hint,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  //排序
  void _handleList(List<CityInfo> cityList) {
    if (cityList == null || cityList.isEmpty) {
      return;
    }
    for (int i = 0; i < cityList.length; i++) {
      String pinyin = PinyinHelper.getPinyin(cityList[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      cityList[i].namePinyin = pinyin;
      if (RegExp('[A-Z]').hasMatch(tag)) {
        //RegExp('A-Z')至少匹配一个字母
        cityList[i].tagIndex = tag;
      } else {
        cityList[i].tagIndex = '#';
      }
    }
    //按照A-Z排序
    SuspensionUtil.sortListBySuspensionTag(_cityList);
  }

  //自定义item
  Widget _buildListItem(CityInfo model) {
    String sugTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          //通过offsatge字段控制child是否显示,比较常用的控件
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(sugTag),
        ),
        SizedBox(
          //能强制子控件具有特定宽度、高度或两者都有,使子控件设置的宽高失效
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(model.name),
            onTap: () {
              Navigator.pop(context, model.name);
            },
          ),
        )
      ],
    );
  }

  //自定义tag
  Widget _buildSusWidget(String suspensionTag) {
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: EdgeInsets.only(left: 15),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$suspensionTag',
        softWrap: false,
        style: TextStyle(fontSize: 14, color: Color(0xff999999)),
      ),
    );
  }

  void _onSusTagChanged(String value) {
    setState(() {
      _suspensionTag = value;
    });
  }
}

class CityInfo extends ISuspensionBean {
  String name;
  String tagIndex;
  String namePinyin;

  CityInfo({this.name, this.tagIndex, this.namePinyin});

  @override
  String getSuspensionTag() => tagIndex;
}
