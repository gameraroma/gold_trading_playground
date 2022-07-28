class GoldPrices {
  static const String naText = "N/A";

  String updateDateTime;
  String blSell;
  String blBuy;
  String omSell;
  String omBuy;

  bool get isError => updateDateTime == naText;

  GoldPrices(this.updateDateTime, this.blSell, this.blBuy, this.omSell, this.omBuy);

  factory GoldPrices.errors() {
    return GoldPrices(naText, naText, naText, naText, naText);
  }
}