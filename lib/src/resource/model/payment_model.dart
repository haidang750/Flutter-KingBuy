class PaymentModel {
  PaymentModel({
    this.status,
    this.paymentUrl,
    this.message,
  });

  int status;
  PaymentUrl paymentUrl;
  String message;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        status: json["status"],
        paymentUrl: PaymentUrl.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": paymentUrl.toJson(),
        "message": message,
      };
}

class PaymentUrl {
  PaymentUrl({
    this.url,
  });

  String url;

  factory PaymentUrl.fromJson(Map<String, dynamic> json) => PaymentUrl(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
