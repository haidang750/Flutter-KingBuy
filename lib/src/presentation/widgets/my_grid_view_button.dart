import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef Future<List> DataRequester(int offset);
typedef Future<List> InitRequester();
typedef Widget ItemBuilder(List data, BuildContext context, int index);

class MyGridViewButton extends StatefulWidget {
  MyGridViewButton(
      {Key key,
      @required this.itemBuilder,
      @required this.dataRequester,
      @required this.initRequester,
      this.childAspectRatio,
      this.crossAxisCount})
      : assert(itemBuilder != null),
        assert(dataRequester != null),
        assert(initRequester != null),
        super(key: key);

  DataRequester dataRequester;
  InitRequester initRequester;
  Function itemBuilder;
  double childAspectRatio;
  int crossAxisCount;

  @override
  State createState() => new MyGridViewButtonState();
}

class MyGridViewButtonState extends State<MyGridViewButton> {
  bool isLoadMore = false, isLoading = true;
  List data = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    var footer;
    if (this.isLoadMore) {
      footer = buildLoadMoreButton(
          SpinKitCircle(
            size: 20,
            color: Colors.white,
          ),
          null);
    } else {
      footer = buildLoadMoreButton(
          Text("Xem thêm", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)), () => loadMore());
    }
    if (this.isLoading)
      return Center(
          child: SpinKitCircle(
        color: Colors.blue,
        size: 40,
      ));
    else if (data == null || data.length == 0) {
      return Center(child: Text("Không có dữ liệu"));
    } else {
      return CustomScrollView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.only(bottom: 10),
            sliver: widget.childAspectRatio != null && widget.crossAxisCount != null
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: widget.childAspectRatio,
                      crossAxisCount: widget.crossAxisCount,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return widget.itemBuilder(data, context, index);
                    }, childCount: data.length),
                  )
                : SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: (MediaQuery.of(context).size.width / 3),
                    ),
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return widget.itemBuilder(data, context, index);
                    }, childCount: data.length),
                  ),
          ),
          SliverToBoxAdapter(
            child: footer,
          ),
        ],
      );
    }
  }

  Widget buildLoadMoreButton(Widget contentButton, Function action) {
    return Container(
        height: 60,
        transform: Matrix4.translationValues(0, -5, 0),
        child: Center(
          child: GestureDetector(
            child: Container(
                height: 36,
                width: 100,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(18))),
                child: contentButton),
            onTap: action,
          ),
        ));
  }

  refresh() async {
    if (this.mounted)
      setState(() {
        this.isLoading = true;
      });
    List d = await widget.initRequester();
    if (this.mounted)
      setState(() {
        this.data = d;
        this.isLoading = false;
      });
  }

  loadMore() async {
    if (this.mounted)
      setState(() {
        this.isLoadMore = true;
      });
    List d = await widget.dataRequester(this.data.length);
    if (d != null && d.length > 0) {
      if (this.mounted)
        setState(() {
          this.data.addAll(d);
          this.isLoadMore = false;
        });
    } else {
      if (this.mounted)
        setState(() {
          this.isLoadMore = false;
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
