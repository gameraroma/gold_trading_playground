import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/models/gold_asset.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

final changeMasterTabProvider = StateProvider((ref) => 0);

final priceTextColorProvider = StateProvider((ref) {
  return Colors.black;
});

final goldPricesProvider = FutureProvider<GoldPrices>((ref) async {
  final response =
      await Client().get(Uri.parse('https://www.goldtraders.or.th'));
  var document = parse(response.body);
  final updateDateTime = document
      .querySelectorAll('#DetailPlace_uc_goldprices1_lblAsTime')[0]
      .text;
  final blSell = document
      .querySelectorAll('#DetailPlace_uc_goldprices1_lblBLSell')[0]
      .text;
  final blBuy =
      document.querySelectorAll('#DetailPlace_uc_goldprices1_lblBLBuy')[0].text;
  final omSell = document
      .querySelectorAll('#DetailPlace_uc_goldprices1_lblOMSell')[0]
      .text;
  final omBuy =
      document.querySelectorAll('#DetailPlace_uc_goldprices1_lblOMBuy')[0].text;
  final colorString = document
      .querySelectorAll('#DetailPlace_uc_goldprices1_lblBLSell font[color]')[0]
      .attributes['color'];

  var textColor = Colors.black87;
  switch (colorString) {
    case "Green":
      textColor = Colors.green;
      break;
    case "Red":
      textColor = Colors.red;
      break;
  }
  ref.read(priceTextColorProvider.notifier).state = textColor;

  final goldPrices = GoldPrices(updateDateTime, blSell, blBuy, omSell, omBuy);
  return goldPrices;
});

final goldAssetsProvider =
    StateNotifierProvider<GoldAssetsNotifier, List<GoldAsset>>((ref) {
  return GoldAssetsNotifier();
});

class GoldAssetsNotifier extends StateNotifier<List<GoldAsset>> {
  GoldAssetsNotifier()
      : super([
          GoldAsset.createNew("ทองแท่งร้านฮั่วเซ่งเฮง", GoldType.bullion,
              160000, 5, GoldUnit.baht),
          GoldAsset.createNew(
              "ลายมังกร", GoldType.ornament, 81000, 3, GoldUnit.baht),
          GoldAsset.createNew("แหวนเกลี้ยง", GoldType.ornament, 14000, 2,
              GoldUnit.quarterOfBaht),
          GoldAsset.createNew("ทองแท่งร้านแถวบ้าน", GoldType.bullion,
              69000, 2, GoldUnit.baht),
          GoldAsset.createNew(
              "ลาย 4 เสา", GoldType.ornament, 82500, 3, GoldUnit.baht),
        ]);

  List<GoldAsset> get assets => state;

  void addAsset(GoldAsset asset) {
    state = [...state, asset];
  }

  void removeAsset(String assetId) {
    state = [
      for (final asset in state)
        if (asset.id != assetId) asset,
    ];
  }

  String getUnrealisedSumDisplay(GoldPrices goldPrices) {
    final sum =
        state.map((e) => e.getUnrealised(goldPrices)).reduce((a, b) => a + b);
    var formatter = NumberFormat('#,000.00');
    return '${formatter.format(sum)} บาท';
  }

  String getProfitSumDisplay(GoldPrices goldPrices) {
    final profit =
        state.map((e) => e.getProfit(goldPrices)).reduce((a, b) => a + b);
    var formatter = NumberFormat('#,000.00');
    var sign = profit >= 0 ? 'กำไร' : 'ขาดทุน';
    return '$sign ${formatter.format(profit.abs())} บาท';
  }

  Color getProfitTextColor(GoldPrices goldPrices) {
    final profit =
        state.map((e) => e.getProfit(goldPrices)).reduce((a, b) => a + b);
    if (profit > 0) {
      return Colors.green;
    } else if (profit < 0) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
