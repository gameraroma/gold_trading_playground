class GoldPrices {
  static const String naText = "N/A";

  String updateDateTime;
  String blSell;
  String blBuy;
  String omSell;
  String omBuy;

  GoldPrices(this.updateDateTime, this.blSell, this.blBuy, this.omSell, this.omBuy);

  factory GoldPrices.errors() {
    return GoldPrices(naText, naText, naText, naText, naText);
  }
}