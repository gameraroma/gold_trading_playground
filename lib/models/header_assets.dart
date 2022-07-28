import 'package:flutter/material.dart';

class HeaderAsset {
  final String updateDateTime;
  final String unrealisedSum;
  final String profitSum;
  final Color profitSumColor;

  bool get hasData => !(unrealisedSum.isEmpty && profitSum.isEmpty);

  HeaderAsset(this.updateDateTime, this.unrealisedSum, this.profitSum, this.profitSumColor);
}