import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum GoldType {
  bullion,
  ornament
}

enum GoldUnit {
  baht,
  quarterOfBaht
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

  GoldAsset(this.id, this.name, this.type, this.cost, this.weight, this.unit);

  factory GoldAsset.createNew(String name, GoldType type, double cost, int weight, GoldUnit unit) {
    return GoldAsset(UniqueKey().toString(), name, type, cost, weight, unit);
  }
}