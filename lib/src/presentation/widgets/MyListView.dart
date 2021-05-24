import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';

typedef Future<List> DataRequester(int offset);
typedef Future<List> InitRequester();
typedef Widget ItemBuilder(List data, BuildContext context, int index);

class MyListView extends StatefulWidget {
  MyListView.build(
      {Key key,
      this.scrollDirection = Axis.vertical,
      this.header,
      @required this.itemBuilder,
      @required this.dataRequester,
      @required this.initRequester})
      : assert(itemBuilder != null),
        assert(dataRequester != null),
        assert(initRequester != null),
        super(key: key);

  Axis scrollDirection;
  Widget header;
  final ItemBuilder itemBuilder;
  final DataRequester dataRequester;
  final InitRequester initRequester;

  @override
  State createState() => new MyListViewState();
}

class MyListViewState extends State<MyListView> {
  bool isPerformingRequest = false;
  ScrollController _controller = new ScrollController();
  List _dataList;

  @override
  void initState() {
    super.initState();
    this.onRefresh();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color loadingColor = Theme.of(context).primaryColor;
    return ListView(
      physics: BouncingScrollPhysics(),
      scrollDirection: widget.scrollDirection,
      controller: _controller,
      children: [
        widget.header != null ? widget.header : Container(),
        this._dataList == null
            ? loadingProgress(loadingColor)
            : (this._dataList.length > 0
                ? RefreshIndicator(
                    color: loadingColor,
                    onRefresh: this.onRefresh,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: widget.scrollDirection,
                      itemCount: _dataList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _dataList.length) {
                          return opacityLoadingProgress(isPerformingRequest, loadingColor);
                        } else {
                          return widget.itemBuilder(_dataList, context, index);
                        }
                      },
                      padding: EdgeInsets.all(0),
                    ))
                : Center(child: Text("Không có dữ liệu")))
      ],
    );
  }

  Future<Null> onRefresh() async {
    if (!mounted) return;
    this.setState(() => this._dataList = null);
    List initDataList = await widget.initRequester();
    if (!mounted) return;
    this.setState(() => this._dataList = initDataList);
    return;
  }

  _loadMore() async {
    if (mounted) {
      this.setState(() => isPerformingRequest = true);
      int currentSize = 0;
      if (_dataList != null) currentSize = _dataList.length;

      List newDataList = await widget.dataRequester(currentSize);
      if (newDataList != null) {
        if (newDataList.length == 0) {
          double edge = 50.0;
          double offsetFromBottom = _controller.position.maxScrollExtent - _controller.position.pixels;
          if (offsetFromBottom < edge) {
            _controller.animateTo(_controller.offset - (edge - offsetFromBottom), duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          }
        } else {
          _dataList.addAll(newDataList);
        }
      }
      if (mounted) this.setState(() => isPerformingRequest = false);
    }
  }
}

Widget loadingProgress(loadingColor) {
  return MyLoading();
}

Widget opacityLoadingProgress(isPerformingRequest, loadingColor) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(opacity: isPerformingRequest ? 1.0 : 0.0, child: MyLoading()),
      ),
    ),
  );
}
