import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/models/gold_asset.dart';

class AssetsPage extends ConsumerStatefulWidget {
  const AssetsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends ConsumerState<AssetsPage> {
  List<GoldAsset> assets = [
    GoldAsset.createNew("ทองแท่งร้านฮั่วเซ่งเฮง", GoldType.bullion, 28000, 5, GoldUnit.baht),
    GoldAsset.createNew("ลายมังกร", GoldType.ornament, 27000, 3, GoldUnit.baht),
    GoldAsset.createNew("แหวนเกลี้ยง", GoldType.ornament, 6500, 2, GoldUnit.quarterOfBaht),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: assets.length,
        itemBuilder: (BuildContext context, int index) {
          final asset = assets[index];
          IconData typeIcon = asset.type == GoldType.ornament ? Icons.all_inclusive : Icons.crop_portrait;
          String unit = asset.unit == GoldUnit.baht ? 'บาท' : 'สลึง';
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
            minLeadingWidth: 12,
            leading: Icon(typeIcon),
            title: Text(asset.name),
            subtitle: Text('${asset.weight} $unit'),
            trailing: Text(
              asset.costDisplay,
              style: const TextStyle(fontSize: 20),
            ),
          );
        }
    );
  }
}