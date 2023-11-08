import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../flavor_config.dart';
import '../../constants/constants.dart';
import '../../utils/app_styles.dart';
import '../../utils/colors.dart';
import '../image_widgets/app_image_view.dart';

class NoInternetConnectivityWrapper extends StatefulWidget {
  final Widget child;

  NoInternetConnectivityWrapper({required this.child});

  @override
  _NoInternetConnectivityWrapperState createState() =>
      _NoInternetConnectivityWrapperState();
}

class _NoInternetConnectivityWrapperState
    extends State<NoInternetConnectivityWrapper> {
  late StreamSubscription<ConnectivityResult> subscription;
  bool hasInternet = true;
  @override
  void initState() {
    _setInitialValues();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      Future.delayed(const Duration(seconds: 1), () {
        _setInitialValues();
      });
    });
    super.initState();
  }

  _setInitialValues() async {
    hasInternet =
        (await (Connectivity().checkConnectivity())) != ConnectivityResult.none;
    setState(() {});
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.child,
          Visibility(
              visible:
                  !hasInternet && Constants.showsInternetConnectivitySheild,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              )),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              bottom: (hasInternet && Constants.showsInternetConnectivitySheild)
                  ? -300
                  : 0,
              height: 300,
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                alignment: Alignment.bottomCenter,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppImageView(
                      placeholderHeight: 150,
                      placeholderImage: FlavorConfig.appIconImage(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "No Internet Connection",
                        style: AppStyles.boldExtraLarge(),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
