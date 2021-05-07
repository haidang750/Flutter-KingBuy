class RatingModel {
  RatingModel({
    this.oneStarCount,
    this.twoStarCount,
    this.threeStarCount,
    this.fourStarCount,
    this.fiveStarCount,
    this.avgRating,
    this.ratingCount,
  });

  int oneStarCount;
  int twoStarCount;
  int threeStarCount;
  int fourStarCount;
  int fiveStarCount;
  double avgRating;
  int ratingCount;

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
    oneStarCount: json["one_star_count"],
    twoStarCount: json["two_star_count"],
    threeStarCount: json["three_star_count"],
    fourStarCount: json["four_star_count"],
    fiveStarCount: json["five_star_count"],
    avgRating: json["avg_rating"] * 1.0,
    ratingCount: json["rating_count"],
  );

  Map<String, dynamic> toJson() => {
    "one_star_count": oneStarCount,
    "two_star_count": twoStarCount,
    "three_star_count": threeStarCount,
    "four_star_count": fourStarCount,
    "five_star_count": fiveStarCount,
    "avg_rating": avgRating,
    "rating_count": ratingCount,
  };
}
