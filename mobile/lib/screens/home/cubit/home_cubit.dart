import "package:data/data.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._service) : super(const HomeState());

  final LocalNotificationService _service;

  Future<void> requestPushPermissions() async {
    await _service.requestPermissions();
  }
}

class HomeState {
  const HomeState();
}
