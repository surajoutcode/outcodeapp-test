import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../flavor_config.dart';
import '../../../services/OCBugReporter/oc_bug_reporter.dart';
import '../image_widgets/app_image_view.dart';

class FloatingBugReporter extends StatefulWidget {
  const FloatingBugReporter({super.key});

  @override
  State<FloatingBugReporter> createState() => _FloatingBugReporterState();
}

class _FloatingBugReporterState extends State<FloatingBugReporter> {
  @override
  void initState() {
    super.initState();
  }

  _createLog() {
    OCBugReporterService().openLogger();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        _createLog();
      },
      child: Container(
        width: 80,
        height: 80, // Adjust the width as needed
        color: Colors.transparent,
        child: AppImageView(
          placeholderHeight: 80,
          cornerRadius: 10,
          placeholderImage: FlavorConfig.appIconImage(),
        ),
      ),
    );
  }
}
