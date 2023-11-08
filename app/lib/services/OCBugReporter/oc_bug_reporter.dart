import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screenshot/screenshot.dart';

import '../../flavor_config.dart';
import 'oc_bug_reporter_screen.dart';

class OCBugReporterService {
  final ScreenshotController screenshotController = ScreenshotController();
  bool _hasLoggerOpened = false;
  static OCBugReporterService? _instance;

  GlobalKey<NavigatorState>? navigatorKey;
  OCBugReporterService._internal();

  Function(bool flag)? showsReporter;

  factory OCBugReporterService() {
    _instance ??= OCBugReporterService._internal();
    return _instance!;
  }

  setNavigatorKey(GlobalKey<NavigatorState>? key) {
    navigatorKey = key;
  }

  BuildContext? getContext() => navigatorKey?.currentState?.overlay?.context;
  openLogger() {
    screenshotController.capture().then((Uint8List? image) async {
      if (getContext() != null) {
        _openLogger(image);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  _openLogger(Uint8List? image) {
    if (_hasLoggerOpened) {
      return;
    }
    _hasLoggerOpened = true;
    showsReporter?.call(!_hasLoggerOpened);
    Navigator.push(
        getContext()!,
        OCBugReporterScreen.route(image, () {
          _hasLoggerOpened = false;
          showsReporter?.call(!_hasLoggerOpened);
        }));
  }

  createLog(Uint8List? image, String title, String description) async {
    String apiUrl =
        'https://api.clickup.com/api/v2/list/${FlavorConfig.clickUpListId()}/task';
    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] = FlavorConfig.clickUpApiKey();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      String brand = "";
      String device = "";
      String model = "";
      String deviceVersion = "";
      String tag = "";

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo =
            await DeviceInfoPlugin().androidInfo;
        brand = androidDeviceInfo.brand;
        device = androidDeviceInfo.device;
        model = androidDeviceInfo.model;
        deviceVersion = androidDeviceInfo.version.baseOS ?? "Unknown";
        tag = "Android";
      } else {
        IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
        brand = "iOS";
        device = "iOS";
        model = iosDeviceInfo.model ?? "Unknown";
        deviceVersion = iosDeviceInfo.systemVersion ?? "Unknown";
        tag = "iOS";
      }

      String detailedDescription =
          """$description\n\nAppInformation:\nApp Name: $appName\nPackage Name: $packageName\nApp Version: $version\nBuild Number: $buildNumber\n\nDevice Information:\nBrand: $brand\nDevice: $device\nModel: $model\nDevice Version:$deviceVersion""";
      Map<String, dynamic> data = {
        "name": title,
        "description": detailedDescription,
        "tags": [tag]
      };

      Response response = await dio.post(apiUrl, data: data);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        String id = responseData['id'];
        _uploadAttachement(image, id);
      } else {
        print('Task creation failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  _uploadAttachement(Uint8List? image, String taskId) {
    String apiUrl = 'https://api.clickup.com/api/v2/task/$taskId/attachment';
    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] = FlavorConfig.clickUpApiKey();
      FormData formData = FormData.fromMap({
        'attachment': MultipartFile.fromBytes(image!,
            filename: 'your_attachment_filename'),
      });

      dio.post(apiUrl, data: formData);
    } catch (e) {
      print('Error: $e');
    }
  }
}
