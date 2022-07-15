import 'package:flutter/material.dart';
import 'package:gold_trading_playground/models/gold_asset.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';

class AssetsListView extends StatelessWidget {
  const AssetsListView({
    Key? key,
    required this.assets,
    required this.goldPrices,
  }) : super(key: key);

  final List<GoldAsset> assets;
  final GoldPrices goldPrices;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        itemCount: assets.length,
        itemBuilder: (BuildContext context, int index) {
          final asset = assets[index];
          IconData typeIcon = asset.type == GoldType.ornament
              ? Icons.all_inclusive
              : Icons.crop_portrait;
          String unit = asset.unit == GoldUnit.baht ? 'บาท' : 'สลึง';
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(typeIcon),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(asset.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium),
                          Text(
                            '${asset.weight} $unit',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        asset.getUnrealisedDisplay(goldPrices),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        width: 0,
                        height: 8,
                      ),
                      Text(
                        asset.getProfitDisplay(goldPrices),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: asset.getProfitTextColor(goldPrices),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
