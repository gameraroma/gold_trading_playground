import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';
import 'package:gold_trading_playground/providers/providers.dart';

import 'gold_prices_board.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final goldPrices = ref.watch(goldPricesProvider);
    if (goldPrices.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return goldPrices.when(
      data: (goldPrices) => GoldPricesBoard(goldPrices),
      error: (err, stack) => GoldPricesBoard(GoldPrices.errors()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
