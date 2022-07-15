import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/models/gold_asset.dart';
import 'package:gold_trading_playground/models/gold_prices.dart';
import 'package:gold_trading_playground/providers/providers.dart';
import 'package:gold_trading_playground/views/assets_header_card.dart';
import 'package:gold_trading_playground/views/assets_list_view.dart';

class AssetsPage extends ConsumerStatefulWidget {
  const AssetsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends ConsumerState<AssetsPage> {
  List<GoldAsset> assets = [];

  @override
  Widget build(BuildContext context) {
    final goldPricesFuture = ref.watch(goldPricesProvider);
    final goldAssetsNotifier = ref.watch(goldAssetsProvider.notifier);
    assets = goldAssetsNotifier.assets;
    if (goldPricesFuture.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return goldPricesFuture.when(
      data: (goldPrices) => SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AssetsHeaderCard(
              goldAssetsNotifier: goldAssetsNotifier,
              goldPrices: goldPrices,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Text(
                'ทองที่มี (${assets.length} ชิ้น)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            AssetsListView(
              assets: assets,
              goldPrices: goldPrices,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'ราคาขายจริงอาจจะไม่ได้ราคาตามที่แสดงในแอพนี้ เนื่องจากน้ำหนักทองอาจจะหายไปบางส่วน ราคารับซื้อแต่ละร้านก็ไม่เท่ากันและถูกหักไปบางส่วน',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      error: (err, stack) => const Text('ไม่สามารถดึงข้อมูลได้'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
