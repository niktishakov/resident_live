import "package:data/data.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._pushNotificationService) : super(const HomeState());

  final PushNotificationService _pushNotificationService;

  Future<void> requestPushPermissions() async {
    await _pushNotificationService.requestPermissions();
  }
}

class HomeState {
  const HomeState();
}
