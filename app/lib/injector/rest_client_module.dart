import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/api/clients/rest_client/auth_api_client/auth_api_client.dart';
import '../core/api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../core/api/clients/rest_client/interceptors/app_header_interceptor.dart';
import '../core/api/clients/rest_client/interceptors/basic_auth_header_interceptor.dart';
import '../core/api/clients/rest_client/interceptors/bearer_token_interceptor.dart';
import '../core/api/clients/rest_client/interceptors/content_type_interceptor.dart';
import '../core/api/clients/rest_client/interceptors/null_response_interceptor.dart';
import '../core/api/clients/rest_client/interceptors/refresh_token_interceptor.dart';
import '../flavor_config.dart';
import '../services/api_log_service.dart';
import 'injector.dart';

class RestClientModule {
  RestClientModule._();

  static void init() {
    final injector = Injector.instance;
    const String dioInstance = "dioInstace";

    injector.registerLazySingleton<Dio>(() {
      final Dio basicDio = Dio(BaseOptions(baseUrl: FlavorConfig.baseUrl()));
      basicDio.interceptors.clear();

      if (!kReleaseMode) {
        basicDio.interceptors.add(LogInterceptor(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            request: true));
        basicDio.interceptors
            .add(Injector.instance<ApiLogService>().aliceInterceptor);
      }

      basicDio.interceptors.add(BasicAuthHeaderInterceptor());
      basicDio.interceptors.add(AppHeaderInterceptor());
      basicDio.interceptors.add(NullResponseInterceptor());
      basicDio.interceptors.add(ContentTypeInterceptor());

      return basicDio;
    }, instanceName: dioInstance);

    injector.registerFactory<AuthApiClient>(
        () => AuthApiClient(injector(instanceName: dioInstance)));

    const String authorizedInstance = "authorizedInstance";
    injector.registerLazySingleton<Dio>(() {
      final Dio dio = Dio(BaseOptions(baseUrl: FlavorConfig.baseUrl()));
      dio.interceptors.clear();
      if (!kReleaseMode) {
        dio.interceptors.add(LogInterceptor(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            request: true));
        dio.interceptors
            .add(Injector.instance<ApiLogService>().aliceInterceptor);
      }

      dio.interceptors.add(NullResponseInterceptor());
      dio.interceptors.add(ContentTypeInterceptor());
      dio.interceptors.add(AppHeaderInterceptor());
      dio.interceptors.add(BearerTokenInterceptor(localDataSource: injector()));

      return dio;
    }, instanceName: authorizedInstance);
    injector.registerFactory<AuthorizedApiClient>(
        () => AuthorizedApiClient(injector(instanceName: authorizedInstance)));
  }

  static void injectRefreshTokenInterceptor() {
    final injector = Injector.instance;
    final dio = injector.get<Dio>(instanceName: 'authorizedInstance');
    dio.interceptors.add(RefreshTokenInterceptor(
        remoteDataSource: injector(), localDataSource: injector()));
  }
}
