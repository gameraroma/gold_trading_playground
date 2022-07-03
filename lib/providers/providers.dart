import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

final priceTextColorProvider = StateProvider((ref) {
  return Colors.black;
});

final goldPricesProvider = FutureProvider<GoldPrices>((ref) async {
  final response = await Client().get(Uri.parse('https://www.goldtraders.or.th'));
  var document = parse(response.body);
  final updateDateTime = document.querySelectorAll('#DetailPlace_uc_goldprices1_lblAsTime')[0].text;
  final blSell = document.querySelectorAll('#DetailPlace_uc_goldprices1_lblBLSell')[0].text;
  final blBuy = document.querySelectorAll('#DetailPlace_uc_goldprices1_lblBLBuy')[0].text;
  final omSell = document.querySelectorAll('#DetailPlace_uc_goldprices1_lblOMSell')[0].text;
  final omBuy = document.querySelectorAll('#DetailPlace_uc_goldprices1_lblOMBuy')[0].text;
  final colorString = document.querySelectorAll('#DetailPlace_uc_goldprices1_lblBLSell font[color]')[0].attributes['color'];

  var textColor = Colors.black87;
  switch (colorString)
  {
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