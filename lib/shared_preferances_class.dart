import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass {
  SharedPreferences? instance;
  List<Map<String, String>> keys = [];

  Future<void> setValue(String key, List<String> value) async {
    print(value);
    instance ??= await SharedPreferences.getInstance();
    await instance!.setStringList(key, value);
  }

  Future<List<String>?> getValue(String key) async {
    instance ??= await SharedPreferences.getInstance();
    print(instance!.getStringList(key));
    return instance!.getStringList(key);
  }
}
