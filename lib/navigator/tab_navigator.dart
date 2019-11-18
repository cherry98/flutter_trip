import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/my_page.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

/**
 * 1.PageView相当于android中的ViewPager
 * 2.WillPopScope-双击返回与界面退出提示
 */

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  List<CommonModel> list = [];
  var _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            children: <Widget>[
              HomePage(),
              SearchPage(),
              TravelPage(),
              MyPage()
            ],
          ),
          onWillPop: null),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          _bottomItem(Icons.home, '首页', 0),
          _bottomItem(Icons.search, '搜索', 1),
          _bottomItem(Icons.camera_alt, '旅拍', 2),
          _bottomItem(Icons.account_circle, '我的', 3)
        ],
      ),
    );
  }

  BottomNavigationBarItem _bottomItem(IconData icon, String title, int i) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        title: Text(
          title,
          style: TextStyle(
              color: _currentIndex != i ? _defaultColor : _activeColor),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
