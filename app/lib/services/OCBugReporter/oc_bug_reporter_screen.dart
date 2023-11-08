import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base/common_widgets/buttons/app_button.dart';
import '../../base/common_widgets/buttons/app_button_state.dart';
import '../../base/common_widgets/buttons/decorators/primary_button_decorator.dart';
import '../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../base/common_widgets/text_fields/app_textfield.dart';
import '../../base/utils/colors.dart';
import '../../base/utils/utilities.dart';
import 'oc_bug_reporter.dart';

class OCBugReporterScreen extends StatefulWidget {
  final Uint8List? image;
  final Function? onBugReporterClosed;
  const OCBugReporterScreen({this.image, this.onBugReporterClosed, super.key});

  @override
  State<OCBugReporterScreen> createState() => _OCBugReporterScreenState();

  static Route<void> route(Uint8List? image, Function? onBugReporterClosed) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: "/ocbugreporter"),
        builder: (_) => OCBugReporterScreen(
              image: image,
              onBugReporterClosed: onBugReporterClosed,
            ));
  }
}

class _OCBugReporterScreenState extends State<OCBugReporterScreen> {
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "OC Bug Reporter",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              widget.onBugReporterClosed?.call();
            },
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            const SizedBox(
              height: 16,
            ),
            widget.image == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.memory(
                          widget.image!,
                          width: 150,
                          height: 250,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 16,
            ),
            AppTextField.textField(
                borderColor: Colors.grey,
                hint: "Title",
                backgroundColor: AppColors.transparent,
                validator: () => null,
                textColor: Colors.black,
                controller: _titleTextController,
                keyboardType: TextInputType.text,
                isPasswordField: false,
                isObsecured: false,
                hasError: false),
            const SizedBox(
              height: 16,
            ),
            AppTextField.textField(
                borderColor: Colors.grey,
                hint: "Description",
                maxLines: 10,
                backgroundColor: AppColors.transparent,
                validator: () => null,
                textColor: Colors.black,
                controller: _descriptionTextController,
                keyboardType: TextInputType.text,
                isPasswordField: false,
                isObsecured: false,
                hasError: false),
            const SizedBox(
              height: 16,
            ),
            AppButton(
                title: "Send",
                button: PrimaryButtonDecorator(),
                appButtonState: AppButtonState.enabled,
                onClick: _onSubmitButtonClick),
            const SizedBox(
              height: 25,
            ),
          ]),
        ),
      ),
    );
  }

  _onSubmitButtonClick() {
    if (_titleTextController.text.isEmpty ||
        _descriptionTextController.text.isEmpty) {
      Utilities.showSnackBar(
          context, "Title and description are required", SnackbarStyle.error);
      return;
    }

    OCBugReporterService().createLog(widget.image, _titleTextController.text,
        _descriptionTextController.text);
    Navigator.pop(context);
    widget.onBugReporterClosed?.call();
  }
}
