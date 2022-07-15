import 'package:flutter/material.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';
import 'package:intl/intl.dart';

enum GoldType { bullion, ornament }

enum GoldUnit { baht, quarterOfBaht }

class GoldAsset {
  final String id;
  final String name;
  final GoldType type;
  final double cost;
  final int weight;
  final GoldUnit unit;

  String get costDisplay {
    var formatter = NumberFormat('#,##,000');
    return '${formatter.format(cost)} ฿';
  }

  String getUnrealisedDisplay(GoldPrices currentPrices) {
    var currentPrice =
        type == GoldType.bullion ? currentPrices.blBuy : currentPrices.omBuy;
    final bahtWeight = unit == GoldUnit.quarterOfBaht ? 0.25 * weight : weight;
    if (currentPrice == GoldPrices.naText) {
      return 'คำนวนไม่ได้';
    }
    currentPrice = currentPrice.replaceAll(',', '');
    var price = bahtWeight * double.parse(currentPrice);
    var formatter = NumberFormat('#,000.00');
    return formatter.format(price);
  }

  String getProfitDisplay(GoldPrices currentPrices) {
    var currentPrice =
        type == GoldType.bullion ? currentPrices.blBuy : currentPrices.omBuy;
    final bahtWeight = unit == GoldUnit.quarterOfBaht ? 0.25 * weight : weight;
    if (currentPrice == GoldPrices.naText) {
      return 'คำนวนไม่ได้';
    }
    currentPrice = currentPrice.replaceAll(',', '');
    var price = bahtWeight * double.parse(currentPrice);
    var profit = price - cost;
    var formatter = NumberFormat('#,000.00');
    var sign = profit > 0 ? '+' : '';
    return '$sign${formatter.format(profit)}';
  }

  Color getProfitTextColor(GoldPrices currentPrices) {
    final profit = getProfit(currentPrices);
    if (profit > 0) {
      return Colors.green;
    } else if (profit < 0) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  double getProfit(GoldPrices currentPrices) {
    var currentPrice =
        type == GoldType.bullion ? currentPrices.blSell : currentPrices.omSell;
    final bahtWeight = unit == GoldUnit.quarterOfBaht ? 0.25 * weight : weight;
    if (currentPrice == GoldPrices.naText) {
      return 0;
    }
    currentPrice = currentPrice.replaceAll(',', '');
    var price = bahtWeight * double.parse(currentPrice);
    var profit = price - cost;
    return profit;
  }

  GoldAsset(this.id, this.name, this.type, this.cost, this.weight, this.unit);

  factory GoldAsset.createNew(
      String name, GoldType type, double cost, int weight, GoldUnit unit) {
    return GoldAsset(UniqueKey().toString(), name, type, cost, weight, unit);
  }
}
