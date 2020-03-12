import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
class ProfileSetState {
  final bool isPhotoEmpty;
  final bool isNameEmpty;
  final bool isAgeEmpty;
  final bool isGenderEmpty;
  final bool isInterestedGenderEmpty;
  final bool isLocationEmpty;
  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;

  bool get isFormValid =>
      isPhotoEmpty &&
      isNameEmpty &&
      isAgeEmpty &&
      isGenderEmpty &&
      isInterestedGenderEmpty;

  ProfileSetState({
    @required this.isPhotoEmpty,
    @required this.isNameEmpty,
    @required this.isAgeEmpty,
    @required this.isGenderEmpty,
    @required this.isInterestedGenderEmpty,
    @required this.isLocationEmpty,
    @required this.isFailure,
    @required this.isSubmitting,
    @required this.isSuccess,
  });

  factory ProfileSetState.empty() {
    return ProfileSetState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedGenderEmpty: false,
      isLocationEmpty: false,
    );
  }
  factory ProfileSetState.loading() {
    return ProfileSetState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: false,
      isSubmitting: true,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedGenderEmpty: false,
      isLocationEmpty: false,
    );
  }
  factory ProfileSetState.failure() {
    return ProfileSetState(
      isPhotoEmpty: false,
      isFailure: true,
      isSuccess: false,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedGenderEmpty: false,
      isLocationEmpty: false,
    );
  }
  factory ProfileSetState.success() {
    return ProfileSetState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: true,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedGenderEmpty: false,
      isLocationEmpty: false,
    );
  }

  ProfileSetState update({
    bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isGenderEmpty,
    bool isInterestedGenderEmpty,
    bool isLocationEmpty,
  }) {
    return copyWith(
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isPhotoEmpty: isPhotoEmpty,
      isNameEmpty: isNameEmpty,
      isAgeEmpty: isAgeEmpty,
      isGenderEmpty: isGenderEmpty,
      isInterestedGenderEmpty: isInterestedGenderEmpty,
      isLocationEmpty: isLocationEmpty,
    );
  }

  ProfileSetState copyWith({
    bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isGenderEmpty,
    bool isInterestedGenderEmpty,
    bool isLocationEmpty,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return ProfileSetState(
      isPhotoEmpty: isPhotoEmpty ?? this.isPhotoEmpty,
      isNameEmpty: isNameEmpty ?? this.isNameEmpty,
      isLocationEmpty: isLocationEmpty ?? this.isLocationEmpty,
      isInterestedGenderEmpty:
          isInterestedGenderEmpty ?? this.isInterestedGenderEmpty,
      isGenderEmpty: isGenderEmpty ?? this.isGenderEmpty,
      isAgeEmpty: isAgeEmpty ?? this.isAgeEmpty,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
