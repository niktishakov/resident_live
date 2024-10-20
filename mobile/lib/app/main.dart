import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resident_live/app/navigation/screen_names.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/features.dart';
import '../screens/onboarding/export.dart';
import '../screens/screens.dart';
import '../shared/shared.dart';
import 'navigation/get_routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final shellKey = GlobalKey<NavigatorState>();

const String uniqueTaskName = "geofencingTask";

void main() async {
  runApp(MaterialApp(home: PresplashScreen()));

  await RouterService.init(
    navigatorKey: navigatorKey,
    routes: getRoutes(shellKey),
    initialLocation: ScreenNames.splash,
  );
  await VibrationService.init();
  await ShareService.init();
  GeolocationService.instance.initialize();
  AiLogger.initialize(isReleaseMode: kReleaseMode, env: null);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // HydratedBloc.storage.clear();

  runApp(const MyApp());

  // TODO: Add background task
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  // Workmanager().registerPeriodicTask("1", uniqueTaskName,
  //     frequency: Duration(minutes: 1)); // Adjust frequency as n
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case uniqueTaskName:
        await updateCurrentAddress();
        break;
    }
    return Future.value(true);
  });
}

/// TODO: Add background task to update current user address and update numbers
Future<void> updateCurrentAddress() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final sharedAddress = sharedPrefs.getString('current_address');
  if (sharedAddress != null) {
    // sharedPrefs.setString('current_address', );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    FToast().init(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnboardingCubit()),
        BlocProvider(create: (_) => LocationCubit(GeolocationService.instance)),
        BlocProvider(create: (_) => CountriesCubit()),
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MaterialApp.router(
          routerConfig: RouterService.instance.router,
          debugShowCheckedModeBanner: false,
          theme: darkTheme, // TODO: add light theme support
          darkTheme: darkTheme,
          builder: (context, child) {
            // setSystemOverlayStyle();
            setDarkOverlayStyle();
            FToastBuilder();
            return child!;
          }),
    );
  }
}
