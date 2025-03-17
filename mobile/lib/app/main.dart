import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/single_child_widget.dart';

import 'package:provider/provider.dart';

import '../features/features.dart';
import '../screens/screens.dart';
import '../shared/shared.dart';
import 'routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final shellKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(MaterialApp(home: PresplashScreen()));

  final envHolder = EnvHolder(Environment.prod);
  final secrets = await Secrets.create(envHolder);

  AiLogger.initialize();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  AiAnalytics.init(
    mixpanel: MixpanelService(secrets.mixpanelToken),
    environment: envHolder.value,
  );

  await RouterService.init(
    navigatorKey: navigatorKey,
    routes: getRoutes(shellKey),
    initialLocation: ScreenNames.splash,
    observers: [
      CoreRouteObserver(),
      AiAnalyticsObserver(AiAnalytics.instance),
    ],
  );

  final rlThemeProvider = RlThemeProvider(RlTheme());

  await VibrationService.init();
  await ShareService.init();
  await ToastService.init();
  GeolocationService.instance.initialize();
  final deviceInfoService = await DeviceInfoService.create();

  final workmanager = await WorkmanagerService.initialize();
  await workmanager.registerPeriodicTask();

  runApp(
    LocalizedApp(
      child: MyApp(
        providers: [
          BlocProvider(create: (_) => OnboardingCubit()),
          BlocProvider(
              create: (_) => LocationCubit(GeolocationService.instance),),
          BlocProvider(create: (_) => CountriesCubit()),
          BlocProvider(create: (_) => UserCubit()),
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(
            create: (_) => LanguageCubit(
              LanguageRepository(
                supportedLocales: kSupportedLocales,
                fallbackLocale: kFallbackLocale,
              ),
            ),
          ),
          ChangeNotifierProvider.value(value: rlThemeProvider),
          Provider.value(value: deviceInfoService),
        ],
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.providers});

  final List<SingleChildWidget> providers;

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
    return Builder(
      builder: (context) {
        return Builder(
          builder: (context) {
            FToastBuilder();

            return MultiBlocProvider(
              providers: widget.providers,
              child: BlocBuilder<LanguageCubit, Locale>(
                builder: (context, locale) {
                  return Listen<RlThemeProvider>(
                    builder: (context) {
                      return MaterialApp.router(
                        routerConfig: RouterService.instance.router,
                        debugShowCheckedModeBanner: false,
                        theme: context.rlTheme.data, // TODO: add light theme
                        darkTheme:
                            context.rlTheme.data, // TODO: add light theme
                        localizationsDelegates: context.localizationDelegates,
                        supportedLocales: context.supportedLocales,
                        locale: locale,
                        builder: (context, child) {
                          setDarkOverlayStyle();
                          FToastBuilder();
                          return child!;
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
