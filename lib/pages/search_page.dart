import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'dart:ui';

import 'package:flutter_trip/widget/webview.dart';

const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

class SearchPage extends StatefulWidget {
  final String hint;
  final String searchUrl;
  final String keyword;
  final bool hideLeft;

  SearchPage(
      {Key key, this.hint, this.searchUrl, this.keyword, this.hideLeft = false})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String keyword;
  SearchModel searchModel;

  @override
  void initState() {
    if (widget.keyword != null) {
      _onTextChanged(widget.keyword);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar,
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: searchModel?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return _item(index);
                      })))
        ],
      ),
    );
  }

  Widget get _appBar {
    var top = MediaQuery.of(context).padding.top;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              color: Colors.red),
          child: Container(
            height: top + 56,
            padding: EdgeInsets.only(top: top),
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              searchBarType: SearchBarType.normal,
              hint: widget.hint ?? SEARCH_BAR_DEFAULT_TEXT,
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              speakClick: () {
                NavigatorUtil.push(context, SpeakPage());
              },
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChanged,
            ),
          ),
        ),
      ],
    );
  }

  //输入框文本更改 调用搜索接口
  void _onTextChanged(String value) async {
    keyword = value;
    if (value.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    try {
      SearchModel model = await SearchDao.fetch(value);
      if (model.keyword == keyword) {
        setState(() {
          searchModel = model;
        });
      }
    } catch (e) {
      print('输入框文本更改' + e.toString());
    }
  }

  //搜索页面的item结果
  Widget _item(int index) {
    if (searchModel == null || searchModel.data == null) return null;
    SearchItem searchItem = searchModel.data[index];
    return GestureDetector(
      onTap: () {
        print(searchItem.url + '====');
        NavigatorUtil.push(
            context,
            WebView(
              url: searchItem.url,
              title: '详情',
            ));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              width: 26,
              height: 26,
              child: Image(image: AssetImage(_typeImage(searchItem.type))),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(searchItem),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(searchItem),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String _typeImage(String type) {
    if (type == null) return 'assets/images/type_travelgroup.png';
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
      }
    }
    return 'assets/images/type_$path.png';
  }

  //搜索标题
  _title(SearchItem searchItem) {
    if (searchItem == null) return null;
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(searchItem.word, searchModel.keyword));
    spans.add(TextSpan(
        text: ' ' +
            (searchItem.districtname ?? '' + ' ' + (searchItem.zonename ?? '')),
        style: TextStyle(fontSize: 12, color: Colors.grey)));
    return RichText(
      text: TextSpan(children: spans),
    );
  }

  //关键字高亮处理
  List<TextSpan> _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) return spans;
    //搜索关键字高亮忽略大小写
    String wordL = word.toLowerCase(), keywordL = keyword.toLowerCase();
    List<String> arr = wordL.split(keywordL);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    int preIndex = 0;
    for (int i = 0; i < arr.length; i++) {
      if (i != 0) {
        preIndex = wordL.indexOf(keywordL, preIndex);
        spans.add(TextSpan(
            text: word.substring(
              preIndex,
              preIndex + keyword.length,
            ),
            style: keywordStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }

  _subTitle(SearchItem searchItem) {
    if (searchItem == null) return null;
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
            text: searchItem.price ?? '',
            style: TextStyle(fontSize: 16, color: Colors.orange)),
        TextSpan(
            text: ' ' + searchItem.type ?? '',
            style: TextStyle(fontSize: 12, color: Colors.grey))
      ]),
    );
  }
}
