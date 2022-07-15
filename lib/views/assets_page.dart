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
        "แหวนเกลี้ยง", GoldType.ornament, 8500, 2, GoldUnit.quarterOfBaht),
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
            return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                minLeadingWidth: 12,
                leading: Icon(typeIcon),
                title: Text(asset.name),
                subtitle: Text('${asset.weight} $unit'),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      asset.getUnrealisedDisplay(goldPrices),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 0,
                      height: 8,
                    ),
                    Text(
                      '(${asset.getProfitDisplay(goldPrices)})',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ));
          }),
      error: (err, stack) => const Text('ไม่สามารถดึงข้อมูลได้'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
