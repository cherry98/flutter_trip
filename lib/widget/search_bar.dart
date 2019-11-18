import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight } //首页，搜索，首页高亮状态下

class SearchBar extends StatefulWidget {
  final void Function() leftButtonClick;
  final void Function() inputBoxClick;
  final void Function() speakClick;
  final void Function() rightButtonClick;
  final String hint; //默认提示文案
  final String defaultText;
  final bool autoFocus; //默认是否获取焦点
  final bool hideLeft;
  final String city;
  final SearchBarType searchBarType;
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
      this.leftButtonClick,
      this.inputBoxClick,
      this.speakClick,
      this.rightButtonClick,
      this.hint,
      this.defaultText,
      this.autoFocus = false,
      this.hideLeft = true,
      this.city,
      this.searchBarType,
      this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      _controller.text = widget.defaultText;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _getNormalSearch
        : _getHomeSearch;
  }

  //首页样式
  Widget get _getHomeSearch {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.city,
                      style: TextStyle(color: _homeFontColor, fontSize: 14),
                    ),
                    Icon(
                      Icons.expand_more,
                      size: 22,
                      color: _homeFontColor,
                    )
                  ],
                ),
              ),
              widget.leftButtonClick),
          Expanded(
            flex: 1,
            child: _inputBox,
          ),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(
                  Icons.comment,
                  color: _homeFontColor,
                  size: 24,
                ),
              ),
              widget.rightButtonClick)
        ],
      ),
    );
  }

  Color get _homeFontColor {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }

  //搜索页面样式
  Widget get _getNormalSearch {
    return Container(
        //负责矩形的创建，用BoxDecoration设计样式，如背景边框阴影
        child: Row(
      children: <Widget>[
        _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget.hideLeft
                  ? null
                  : Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 24,
                    ),
            ),
            widget.leftButtonClick),
        Expanded(
          flex: 1,
          child: _inputBox,
        ),
        _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(
                '搜索',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
            widget.rightButtonClick)
      ],
    ));
  }

  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: child,
    );
  }

  Widget get _inputBox {
    Color inputColor;
    inputColor = Color(0xffededed);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 30,
      decoration: BoxDecoration(
          color: inputColor, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          Icon(
            //搜索按钮
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal
                ? Color(0xffa9a9a9)
                : Colors.blue,
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
                ? TextField(
                    //输入框
                    //相当于EditText
                    controller: _controller,
                    onChanged: _onChanged,
                    autofocus: widget.autoFocus,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        border: InputBorder.none,
                        hintText: widget.hint ?? '',
                        hintStyle: TextStyle(fontSize: 15)),
                  )
                : _wrapTap(
                    Text(
                      widget.defaultText ?? '',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    widget.inputBoxClick),
          ),
          showClear
              ? _wrapTap(
                  Icon(
                    //清除文字
                    Icons.clear,
                    size: 20,
                    color: Colors.grey,
                  ), () {
                  setState(() {
                    _controller.clear();
                  });
                  _onChanged('');
                })
              : _wrapTap(
                  Icon(
                    //语音说话
                    Icons.mic,
                    size: 20,
                    color: widget.searchBarType == SearchBarType.normal
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  widget.speakClick)
        ],
      ),
    );
  }

  void _onChanged(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }
}
