import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../base/utils/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: "/signup"),
        builder: (_) => const SignupScreen());
  }
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: AppColors.color848484,
        height: 100,
        width: 100,
      ),
    );
  }
}
