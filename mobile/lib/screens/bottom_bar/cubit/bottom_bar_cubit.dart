import "package:freezed_annotation/freezed_annotation.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";

part "bottom_bar_cubit.freezed.dart";
part "bottom_bar_cubit.g.dart";

class BottomBarCubit extends Cubit<BottomBarState> {
  BottomBarCubit() : super(BottomBarState.initial());

  static const _duration = Duration(seconds: 5);

  Future<void> delayedShowBadge() async {
    await Future.delayed(_duration);
    emit(state.copyWith(showBadge: true));
  }
}

@freezed
class BottomBarState with _$BottomBarState {
  const factory BottomBarState({required bool showBadge}) = _BottomBarState;

  factory BottomBarState.initial() => const BottomBarState(
        showBadge: false,
      );

  factory BottomBarState.fromJson(Map<String, dynamic> json) => _$BottomBarStateFromJson(json);
}
