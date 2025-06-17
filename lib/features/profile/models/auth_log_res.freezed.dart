// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_log_res.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthLogRes _$AuthLogResFromJson(Map<String, dynamic> json) {
  return _AuthLogRes.fromJson(json);
}

/// @nodoc
mixin _$AuthLogRes {
  String get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;

  /// Serializes this AuthLogRes to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthLogRes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthLogResCopyWith<AuthLogRes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthLogResCopyWith<$Res> {
  factory $AuthLogResCopyWith(
          AuthLogRes value, $Res Function(AuthLogRes) then) =
      _$AuthLogResCopyWithImpl<$Res, AuthLogRes>;
  @useResult
  $Res call(
      {String date,
      String time,
      String location,
      bool success,
      String? imagePath});
}

/// @nodoc
class _$AuthLogResCopyWithImpl<$Res, $Val extends AuthLogRes>
    implements $AuthLogResCopyWith<$Res> {
  _$AuthLogResCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthLogRes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? time = null,
    Object? location = null,
    Object? success = null,
    Object? imagePath = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthLogResImplCopyWith<$Res>
    implements $AuthLogResCopyWith<$Res> {
  factory _$$AuthLogResImplCopyWith(
          _$AuthLogResImpl value, $Res Function(_$AuthLogResImpl) then) =
      __$$AuthLogResImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      String time,
      String location,
      bool success,
      String? imagePath});
}

/// @nodoc
class __$$AuthLogResImplCopyWithImpl<$Res>
    extends _$AuthLogResCopyWithImpl<$Res, _$AuthLogResImpl>
    implements _$$AuthLogResImplCopyWith<$Res> {
  __$$AuthLogResImplCopyWithImpl(
      _$AuthLogResImpl _value, $Res Function(_$AuthLogResImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthLogRes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? time = null,
    Object? location = null,
    Object? success = null,
    Object? imagePath = freezed,
  }) {
    return _then(_$AuthLogResImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthLogResImpl implements _AuthLogRes {
  const _$AuthLogResImpl(
      {required this.date,
      required this.time,
      required this.location,
      required this.success,
      this.imagePath});

  factory _$AuthLogResImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthLogResImplFromJson(json);

  @override
  final String date;
  @override
  final String time;
  @override
  final String location;
  @override
  final bool success;
  @override
  final String? imagePath;

  @override
  String toString() {
    return 'AuthLogRes(date: $date, time: $time, location: $location, success: $success, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthLogResImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, time, location, success, imagePath);

  /// Create a copy of AuthLogRes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthLogResImplCopyWith<_$AuthLogResImpl> get copyWith =>
      __$$AuthLogResImplCopyWithImpl<_$AuthLogResImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthLogResImplToJson(
      this,
    );
  }
}

abstract class _AuthLogRes implements AuthLogRes {
  const factory _AuthLogRes(
      {required final String date,
      required final String time,
      required final String location,
      required final bool success,
      final String? imagePath}) = _$AuthLogResImpl;

  factory _AuthLogRes.fromJson(Map<String, dynamic> json) =
      _$AuthLogResImpl.fromJson;

  @override
  String get date;
  @override
  String get time;
  @override
  String get location;
  @override
  bool get success;
  @override
  String? get imagePath;

  /// Create a copy of AuthLogRes
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthLogResImplCopyWith<_$AuthLogResImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
