import '../core/data/data_sources/auth_data_sources/auth_local_datasource.dart';
import '../core/data/data_sources/auth_data_sources/auth_remote_datasource.dart';
import '../core/data/data_sources/device_data_sources/device_local_data_source.dart';
import '../core/data/data_sources/device_data_sources/device_remote_data_source.dart';
import '../core/data/data_sources/push_notification_data_sources/push_notification_remote_data_source.dart';
import '../core/data/data_sources/user_data_sources/user_local_datasource.dart';
import '../core/data/data_sources/user_data_sources/user_remote_datasource.dart';
import 'injector.dart';

class DataSourceModule {
  DataSourceModule._();

  static void init() {
    final injector = Injector.instance;

    injector.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(authApiClient: injector()),
    );

    injector.registerFactory<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(localStorageService: injector()),
    );

    injector.registerFactory<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(
          appDatabaseManager: injector(), localStorageService: injector()),
    );

    injector.registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(
        userApiClient: injector(),
      ),
    );

    injector.registerFactory<DeviceRemoteDataSource>(
      () => DeviceRemoteDataSourceImpl(userApiClient: injector()),
    );

    injector.registerFactory<DeviceLocalDataSource>(
      () => DeviceLocalDataSourceImpl(localStorageService: injector()),
    );

    injector.registerFactory<PushNotificationRemoteDataSource>(
      () => PushNotificationRemoteDataSourceImpl(apiClient: injector()),
    );
  }
}
