import 'package:flutter/material.dart';

import '../../../flavor_config.dart';
import '../../constants/constants.dart';
import '../../utils/app_styles.dart';
import '../../utils/colors.dart';
import '../image_widgets/app_image_view.dart';

class SecureOverlay extends StatelessWidget {
  String appName = Constants.appName;
  SecureOverlay();

  @override
  Widget build(BuildContext context) {
    // Use a Container with a blur effect or a solid color to obscure the content.
    return Material(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppImageView(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.fill,
                  cornerRadius: 0,
                  placeholderHeight: MediaQuery.of(context).size.width * 0.8,
                  placeholderImage: FlavorConfig.appIconImage(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    appName,
                    style: AppStyles.boldLarge(color: AppColors.black),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
