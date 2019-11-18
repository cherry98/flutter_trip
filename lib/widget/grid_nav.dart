import 'package:flutter/material.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'webview.dart';

class GridNav extends StatelessWidget {
  //为什么要用final 因为继承的是StatelessWidget 是不可变的 widget里面的成员变量必须是final
  //StatefulWidget同理
  final GridNavModel gridNavModel;

  GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias, //是否裁切
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) return items;
    if (gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool isFirst) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));

    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));

    List<Widget> expandItems = [];
    items.forEach((item) {
      expandItems.add(Expanded(
        child: item,
        flex: 1,
      ));
    });
    return Container(
      height: 88,
      margin: isFirst ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          //线性渐变
          gradient: LinearGradient(colors: [startColor, endColor])),
      child: Row(
        children: expandItems,
      ),
    );
  }

  _mainItem(BuildContext context, CommonModel model) {
    Widget widget = Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Image.network(
          model.icon,
          fit: BoxFit.contain,
          height: 88,
          width: 121,
          alignment: AlignmentDirectional.bottomEnd,
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            model.title,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
    return _wrapGesture(context, widget, model);
  }

  _doubleItem(
    BuildContext context,
    CommonModel topItem,
    CommonModel bottomItem,
  ) {
    return Column(
      children: <Widget>[
        Expanded(
          //垂直方向展开 FractionallySizedBox水平方向展开
          child: _item(context, topItem, true),
        ),
        Expanded(
          child: _item(context, topItem, false),
        )
      ],
    );
  }

  _item(BuildContext context, CommonModel item, bool isFirst) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      //撑满父布局的宽度
      widthFactor: 1,
      child: Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            border: Border(
          left: borderSide,
          bottom: isFirst ? borderSide : BorderSide.none,
        )),
        child: _wrapGesture(
            context,
            Text(
              item.title,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            item),
      ),
    );
  }

  //封装跳转webview详情页面
  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            WebView(
              url: model.url,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppBar,
              title: model.title,
            ));
      },
      child: widget,
    );
  }
}
