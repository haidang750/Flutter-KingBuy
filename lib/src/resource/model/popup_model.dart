class PopupModel {
  PopupModel({
    this.status,
    this.popupData,
  });

  int status;
  PopupData popupData;

  factory PopupModel.fromJson(Map<String, dynamic> json) => PopupModel(
        status: json["status"],
        popupData: PopupData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": popupData.toJson(),
      };
}

class PopupData {
  PopupData({
    this.popupImage,
    this.popupProductId,
    this.popupType,
    this.popupLink,
  });

  String popupImage;
  int popupProductId;
  int popupType;
  String popupLink;

  factory PopupData.fromJson(Map<String, dynamic> json) => PopupData(
        popupImage: json["popup_image"],
        popupProductId: json["popup_product_id"],
        popupType: json["popup_type"],
        popupLink: json["popup_link"],
      );

  Map<String, dynamic> toJson() => {
        "popup_image": popupImage,
        "popup_product_id": popupProductId,
        "popup_type": popupType,
        "popup_link": popupLink,
      };
}
