import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resident_live/app/navigation/screen_names.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../features/features.dart';
import '../generated/codegen_loader.g.dart';
import '../screens/onboarding/export.dart';
import '../screens/screens.dart';
import '../shared/shared.dart';
import 'navigation/get_routes.dart';
import 'package:easy_localization/easy_localization.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final shellKey = GlobalKey<NavigatorState>();

const String uniqueTaskName = "geofencingTask";
final supportedLocales = [
  Locale('en', 'US'),
  Locale('ru', 'RU')
]; // Add your supported locales
final fallbackLocale = Locale('en', 'US');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations', // Path to your translation files
      fallbackLocale: fallbackLocale,
      child: MaterialApp(
        home: PresplashScreen(),
      ),
    ),
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  await RouterService.init(
    navigatorKey: navigatorKey,
    routes: getRoutes(shellKey),
    initialLocation: ScreenNames.splash,
    observers: [
      CoreRouteObserver(),
      // OverlayStyleObserver(),
    ],
  );
  await VibrationService.init();
  await ShareService.init();
  GeolocationService.instance.initialize();
  AiLogger.initialize(isReleaseMode: kReleaseMode, env: null);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  HydratedBloc.storage.clear();

  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations', // Path to your translation files
      fallbackLocale: fallbackLocale,
      child: MyApp(),
    ),
  );

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

    return Builder(
      builder: (context) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => LanguageRepository(
                supportedLocales: supportedLocales,
                fallbackLocale: fallbackLocale,
              ),
            ),
          ],
          child: Builder(
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => OnboardingCubit()),
                  BlocProvider(
                      create: (_) =>
                          LocationCubit(GeolocationService.instance)),
                  BlocProvider(create: (_) => CountriesCubit()),
                  BlocProvider(create: (_) => UserCubit()),
                  BlocProvider(create: (_) => AuthCubit()),
                  BlocProvider(
                    create: (_) =>
                        LanguageCubit(find<LanguageRepository>(context)),
                  ),
                ],
                child: BlocBuilder<LanguageCubit, Locale>(
                  builder: (context, locale) {
                    return MaterialApp.router(
                        routerConfig: RouterService.instance.router,
                        debugShowCheckedModeBanner: false,
                        theme: darkTheme, // TODO: add light theme support
                        darkTheme: darkTheme,
                        localizationsDelegates: context.localizationDelegates,
                        supportedLocales: context.supportedLocales,
                        locale: locale,
                        builder: (context, child) {
                          setDarkOverlayStyle();
                          FToastBuilder();
                          return child!;
                        });
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
