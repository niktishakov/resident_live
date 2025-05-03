import "dart:async";

import "package:flutter/material.dart";
import "package:resident_live/app/app.dart";
import "package:resident_live/shared/lib/utils/environment/env_handler.dart";
import "package:sentry_flutter/sentry_flutter.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SentryFlutter.init(
    (options) {
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
