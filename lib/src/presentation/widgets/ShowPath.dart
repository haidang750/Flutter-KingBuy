import 'package:flutter/material.dart';

class ShowPath extends StatefulWidget {
  ShowPath({this.rootTab, this.parentTab, this.childTab});

  String rootTab;
  String parentTab;
  String childTab;

  @override
  ShowPathState createState() => ShowPathState();
}

class ShowPathState extends State<ShowPath> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Image.asset(
            "assets/home.png",
            height: 20,
            width: 20,
            color: Colors.black,
          ),
          buildOneTab(contentTab: widget.rootTab),
          widget.parentTab != null ? buildOneTab(contentTab: widget.parentTab) : Container(),
          buildOneTab(contentTab: widget.childTab)
        ],
      ),
    );
  }

  Widget buildOneTab({String contentTab}) {
    return Row(
      children: [
        SizedBox(width: 3),
        Icon(
          Icons.arrow_forward_ios_outlined,
          size: 12,
        ),
        SizedBox(width: 3),
        Container(alignment: Alignment.center, child: Text(contentTab, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)))
      ],
    );
  }
}
