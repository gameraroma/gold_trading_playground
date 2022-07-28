import 'package:flutter/material.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';
import 'package:intl/intl.dart';

enum GoldType {
  bullion,
  ornament;

  String value() {
    switch (this) {
      case GoldType.bullion:
        return 'bullion';
      case GoldType.ornament:
        return 'ornament';
    }
  }

  static GoldType parse(String value) {
    switch (value) {
      case 'bullion':
        return GoldType.bullion;
      case 'ornament':
        return GoldType.ornament;
      default:
        return GoldType.bullion;
    }
  }
}

enum GoldUnit {
  baht,
  quarterOfBaht;

  String value() {
    switch (this) {
      case GoldUnit.baht:
        return 'baht';
      case GoldUnit.quarterOfBaht:
        return 'quarterOfBaht';
    }
  }

  static GoldUnit parse(String value) {
    switch (value) {
      case 'baht':
        return GoldUnit.baht;
      case 'quarterOfBaht':
        return GoldUnit.quarterOfBaht;
      default:
        return GoldUnit.baht;
    }
  }
}

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
    if (currentPrices.isError) {
      return '';
    }
    var price = getUnrealised(currentPrices);
    var formatter = NumberFormat('#,000.00');
    return formatter.format(price);
  }

  String getProfitDisplay(GoldPrices currentPrices) {
    if (currentPrices.isError) {
      return '';
    }
    final profit = getProfit(currentPrices);
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

  double getUnrealised(GoldPrices currentPrices) {
    var currentPrice =
        type == GoldType.bullion ? currentPrices.blBuy : currentPrices.omBuy;
    final bahtWeight = unit == GoldUnit.quarterOfBaht ? 0.25 * weight : weight;
    if (currentPrice == GoldPrices.naText) {
      return 0;
    }
    currentPrice = currentPrice.replaceAll(',', '');
    var price = bahtWeight * double.parse(currentPrice);
    return price;
  }

  double getProfit(GoldPrices currentPrices) {
    var currentPrice =
        type == GoldType.bullion ? currentPrices.blBuy : currentPrices.omBuy;
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

  GoldAsset.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = GoldType.parse(json['type'].toString()),
        cost = json['cost'],
        weight = json['weight'],
        unit = GoldUnit.parse(json['unit'].toString());

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.value(),
        'cost': cost,
        'weight': weight,
        'unit': unit.value(),
      };
}
