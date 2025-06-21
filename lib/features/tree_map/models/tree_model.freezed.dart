// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tree_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TreeModel _$TreeModelFromJson(Map<String, dynamic> json) {
  return _TreeModel.fromJson(json);
}

/// @nodoc
mixin _$TreeModel {
  int get id => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError;
  String? get pinColor => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  /// Serializes this TreeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TreeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TreeModelCopyWith<TreeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TreeModelCopyWith<$Res> {
  factory $TreeModelCopyWith(TreeModel value, $Res Function(TreeModel) then) =
      _$TreeModelCopyWithImpl<$Res, TreeModel>;
  @useResult
  $Res call(
      {int id,
      String? photoPath,
      String? pinColor,
      double latitude,
      double longitude});
}

/// @nodoc
class _$TreeModelCopyWithImpl<$Res, $Val extends TreeModel>
    implements $TreeModelCopyWith<$Res> {
  _$TreeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TreeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? photoPath = freezed,
    Object? pinColor = freezed,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      pinColor: freezed == pinColor
          ? _value.pinColor
          : pinColor // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TreeModelImplCopyWith<$Res>
    implements $TreeModelCopyWith<$Res> {
  factory _$$TreeModelImplCopyWith(
          _$TreeModelImpl value, $Res Function(_$TreeModelImpl) then) =
      __$$TreeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? photoPath,
      String? pinColor,
      double latitude,
      double longitude});
}

/// @nodoc
class __$$TreeModelImplCopyWithImpl<$Res>
    extends _$TreeModelCopyWithImpl<$Res, _$TreeModelImpl>
    implements _$$TreeModelImplCopyWith<$Res> {
  __$$TreeModelImplCopyWithImpl(
      _$TreeModelImpl _value, $Res Function(_$TreeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TreeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? photoPath = freezed,
    Object? pinColor = freezed,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$TreeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      pinColor: freezed == pinColor
          ? _value.pinColor
          : pinColor // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TreeModelImpl implements _TreeModel {
  const _$TreeModelImpl(
      {required this.id,
      this.photoPath,
      this.pinColor,
      required this.latitude,
      required this.longitude});

  factory _$TreeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TreeModelImplFromJson(json);

  @override
  final int id;
  @override
  final String? photoPath;
  @override
  final String? pinColor;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'TreeModel(id: $id, photoPath: $photoPath, pinColor: $pinColor, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TreeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            (identical(other.pinColor, pinColor) ||
                other.pinColor == pinColor) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, photoPath, pinColor, latitude, longitude);

  /// Create a copy of TreeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TreeModelImplCopyWith<_$TreeModelImpl> get copyWith =>
      __$$TreeModelImplCopyWithImpl<_$TreeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TreeModelImplToJson(
      this,
    );
  }
}

abstract class _TreeModel implements TreeModel {
  const factory _TreeModel(
      {required final int id,
      final String? photoPath,
      final String? pinColor,
      required final double latitude,
      required final double longitude}) = _$TreeModelImpl;

  factory _TreeModel.fromJson(Map<String, dynamic> json) =
      _$TreeModelImpl.fromJson;

  @override
  int get id;
  @override
  String? get photoPath;
  @override
  String? get pinColor;
  @override
  double get latitude;
  @override
  double get longitude;

  /// Create a copy of TreeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TreeModelImplCopyWith<_$TreeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
