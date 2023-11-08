import '../../../../services/local_storage_service/local_storage_service.dart';
import '../../../api/exceptions/custom_exception.dart';
import '../../../db/database_manager.dart';
import '../../../domain/entities/user_entity/user_entity.dart';

abstract class UserLocalDataSource {
  Future<UserEntity?> getUserDetails();
  Future<void> saveUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<String?> getCurrentUserId();
  Future<void> logoutUser();
  Future<List<UserEntity>> getUsers(int page, int size);
}

class UserLocalDataSourceImpl extends UserLocalDataSource {
  UserLocalDataSourceImpl(
      {required AppDatabaseManager appDatabaseManager,
      required LocalStorageService localStorageService})
      : _appDatabaseManager = appDatabaseManager,
        _localStorageService = localStorageService;

  late final AppDatabaseManager _appDatabaseManager;
  final LocalStorageService _localStorageService;

  @override
  Future<UserEntity?> getUserDetails() async {
    final collection = await _appDatabaseManager.userCollection;
    final userId = await _localStorageService.userId;
    if (userId == null) {
      throw CustomException.sessionExpired();
    }
    try {
      await collection.openBox();
      Map<String, dynamic> userJson = await collection.get(userId);
      final user = UserEntity.fromJson(userJson);
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    final collection = await _appDatabaseManager.userCollection;
    return collection.addUpdate(user.id, user);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final collection = await _appDatabaseManager.userCollection;
    return collection.addUpdate(user.id, user);
  }

  @override
  Future<String?> getCurrentUserId() async {
    return await _localStorageService.userId;
  }

  @override
  Future<void> logoutUser() async {
    await _appDatabaseManager.clearAllCache();
    return await _localStorageService.clearLocalCache();
  }

  @override
  Future<List<UserEntity>> getUsers(int page, int size) async {
    return [];
  }
}
