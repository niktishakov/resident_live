import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:resident_live/core/ai.logger.dart';
import 'package:resident_live/data/residence.model.dart';
import 'package:collection/collection.dart';

import '../../data/user.model.dart';
import '../../services/geolocator.service.dart';

class SharedStateCubit extends HydratedCubit<SharedStateState> {
  SharedStateCubit(
    this._locationService,
  ) : super(SharedStateState(user: UserModel.mock()));

  final GeolocationService _locationService;

  static final AiLogger _logger = AiLogger('SharedStateCubit');

  Future<void> initializeLocation() async {
    try {
      // Request permissions
      await _locationService.requestPermissions();

      // Initialize position stream
      _locationService.initialize();

      // Listen for position updates
      _locationService.positionStream?.listen(_getAddressFromLatLng);
    } catch (e) {
      _logger.error(e);
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      // Use a geocoding package to get the address (optional step)
      // For example, using geocoding package
      final coordinates = await GeocodingPlatform.instance
          ?.placemarkFromCoordinates(position.latitude, position.longitude);
      final addresses = coordinates ?? [];

      if (addresses.isNotEmpty) {
        final position = addresses.first;
        final countryResidence = getCountryResidence(state, position);

        emit(state.copyWith(
          currentPosition: position,
          user: state.user.copyWith(
            countryResidences: {
              ...state.user.countryResidences,
              countryResidence.isoCountryCode: countryResidence
            },
          ),
        ));
      }
    } catch (e) {
      _logger.error(e);
    }
  }

  void addResidency(ResidenceModel countryResidence) {
    emit(
      state.copyWith(
        user: state.user.copyWith(
          countryResidences: {
            ...state.user.countryResidences,
            countryResidence.isoCountryCode: countryResidence
          },
        ),
      ),
    );
  }

  void updateResidencies(Map<String, ResidenceModel> countryResidences) {
    emit(
      state.copyWith(
        user: state.user.copyWith(
          countryResidences: countryResidences,
        ),
      ),
    );
  }

  Future<void> refreshState() async {
    final position = await GeolocationService.instance.positionStream?.first;
    if (position == null) {
      return;
    }

    await _getAddressFromLatLng(position);
  }

  ResidenceModel getResidencyByName(String countryName) {
    final countryResidence = state.user.countryResidences.values
        .firstWhereOrNull((e) => e.countryName == countryName);

    if (countryResidence != null) {
      return countryResidence;
    }

    return ResidenceModel.initial(countryName, 'Unknown');
  }

  ResidenceModel getCountryResidence(
    SharedStateState currentState,
    Placemark country,
  ) {
    final countryResidence =
        currentState.user.countryResidences[country.isoCountryCode];
    if (countryResidence != null) {
      return countryResidence;
    }

    return ResidenceModel.initial(
      country.isoCountryCode ?? 'Unknown',
      country.country ?? 'Unknown',
    );
  }

  bool isCurrentResidence(String isoCountryCode) {
    return state.currentPosition?.isoCountryCode == isoCountryCode;
  }

  @override
  SharedStateState? fromJson(Map<String, dynamic> json) {
    return SharedStateState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SharedStateState state) {
    return state.toJson(true);
  }

  void removeResidence(String isoCountryCode) {
    final countryResidences = {
      ...state.user.countryResidences,
    };
    countryResidences.remove(isoCountryCode);

    emit(
      state.copyWith(
        user: state.user.copyWith(
          countryResidences: countryResidences,
        ),
      ),
    );
  }
}

class SharedStateState {
  SharedStateState({
    this.currentPosition,
    required this.user,
  });

  Placemark? currentPosition;
  UserModel user;

  SharedStateState copyWith({
    Placemark? currentPosition,
    UserModel? user,
  }) {
    return SharedStateState(
      currentPosition: currentPosition ?? this.currentPosition,
      user: user ?? this.user,
    );
  }

  factory SharedStateState.fromJson(Map<String, dynamic> json) {
    return SharedStateState(
      currentPosition: json['currentPosition'] == null
          ? null
          : Placemark.fromMap(json['currentPosition']),
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson([bool includePosition = false]) {
    return {
      if (includePosition) 'currentPosition': currentPosition?.toJson(),
      'user': user.toJson(),
    };
  }
}
