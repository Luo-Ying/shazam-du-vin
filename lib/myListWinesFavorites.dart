import 'package:flutter/cupertino.dart';

import 'utils/models.dart';

class MyListWinesFavorites extends StatefulWidget {
  const MyListWinesFavorites({Key? key, required this.listWinesFavorites})
      : super(key: key);

  final List<Wine> listWinesFavorites;

  @override
  _MyListWinesFavoritesState createState() {
    return _MyListWinesFavoritesState(listWinesFavorites);
  }
}

class _MyListWinesFavoritesState extends State<MyListWinesFavorites> {
  List<Wine> listWinesFavorites;

  _MyListWinesFavoritesState(this.listWinesFavorites);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
