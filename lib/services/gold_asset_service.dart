import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gold_trading_playground/models/gold_asset.dart';
import 'package:path_provider/path_provider.dart';

class GoldAssetService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/gold_assets.txt');
  }

  Future<List<GoldAsset>> readAssets() async {
    try {
      final file = await _localFile;
      final data = [
        GoldAsset.createNew("ทองแท่งร้านฮั่วเซ่งเฮง", GoldType.bullion,
            160000, 5, GoldUnit.baht),
        GoldAsset.createNew(
            "ลายมังกร", GoldType.ornament, 81000, 3, GoldUnit.baht),
        GoldAsset.createNew("แหวนเกลี้ยง", GoldType.ornament, 14000, 2,
            GoldUnit.quarterOfBaht),
        GoldAsset.createNew("ทองแท่งร้านแถวบ้าน", GoldType.bullion,
            69000, 2, GoldUnit.baht),
        GoldAsset.createNew(
            "ลาย 4 เสา", GoldType.ornament, 82500, 3, GoldUnit.baht),
      ];

      // final String contents = await file.readAsString();

      final String contents = jsonEncode(data);
      if (contents.isEmpty) {
        return <GoldAsset>[];
      }
      final List t = jsonDecode(contents);
      final List<GoldAsset> assets = t
          .map((item) => GoldAsset.fromJson(item))
          .toList();
      return assets;
    } catch (e) {
      return <GoldAsset>[];
    }
  }

  Future<File> writeAssets(GoldAsset asset) async {
    final file = await _localFile;
    List<GoldAsset> assets = await readAssets();
    assets.add(asset);
    final contents = jsonEncode(assets);
    return file.writeAsString(contents);
  }
}