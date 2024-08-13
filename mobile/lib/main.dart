import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resident_live/core/shared_state/shared_state_cubit.dart';
import 'package:resident_live/presentation/navigation/router.dart';
import 'package:resident_live/presentation/utils/theme.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/geolocator.service.dart';

final screenNavigatorKey = GlobalKey<NavigatorState>();
final shellKey = GlobalKey<NavigatorState>();

const String uniqueTaskName = "geofencingTask";

void main() async {
  RouterService.init(screenNavigatorKey, shellKey);
  GeolocationService.instance.initialize();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // HydratedBloc.storage.clear();

  runApp(const MyApp());

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SharedStateCubit(GeolocationService.instance),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: RouterService.instance.config,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
      ),
    );
  }
}
