import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'base/common_widgets/floating_bug_reporter/floating_bug_reporter.dart';
import 'base/common_widgets/no_internet_connection_view/no_internet_connection_view.dart';
import 'base/common_widgets/secure_overlay/app_switcher_protection.dart';
import 'features/authentication/bloc/authentication_bloc.dart';
import 'features/device_management/bloc/device_management_bloc.dart';
import 'features/login/login.dart';
import 'features/others/about_app_screen/app_information_view/bloc/app_version_info_view_bloc.dart';
import 'features/splash_screen.dart';
import 'flavor_config.dart';
import 'injector/injector.dart';
import 'services/OCBugReporter/oc_bug_reporter.dart';
import 'services/api_log_service.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double _drawerX = 0;
  double _drawerY = 0;
  double _screenWidth = 0;
  double _screenHeight = 0;
  final _navigatorKey = Injector.instance<ApiLogService>().navigationKey;
  NavigatorState? get _navigator => _navigatorKey?.currentState;
  late final AuthenticationBloc _bloc;

  bool _showBugReporter = true;

  @override
  void initState() {
    OCBugReporterService().setNavigatorKey(_navigatorKey);
    OCBugReporterService().showsReporter = (flag) {
      _showBugReporter = flag;
      setState(() {});
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _screenWidth = size.width;
        _screenHeight = size.height;
      });
    });

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _bloc = Injector.instance<AuthenticationBloc>();
    _bloc.add(AuthenticationCheckUserSessionEvent());
    super.initState();
  }

  _snapToCorner() {
    setState(() {
      if ((_drawerX < 0) || (_drawerX < _screenWidth / 2)) {
        _drawerX = 0;
      } else if ((_drawerX > _screenWidth - 80) ||
          (_drawerX > _screenWidth / 2)) {
        _drawerX = _screenWidth - 80;
      }
      if (_drawerY < 0) {
        _drawerY = 0;
      } else if (_drawerY > _screenHeight - 80) {
        _drawerY = _screenHeight - 80;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>.value(
          value: _bloc,
        ),
        BlocProvider<DeviceManagementBloc>.value(
            value: Injector.instance<DeviceManagementBloc>()),
        BlocProvider<AppVersionInfoViewBloc>.value(
            value: Injector.instance<AppVersionInfoViewBloc>()),
      ],
      child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'Lato',
            splashColor: Colors.transparent,
          ),
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            return AppSwitcherProtection(
              child: NoInternetConnectivityWrapper(
                child: Stack(
                  children: [
                    Screenshot(
                      controller: OCBugReporterService().screenshotController,
                      child:
                          BlocListener<AuthenticationBloc, AuthenticationState>(
                        bloc: _bloc,
                        listener: (context, state) {
                          if (state is AuthenticationAuthenticatedState) {
                            // navigate to your dashboard
                            // _navigator?.pushAndRemoveUntil(
                            //     UserDashboardScreen.route(), (route) => false);
                          } else if (state
                              is AuthenticationUnauthenticatedState) {
                            _navigator?.pushAndRemoveUntil(
                                LoginScreen.route(), (route) => false);
                          } else if (state is AuthenticationTokenExistState) {
                            // navigate to your dashboard
                            // _navigator?.pushAndRemoveUntil(
                            //     UserDashboardScreen.route(), (route) => false);
                          }
                        },
                        child: child!,
                      ),
                    ),
                    _bugReporterView()
                  ],
                ),
              ),
            );
          },
          onGenerateRoute: (settings) {
            return SplashPage.route();
          }),
    );
  }

  _bugReporterView() {
    return Visibility(
      visible: !FlavorConfig.isProduction() && _showBugReporter,
      child: Positioned(
        left: _drawerX,
        top: _drawerY,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _drawerX += details.delta.dx;
              _drawerY += details.delta.dy;
            });
          },
          onPanEnd: (details) {
            _snapToCorner();
          },
          child: const FloatingBugReporter(),
        ),
      ),
    );
  }
}
