import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/models/gold_asset.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';
import 'package:gold_trading_playground/models/header_assets.dart';
import 'package:gold_trading_playground/services/gold_asset_service.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

final changeMasterTabProvider = StateProvider((ref) => 0);

final priceTextColorProvider = StateProvider((ref) {
  return Colors.black;
});

final goldPricesProvider = FutureProvider<GoldPrices>((ref) async {
  final response = await Client()
      .get(Uri.parse('https://www.goldtraders.or.th/default.aspx'));
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
  GoldAssetsNotifier() : super([]);
  var isLoaded = false;

  List<GoldAsset> get assets => state;

  void loadAssets() async {
    final assets = await GoldAssetService().readAssets();
    isLoaded = true;
    state = assets;
  }

  void addAsset(GoldAsset asset) {
    state = [...state, asset];
  }

  void removeAsset(String assetId) {
    state = [
      for (final asset in state)
        if (asset.id != assetId) asset,
    ];
  }
}

final headerAssetsProvider = Provider<AsyncValue<HeaderAsset>>((ref) {
  final goldPrices = ref.watch(goldPricesProvider);
  final goldAssets = ref.watch(goldAssetsProvider);
  final isGoldAssetsLoaded = ref.read(goldAssetsProvider.notifier).isLoaded;

  if (goldPrices.hasError) {
    return AsyncValue.error(goldPrices);
  }

  final goldPricesValue = goldPrices.value;
  if (goldPrices.isLoading || !isGoldAssetsLoaded || goldPricesValue == null) {
    return const AsyncValue.loading();
  }

  final String unrealisedSum;
  if (goldAssets.isEmpty) {
    unrealisedSum = '';
  } else {
    final sum = goldAssets
        .map((e) => e.getUnrealised(goldPricesValue))
        .reduce((a, b) => a + b);
    var formatter = NumberFormat('#,000.00');
    unrealisedSum = '${formatter.format(sum)} บาท';
  }

  final String profitSum;
  if (goldAssets.isEmpty) {
    profitSum = '';
  } else {
    final profit =
        goldAssets.map((e) => e.getProfit(goldPricesValue)).reduce((a, b) => a + b);
    var formatter = NumberFormat('#,000.00');
    var sign = profit >= 0 ? 'กำไร' : 'ขาดทุน';
    profitSum = '$sign ${formatter.format(profit.abs())} บาท';
  }

  final Color profitTextColor;
  if (goldAssets.isEmpty) {
    profitTextColor = Colors.black;
  } else {
    final profit =
        goldAssets.map((e) => e.getProfit(goldPricesValue)).reduce((a, b) => a + b);
    if (profit > 0) {
      profitTextColor = Colors.green;
    } else if (profit < 0) {
      profitTextColor = Colors.red;
    } else {
      profitTextColor = Colors.black;
    }
  }

  final headerAsset = HeaderAsset(
      goldPricesValue.updateDateTime, unrealisedSum, profitSum, profitTextColor);
  return AsyncValue.data(headerAsset);
});
