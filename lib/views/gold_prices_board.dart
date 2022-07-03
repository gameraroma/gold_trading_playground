import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';
import 'package:gold_trading_playground/providers/providers.dart';

class GoldPricesBoard extends StatelessWidget {
  final sellTitle = 'ขายออก';
  final buyTitle = 'รับซื้อ';

  final GoldPrices goldPrices;

  const GoldPricesBoard(this.goldPrices, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            Text(
              "ทองคำแท่ง 96.5% (บาท)",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            PriceRow(title: sellTitle, value: goldPrices.blSell),
            PriceRow(title: buyTitle, value: goldPrices.blBuy),
            const Divider(color: Colors.black45),
            const SizedBox(height: 16),
            Text(
              "ทองรูปพรรณ 96.5% (บาท)",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            PriceRow(title: sellTitle, value: goldPrices.omSell),
            PriceRow(title: buyTitle, value: goldPrices.omBuy),
            const Divider(color: Colors.black45),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer(builder: (context, ref, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            goldPrices.updateDateTime,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            color: Colors.black54,
                            onPressed: () async {
                              ref.refresh(goldPricesProvider);
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                )),
          ],
        ),
      ],
    );
  }
}

class PriceRow extends StatelessWidget {
  const PriceRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Spacer(),
          Consumer(builder: (context, ref, child) {
            final textColor = ref.watch(priceTextColorProvider);
            return Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: textColor),
            );
          })
        ],
      ),
    );
  }
}