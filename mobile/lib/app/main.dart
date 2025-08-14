import "package:data/data.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:resident_live/app/init_app.dart";
import "package:resident_live/shared/lib/utils/app_error/app_error_widget.dart";
import "package:sentry_flutter/sentry_flutter.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (errorDetails) {
    return AppErrorWidget(
      key: Key(errorDetails.toString()),
      errorDetails: errorDetails,
      isDev: kDebugMode,
    );
  };
  SentryFlutter.init(
    (options) {
      options.debug = false;
      options.dsn = EnvHandler.sentryDSN;
      options.sendDefaultPii = true;
      options.experimental.replay.sessionSampleRate = 1.0;
      options.experimental.replay.onErrorSampleRate = 1.0;
      options.tracesSampleRate = 1.0;
      options.tracesSampler = (samplingContext) => 1.0;
    },
    appRunner: () async {
      final app = SentryWidget(child: await initApp());
      runApp(app);
    },
  );
}
