import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass {
  SharedPreferences? instance;
  List<Map<String, String>> keys = [];

  // Future<void> init() async {
  //   instance = await SharedPreferences.getInstance();
  // }

  Future<void> setValue(String key, List<String> value) async {
    print(value);
    instance ??= await SharedPreferences.getInstance();
    await instance!.setStringList(key, value);
  }

  Future<List<String>?> getValue(String key) async {
    // String key = getKeyByValue(keys, value) ?? '';
    instance ??= await SharedPreferences.getInstance();
    print(instance!.getStringList(key));
    return instance!.getStringList(key);
  }

  String? getKeyByValue(List<Map<String, String>> list, String value) {
    for (var map in list) {
      for (var entry in map.entries) {
        if (entry.value == value) {
          return entry.key;
        }
      }
    }
    return null;
  }
}
