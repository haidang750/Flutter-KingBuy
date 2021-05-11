class InstallmentDetailModel {
  InstallmentDetailModel({
    this.id,
    this.total,
    this.monthsInstallment,
    this.prepayInstallmentAmount,
    this.prepayInstallment,
    this.payMonthlyInstallment,
    this.installmentType,
    this.installmentCardImage,
    this.bankId,
    this.bankName,
    this.bankImage,
  });

  int id;
  int total;
  int monthsInstallment;
  int prepayInstallmentAmount;
  int prepayInstallment;
  int payMonthlyInstallment;
  int installmentType;
  String installmentCardImage;
  int bankId;
  String bankName;
  String bankImage;

  factory InstallmentDetailModel.fromJson(Map<String, dynamic> json) => InstallmentDetailModel(
    id: json["id"],
    total: json["total"],
    monthsInstallment: json["months_installment"],
    prepayInstallmentAmount: json["prepay_installment_amount"],
    prepayInstallment: json["prepay_installment"],
    payMonthlyInstallment: json["pay_monthly_installment"],
    installmentType: json["installment_type"],
    installmentCardImage: json["installment_card_image"],
    bankId: json["bank_id"],
    bankName: json["bank_name"],
    bankImage: json["bank_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total": total,
    "months_installment": monthsInstallment,
    "prepay_installment_amount": prepayInstallmentAmount,
    "prepay_installment": prepayInstallment,
    "pay_monthly_installment": payMonthlyInstallment,
    "installment_type": installmentType,
    "installment_card_image": installmentCardImage,
    "bank_id": bankId,
    "bank_name": bankName,
    "bank_image": bankImage,
  };
}
