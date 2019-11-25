import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/travel_dao.dart';
import 'package:flutter_trip/model/travle_model.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_trip/widget/webview.dart';

const TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

const PAGE_SIZE = 10;

class TravelTabPage extends StatefulWidget {
  final String travelUrl;
  final Map params;
  final String groupChannelCode;
  final int type;

  TravelTabPage(
      {Key key, this.travelUrl, this.params, this.groupChannelCode, this.type})
      : super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage> {
  int pageIndex = 1;
  List<TravelItem> travelItems = [];
  bool _isLoading = true;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _loadData();
    _controller.addListener(() {
      //滑到底部加载更多
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingContainer(
        isLoading: _isLoading,
        child: RefreshIndicator(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: StaggeredGridView.countBuilder(
                  controller: _controller,
                  itemCount: travelItems?.length ?? 0,
                  crossAxisCount: 2,
                  itemBuilder: (BuildContext context, int index) => _TravelItem(
                        index: index,
                        travelItem: travelItems[index],
                      ),
                  staggeredTileBuilder: (index) => StaggeredTile.fit(1)),
            ),
            onRefresh: _handleRefresh),
      ),
    );
  }

  void _loadData({loadMore = false}) async {
    if (loadMore) {
      //加载更多
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    try {
      TravelModel model = await TravelDao.fetch(
          widget.travelUrl ?? TRAVEL_URL,
          widget.params,
          widget.groupChannelCode,
          widget.type,
          pageIndex,
          PAGE_SIZE);
      setState(() {
        List<TravelItem> items = _filterItems(model.resultList);
        if (travelItems != null) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  //数据过滤
  List<TravelItem> _filterItems(List<TravelItem> list) {
    if (list == null) return [];
    List<TravelItem> filterItems = [];
    list.forEach((item) {
      if (item.article != null) {
        filterItems.add(item);
      }
    });
    return filterItems;
  }

  Future<void> _handleRefresh() async {
    _loadData();
    return null;
  }
}

class _TravelItem extends StatelessWidget {
  final TravelItem travelItem;
  final int index;

  _TravelItem({Key key, this.travelItem, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (travelItem.article.urls != null &&
            travelItem.article.urls.length > 0) {
          NavigatorUtil.push(
              context,
              WebView(
                url: travelItem.article.urls[0].h5Url,
                title: '详情',
              ));
        }
      },
      child: Card(
        child: PhysicalModel(
          //主要的功能就是设置widget四边圆角，可以设置阴影颜色，和z轴高度
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias, //裁剪模式
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _itemImage,
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  travelItem.article.articleTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              _infoText,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _infoText {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PhysicalModel(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              travelItem.article.author.coverImage?.dynamicUrl,
              width: 24,
              height: 24,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            width: 90,
            child: Text(
              travelItem.article.author?.nickName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                size: 14,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  travelItem.article.likeCount.toString(),
                  style: TextStyle(fontSize: 10),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget get _itemImage {
    return Stack(
      children: <Widget>[
        Image.network(travelItem.article.images[0].dynamicUrl),
        Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 3),
                    child: Icon(
                      Icons.location_on,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  LimitedBox(
                    maxWidth: 130,
                    child: Text(
                      _poiName(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  String _poiName() {
    return travelItem.article.pois == null ||
            travelItem.article.pois.length == 0
        ? '未知'
        : travelItem.article.pois[0].poiName ?? '未知';
  }
}
