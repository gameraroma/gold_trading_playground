import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';
import 'package:gold_trading_playground/providers/providers.dart';

import 'gold_prices_board.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final config = ref.watch(goldPricesProvider);
        if (config.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return config.when(
          data: (goldPrices) => GoldPricesBoard(goldPrices),
          error: (err, stack) => GoldPricesBoard(GoldPrices.errors()),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
