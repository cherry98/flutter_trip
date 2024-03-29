import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/travel_tab_dao.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:flutter_trip/pages/travel_tab_page.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  TabController _tabController;
  TravelTabModel travelTabModel;
  List<TravelTab> tabs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.fromLTRB(20, 0, 20, 5),
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xff1fcfbb), width: 3),
                  insets: EdgeInsets.only(bottom: 10)),
              tabs: tabs.map<Tab>((TravelTab tab) {
                return Tab(
                  text: tab.labelName,
                );
              }).toList(),
            ),
          ),
          Flexible(
              child: TabBarView(
                  controller: _tabController,
                  children: tabs.map((TravelTab tab) {
                    return TravelTabPage(
                      travelUrl: travelTabModel.url,
                      params: travelTabModel.params,
                      groupChannelCode: tab.groupChannelCode,
                      type: tab.type,
                    );
                  }).toList()))
        ],
      ),
    );
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    _tabController = TabController(length: 0, vsync: this);
    try {
      TravelTabModel model = await TravelTabDao.fetch();
      _tabController = TabController(length: model.tabs.length, vsync: this);
      setState(() {
        travelTabModel = model;
        tabs = model.tabs;
      });
    } catch (e) {
      print(e);
    }
  }
}
