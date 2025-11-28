import 'package:shared_preferences/shared_preferences.dart';

class FakeCallLocalStorage {
  static const _keyName = 'fake_call_name';
  static const _keyNumber = 'fake_call_number';
  static const _keyImage = 'fake_call_image';
  static const _keyTimer = 'fake_call_timer';

  Future<void> saveCallerDetails({
    required String name,
    required String number,
    String? imagePath,
    required int timer,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyNumber, number);
    if (imagePath != null) {
      await prefs.setString(_keyImage, imagePath);
    } else {
      await prefs.remove(_keyImage);
    }
    await prefs.setInt(_keyTimer, timer);
  }

  Future<Map<String, dynamic>?> getCallerDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyName);
    final number = prefs.getString(_keyNumber);
    final timer = prefs.getInt(_keyTimer);
    final image = prefs.getString(_keyImage);

    if (name == null || number == null || timer == null) {
      return null;
    }

    return {
      'name': name,
      'number': number,
      'image': image,
      'timer': timer,
    };
  }
}
