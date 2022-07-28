import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/providers/providers.dart';

class AssetsHeaderCard extends ConsumerWidget {
  const AssetsHeaderCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerAssets = ref.watch(headerAssetsProvider);
    return headerAssets.when(
      data: (headerAssets) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
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
                          headerAssets.updateDateTime,
                          textAlign: TextAlign.end,
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !headerAssets.hasData,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ไม่มีข้อมูล',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Visibility(
                  visible: headerAssets.hasData,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          headerAssets.unrealisedSum,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          headerAssets.profitSum,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: headerAssets.profitSumColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      error: (err, stack) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text('ไม่สามารถดึงข้อมูลได้'),
            ),
          )
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
