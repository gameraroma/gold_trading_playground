import 'package:flutter/material.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';
import 'package:gold_trading_playground/providers/providers.dart';

class AssetsHeaderCard extends StatelessWidget {
  const AssetsHeaderCard({
    Key? key,
    required this.goldAssetsNotifier,
    required this.goldPrices,
  }) : super(key: key);

  final GoldAssetsNotifier goldAssetsNotifier;
  final GoldPrices goldPrices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'สรุปราคา',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                    Expanded(
                      child: Text(
                        goldPrices.updateDateTime,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  goldAssetsNotifier.getUnrealisedSumDisplay(goldPrices),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  goldAssetsNotifier.getProfitSumDisplay(goldPrices),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: goldAssetsNotifier.getProfitTextColor(goldPrices)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
