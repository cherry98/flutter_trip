import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/utils/navigator_util.dart';

import 'webview.dart';

class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBoxModel;

  SalesBox({Key key, @required this.salesBoxModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: _items(context),
    );
  }

  _items(BuildContext context) {
    if (salesBoxModel == null) return null;
    List<Widget> items = [];
    items.add(_doubleItems(
        context, salesBoxModel.bigCard1, salesBoxModel.bigCard2, true, false));
    items.add(_doubleItems(context, salesBoxModel.smallCard1,
        salesBoxModel.smallCard2, false, false));
    items.add(_doubleItems(context, salesBoxModel.smallCard3,
        salesBoxModel.smallCard4, false, true));
    return Column(
      children: <Widget>[
        Container(
          height: 44,
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xfff2f2f2)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.network(
                salesBoxModel.icon,
                height: 15,
                fit: BoxFit.fill,
              ),
              _getMore(context)
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(0, 1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(1, 2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(2, 3),
        ),
      ],
    );
  }

  _getMore(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 3, 8, 4),
      margin: EdgeInsets.only(right: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
            colors: [Color(0xffff4e63), Color(0xffff6cc9)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
      ),
      child: GestureDetector(
        onTap: () {
          NavigatorUtil.push(
              context,
              WebView(
                url: salesBoxModel.moreUrl,
                title: '更多活动',
              ));
        },
        child: Text(
          '获取更多福利 >',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  _doubleItems(BuildContext context, CommonModel leftItem,
      CommonModel rightItem, bool isBig, bool isLast) {
    return Row(
      children: <Widget>[
        _item(context, leftItem, isBig, true, isLast),
        _item(context, rightItem, isBig, false, isLast),
      ],
    );
  }

  _item(BuildContext context, CommonModel model, bool isBig, bool isLeft,
      bool isLast) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Color(0xfff2f2f2));
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
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                right: isLeft ? borderSide : BorderSide.none,
                bottom: isLast ? BorderSide.none : borderSide)),
        child: Image.network(
          model.icon,
          width: MediaQuery.of(context).size.width / 2 - 8,
          height: isBig ? 129 : 80,
        ),
      ),
    );
  }
}
