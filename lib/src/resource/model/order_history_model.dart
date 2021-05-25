import 'package:projectui/src/resource/model/invoice_model.dart';

class OrderHistoryModel {
  OrderHistoryModel({
    this.invoices,
    this.recordsTotal,
  });

  List<InvoiceData> invoices;
  int recordsTotal;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        invoices: List<InvoiceData>.from(json["rows"].map((x) => InvoiceData.fromJson(x))),
        recordsTotal: json["recordsTotal"],
      );

  Map<String, dynamic> toJson() => {
        "rows": List<dynamic>.from(invoices.map((x) => x.toJson())),
        "recordsTotal": recordsTotal,
      };
}


