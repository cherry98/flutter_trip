import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];

class WebView extends StatefulWidget {
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;
  final bool backForbid;

  WebView(
      {Key key,
      this.title,
      this.url,
      this.statusBarColor,
      this.hideAppBar,
      this.backForbid = false})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  var webViewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool existing = false; //返回状态

  @override
  void initState() {
    super.initState();
    webViewReference.close();
    _onUrlChanged = webViewReference.onUrlChanged.listen((String url) {});
    _onStateChanged =
        webViewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad: //开始加载时
          if (_isToMain(state.url) && !existing) {
            if (widget.backForbid) {
              //禁止返回
              webViewReference.launch(widget.url);
            } else {
              Navigator.pop(context);
              existing = true; //不重复返回
            }
          }
          break;
        default:
          break;
      }
    });
    _onHttpError =
        webViewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  _isToMain(String url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    webViewReference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(
              Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          //webview要展示的内容撑满
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              withZoom: true,
              //缩放
              withLocalStorage: true,
              //本地存储
              hidden: true,
              //加载出前是隐藏的
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text('Loading'),
                ),
              ), //加载出来前loading条
            ),
          )
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      //隐藏状态下的appbar
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    //非隐藏状态下的 希望可以撑满屏幕的宽度，如果widget撑满不了整个屏幕的宽度可以借助FractionallySizedBox实现
    return Container(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      color: backgroundColor,
      child: FractionallySizedBox(
        widthFactor: 1, //宽度撑满
        //Stack 层叠组件，与Android中的FrameLayout很像，都是可以叠加的view
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            //flutter中使用Stack和Positioned实现绝对定位，Stack允许子View堆叠，而Positioned可以给子View定位（通过Stack的四个角）
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(color: backButtonColor, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
