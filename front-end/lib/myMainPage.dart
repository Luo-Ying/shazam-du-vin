import 'package:flutter/material.dart';

import 'services/winesActions.dart';
import 'utils/eventBus.dart';

import 'components/floatingActionButionMenu.dart';
import 'components/wineCard.dart';
import 'utils/models.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({Key? key, required this.title, required this.listTopWines})
      : super(key: key);
  final String title;

  final List<Wine> listTopWines;

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  late List<Wine> listTopWines;

  @override
  void initState() {
    print("list top wines:  $listTopWines");
    print(listTopWines.length);
    eventBus.on("deleteWine", (arg) async {
      setState(() {
        listTopWines = WineActions.listTopWines;
      });
    });
    eventBus.on("addInFavoris", (arg) async {
      setState(() {});
    });
    eventBus.on("removeFromFavoris", (arg) async {
      setState(() {});
    });
    eventBus.on("deleteComment", (arg) {
      setState(() {
        listTopWines = WineActions.listTopWines;
      });
    });
    eventBus.on("addComment", (arg) {
      listTopWines = WineActions.listTopWines;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApBar(context),
      body: Container(
        child: builListViewOfListAllWine(context),
      ),
      floatingActionButton: buildMainMenu(context),
    );
  }

  Widget builListViewOfListAllWine(BuildContext context) {
    print("list alla wines: $listTopWines");
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          child: buildWineCard(
              context, listTopWines[index], index, false, true, false),
        );
      },
      itemCount: listTopWines.length,
    );
  }

  PreferredSize buildApBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: Column(
        children: [
          const SizedBox(
            height: 44.0,
          ),
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            elevation: 0,
            title: Stack(
              children: [
                const Text(
                  'Top 10 wines',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
                buildTitleLine(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, top: 49.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40,
          height: 2,
        ),
      ),
    );
  }

  // Future<void>
}
