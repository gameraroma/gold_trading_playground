import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/models/gold_asset.dart';
import 'package:gold_trading_playground/providers/providers.dart';

class AssetsPage extends ConsumerStatefulWidget {
  const AssetsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends ConsumerState<AssetsPage> {
  List<GoldAsset> assets = [
    GoldAsset.createNew(
        "ทองแท่งร้านฮั่วเซ่งเฮง", GoldType.bullion, 160000, 5, GoldUnit.baht),
    GoldAsset.createNew("ลายมังกร", GoldType.ornament, 81000, 3, GoldUnit.baht),
    GoldAsset.createNew(
        "แหวนเกลี้ยง", GoldType.ornament, 14000, 2, GoldUnit.quarterOfBaht),
  ];

  @override
  Widget build(BuildContext context) {
    final goldPricesFuture = ref.watch(goldPricesProvider);
    if (goldPricesFuture.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return goldPricesFuture.when(
      data: (goldPrices) => ListView.builder(
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
                    Expanded(
                      flex: 1,
                      child: Icon(typeIcon),
                    ),
                    Expanded(
                      flex: 5,
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
                    Expanded(
                      flex: 4,
                      child: Column(
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
                    ),
                  ],
                ),
              ),
            );
          }),
      error: (err, stack) => const Text('ไม่สามารถดึงข้อมูลได้'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
