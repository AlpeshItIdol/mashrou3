import 'package:get_storage/get_storage.dart';

import 'storage_constants.dart';

class AppStorage {
  final _box = GetStorage();

  bool hasData(String key) => _box.hasData(key);

  void saveFCMToken(String fcmToken) {
    _box.write(StorageConstants.kFirebaseToken, fcmToken);
  }

  String getFCMToken() => _box.read(StorageConstants.kFirebaseToken) ?? "";

  /// Save userId
  void saveUserId(String userId) {
    _box.write(StorageConstants.kUserId, userId);
  }

  /// returns userId from session
  String get getUserId => _box.read(StorageConstants.kUserId) ?? "";

  /// True when user has userId stored in session.
  bool get isLogin => getUserId.isNotEmpty;

  Future<void> clearData() => _box.erase();

}
