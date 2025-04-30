import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:path_provider/path_provider.dart";
import "package:provider/provider.dart";
import "package:provider/single_child_widget.dart";
import "package:resident_live/app/routes.dart";
import "package:resident_live/features/features.dart";
import "package:resident_live/features/language/domain/constants.dart";
import "package:resident_live/features/language/presentation/cubit/language_cubit.dart";
import "package:resident_live/generated/l10n/l10n.dart";
import "package:resident_live/screens/screens.dart";
import "package:resident_live/shared/shared.dart";

final navigatorKey = GlobalKey<NavigatorState>();
final shellKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AiLogger.initialize();
  runApp(MaterialApp(home: PresplashScreen()));

  final envHolder = EnvHolder(Environment.prod);
  final secrets = await Secrets.create(envHolder);

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

  final deviceInfoService = await DeviceInfoService.create();

  await WorkmanagerService.initialize();

  runApp(
    MyApp(
      providers: [
        BlocProvider(create: (_) => OnboardingCubit()),
        BlocProvider(
          create: (_) => LocationCubit(GeolocationService.instance),
        ),
        BlocProvider(create: (_) => CountriesCubit()),
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(
          create: (_) => LanguageCubit(
            supportedLocales: kSupportedLocales,
            fallbackLocale: kFallbackLocale,
          ),
        ),
        ChangeNotifierProvider.value(value: rlThemeProvider),
        Provider.value(value: deviceInfoService),
      ],
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({required this.providers, super.key});

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
              child: BlocBuilder<LanguageCubit, LanguageState>(
                builder: (context, state) {
                  return Listen<RlThemeProvider>(
                    builder: (context) {
                      return MaterialApp.router(
                        routerConfig: RouterService.instance.router,
                        debugShowCheckedModeBanner: false,
                        theme: context.rlTheme.data,
                        darkTheme: context.rlTheme.data,
                        localizationsDelegates: const [
                          S.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        supportedLocales: S.delegate.supportedLocales,
                        locale: state.locale,
                        localeResolutionCallback: (locale, supportedLocales) {
                          if (locale != null) {
                            for (final supportedLocale in supportedLocales) {
                              if (supportedLocale.languageCode ==
                                  locale.languageCode) {
                                return supportedLocale;
                              }
                            }
                          }
                          return kFallbackLocale;
                        },
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
