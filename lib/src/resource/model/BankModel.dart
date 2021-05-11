class BankModel {
  BankModel({
    this.status,
    this.banks,
    this.message,
  });

  int status;
  List<Bank> banks;
  String message;

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
    status: json["status"],
    banks: List<Bank>.from(json["data"].map((x) => Bank.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(banks.map((x) => x.toJson())),
    "message": message,
  };
}

class Bank {
  Bank({
    this.id,
    this.name,
    this.imageSource,
  });

  int id;
  String name;
  String imageSource;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    id: json["id"],
    name: json["name"],
    imageSource: json["image_source"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_source": imageSource,
  };
}
