import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/models/gold_asset.dart';
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
  initState() {
    super.initState();
    ref.read(goldAssetsProvider.notifier).loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    final goldPricesFuture = ref.watch(goldPricesProvider);
    final goldAssetsProviderNotifier = ref.read(goldAssetsProvider.notifier);
    assets = ref.watch(goldAssetsProvider);
    if (goldPricesFuture.isLoading || !goldAssetsProviderNotifier.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    final isEmpty = assets.isEmpty;
    final hasData = assets.isNotEmpty;
    return goldPricesFuture.when(
      data: (goldPrices) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.clamp,
            colors: [
              Colors.black12,
              Colors.white,
            ],
          ),
        ),
        width: double.infinity,
        child: ListView(
          children: [
            const AssetsHeaderCard(),
            Visibility(
              visible: isEmpty,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ยังไม่มีข้อมูล',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(height: 8),
                        MaterialButton(
                          onPressed: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: Text(
                                '+ เพิ่มทอง',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: hasData,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 14),
                    ),
                  ),
                ],
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
