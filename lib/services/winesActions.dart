import 'package:flutter/cupertino.dart';

import '../utils/eventBus.dart';
import '../utils/models.dart';
import 'http_service.dart';

late final HttpService _httpService = HttpService();

Future<void> addWineToFavoris(BuildContext context, Wine wineSelected) async {}

Future<void> removeWineFromFavoris(
    BuildContext context, Wine wineSelected) async {}

Future<void> deleteWine(BuildContext context, Wine wineSelected) async {
  var wineSelectedFormated = {
    "database": "urbanisation",
    "collection": "Vin",
    "filter": {
      "id": wineSelected.id,
    }
  };
  print(wineSelected.id);
  var res = await _httpService.deleteWine(wineSelectedFormated);
  if (res.statusCode == 200) {
    Navigator.pop(context);
    eventBus.emit("deleteWine");
  }
}
