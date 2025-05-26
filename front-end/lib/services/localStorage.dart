import 'package:shared_preferences/shared_preferences.dart';

/// save and read data

/// int
saveDataInt() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setInt('Key_Int', 12);
}

Future<int> readDataInt() async {
  var prefs = await SharedPreferences.getInstance();
  var result = prefs.getInt('Key_Int');
  return result ?? 0;
}

/// double
saveDataDouble() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setDouble('Key_Double', 12.0);
}

Future<double> readDataDouble() async {
  var prefs = await SharedPreferences.getInstance();
  var result = prefs.getDouble('Key_Double');
  return result ?? 0.0;
}

/// bool
saveDataBool() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setBool('Key_Bool', true);
}

Future<bool> readDataBool() async {
  var prefs = await SharedPreferences.getInstance();
  var result = prefs.getBool('Key_Bool');
  return result ?? false;
}

/// String
saveDataString(String key, String value) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<String> readDataString(String key) async {
  var prefs = await SharedPreferences.getInstance();
  var result = prefs.getString(key);
  return result ?? '';
}

/// String list
saveDataStringLIst() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setStringList('Key_StringList', ['laomeng', 'Flutter']);
}

Future<List<String>> readDataStringList() async {
  var prefs = await SharedPreferences.getInstance();
  var result = prefs.getStringList('Key_StringList');
  return result ?? [];
}

/// delete data

/// 删除指定 Key 的数据：
Future<void> deleteData(String key) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

/// 清除所有数据 ::: 谨慎使用!!!
Future<void> clearData() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

/// 获取所有的 Key：
Future<Object> getKeys() async {
  var prefs = await SharedPreferences.getInstance();
  var keys = prefs.getKeys();
  return keys;
}

/// 检测是否 Key 是否存在：
Future<bool> containsKey() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('Key');
}

Future<Map<String, dynamic>> getAllContents() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  final prefsMap = Map<String, dynamic>();
  for (String key in keys) {
    prefsMap[key] = prefs.get(key);
  }
  return prefsMap;
}
