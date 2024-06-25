import 'package:hive_flutter/hive_flutter.dart';

class OwnerToken {
  static Future<void> save(String token) async {
    var box = await Hive.openBox('OwnerToken');
    box.put('OwnerToken', token);
  }

  static Future<String?> load() async {
    var box = await Hive.openBox('OwnerToken');

    final String? token = box.get('OwnerToken');
    if (token == null) {
      return 'NO_TOKEN';
    }
    return token;
  }

  static Future<void> delete() async {
    var box = await Hive.openBox('OwnerToken');
    box.delete('OwnerToken');
  }
}
