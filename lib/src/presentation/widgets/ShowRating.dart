import 'package:flutter/material.dart';

class ShowRating extends StatefulWidget {
  ShowRating({this.star, this.starSize});
  int star;
  double starSize;

  @override
  ShowRatingState createState() => ShowRatingState();
}

class ShowRatingState extends State<ShowRating> {
  @override
  Widget build(BuildContext context) {
    return buildRating(widget.star, widget.starSize);
  }

  Widget buildRating(int star, double starSize) {
    return Row(children: buildStar(star, starSize));
  }

  List<Icon> buildStar(int star, double starSize) {
    List<Icon> stars = [];
    for (var i = 0; i < star; i++) {
      stars.add(Icon(
        Icons.star_rounded,
        color: Colors.yellow.shade600,
        size: starSize,
      ));
    }

    for (var i = 0; i < 5 - star; i++) {
      stars.add(Icon(
        Icons.star_rounded,
        color: Colors.grey,
        size: starSize,
      ));
    }
    return stars;
  }
}
