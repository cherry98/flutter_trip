import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'city_page.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CommonModel> bannerList = []; //图片轮播
  List<CommonModel> localNavList = []; //local导航
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool _loading = true; //页面加载状态
  String city = '北京市';

  double appBarAlpha = 0;

  @override
  void initState() {
    _handleRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: <Widget>[
              MediaQuery.removePadding(
                //移除状态栏的高度
                context: context,
                removeTop: true,
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  //下拉刷新组件
                  child: NotificationListener(
                      //相当于Android的滑动监听
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification &&
                            scrollNotification.depth == 0) {
                          //滚动并且是列表滚动的时候
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                      },
                      child: _listView),
                ),
              ),
              _appBar,
            ],
          ),
        ));
  }

  //页面appBar
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
          ),
          child: Container(
            padding: EdgeInsets.only(top: top),
            height: 56 + top,
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              leftButtonClick: _jumpToCity,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              city: city,
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        )
      ],
    );
  }

  //页面listView列表
  Widget get _listView {
    return ListView(
      children: <Widget>[
        //轮播图
        _banner,
        //local导航
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        //网格卡片
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNav(gridNavModel: gridNavModel),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SalesBox(salesBoxModel: salesBoxModel),
        )
        //活动卡片
        //底部卡片
      ],
    );
  }

  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        autoplay: true,
        loop: true,
        itemCount: bannerList.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            bannerList[index].icon,
            fit: BoxFit.fill,
          );
        },
        pagination: new SwiperPagination(),
        onTap: (index) {
          NavigatorUtil.push(
              context,
              WebView(
                url: bannerList[index].url,
                title: bannerList[index].title,
                hideAppBar: bannerList[index].hideAppBar,
                statusBarColor: bannerList[index].statusBarColor,
              ));
        },
      ),
    );
  }

  //加载home page数据
  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        bannerList = model.bannerList;
        localNavList = model.localNavList;
        subNavList = model.subNavList;
        gridNavModel = model.gridNav;
        salesBoxModel = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  //辊距滚动改变透明度
  void _onScroll(double pixels) {
    double alpha = pixels / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  //跳转搜索页面
  void _jumpToSearch() {
    NavigatorUtil.push(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
        ));
  }

  //跳转城市页面
  void _jumpToCity() {
    NavigatorUtil.push(
        context,
        CityPage(
          city: city,
        ));
  }

  //跳转语音识别页面
  void _jumpToSpeak() {
    NavigatorUtil.push(context, SpeakPage());
  }
}
