import '../utils/models.dart';

class VarGlobal {
  static double heightBottomNavigationBar = 0;

  static String TOASTMESSAGE = "";

  static User currentUser = User("", "", "", VinFav([]));

  static List<Wine> LISTALLWINES = [];
  static List<Wine> LISTTOPWINES = [];
  static List<Wine> LISTFAVWINES = [];
}
