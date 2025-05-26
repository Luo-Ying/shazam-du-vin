import '../utils/models.dart';

class VarGlobal {
  static String TOASTMESSAGE = "";

  static User currentUser = User("", "", "", VinFav([]));

  static List<Wine> LISTALLWINES = [];
  static List<Wine> LISTTOPWINES = [];
  static List<Wine> LISTFAVWINES = [];
}
