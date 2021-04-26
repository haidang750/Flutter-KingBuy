import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Future<List> DataRequester(int offset);
typedef Future<List> InitRequester();
typedef Widget ItemBuilder(List data, BuildContext context, int index);

class MyGridView extends StatefulWidget {
  MyGridView(
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
  State createState() => new MyGridViewState();
}

class MyGridViewState extends State<MyGridView> {
  bool isLoadMore = false, isLoading = true;
  List data = [];
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (!this.isLoadMore &&
          _controller.position.pixels == _controller.position.maxScrollExtent) {
        loadMore();
      }
    });
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    var footer;
    if (this.isLoadMore) {
      footer = Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      footer = Container();
    }
    if (this.isLoading)
      return Center(child: CircularProgressIndicator());
    else if (data == null || data.length == 0) {
      return Center(child: Text("Không có dữ liệu"));
    } else {
      return new CustomScrollView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(bottom: 10),
              sliver: widget.childAspectRatio != null &&
                      widget.crossAxisCount != null
                  ? new SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: widget.childAspectRatio,
                        crossAxisCount: widget.crossAxisCount,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return widget.itemBuilder(data, context, index);
                      }, childCount: data.length),
                    )
                  : new SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            (MediaQuery.of(context).size.width / 3),
                      ),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return widget.itemBuilder(data, context, index);
                      }, childCount: data.length),
                    ),
            ),
            new SliverToBoxAdapter(
              child: footer,
            ),
          ],
          controller: _controller);
    }
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
    _controller.dispose();
  }
}
