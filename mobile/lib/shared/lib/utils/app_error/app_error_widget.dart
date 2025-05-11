// void main() {
//   // In dev mode, show error details
//   // In release builds, show a only custom error message
//   bool isDev = true;

//   ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
//     return AppErrorWidget(
//       errorDetails: errorDetails,
//       isDev: isDev,
//     );
//   };

//   runApp(MyApp());
// }

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/shared/lib/utils/app_error/constants.dart";
import "package:resident_live/shared/shared.dart";

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required Key key,
    required this.errorDetails,
    this.isDev = false,
  }) : super(key: key);

  final FlutterErrorDetails errorDetails;
  final bool isDev;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    final screenWidth = MediaQuery.of(context).size.width;
    final sizeS2 = screenWidth / 2;
    final sizeS30 = screenWidth / 11;
    final sizeS20 = screenWidth / 16;
    final sizeS10 = screenWidth / 32;
    final sizeS100 = screenWidth / 3.2;

    return Material(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: sizeS30),
          constraints: BoxConstraints(maxHeight: screenWidth / sizeS2),
          child: ListView(
            children: <Widget>[
              Container(
                height: sizeS20,
              ),
              SizedBox(
                height: sizeS100,
                width: sizeS100,
                child: AppAssetImage(
                  AppAssets.personCircleFill,
                  color: theme.iconPrimary,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                height: sizeS20,
              ),
              Text(
                "Something went wrong",
                style: theme.title32Semi,
                textAlign: TextAlign.center,
              ),
              Container(
                height: sizeS10,
              ),
              if (isDev)
                Text(
                  errorDetails.summary.toString(),
                  style: theme.body18.copyWith(
                    color: Colors.red,
                  ),
                ),
              Container(
                height: sizeS10,
              ),
              if (isDev)
                Text(
                  "$errorDetails",
                  style: theme.body12M.copyWith(
                    color: Colors.red,
                  ),
                ),
              PrimaryButton(
                onPressed: () {
                  context.goNamed(ScreenNames.splash);
                },
                label: Strings.restartApp,
              ),
              Container(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
