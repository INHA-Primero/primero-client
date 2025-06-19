// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CharacterInfoModel _$CharacterInfoModelFromJson(Map<String, dynamic> json) {
  return _CharacterInfoModel.fromJson(json);
}

/// @nodoc
mixin _$CharacterInfoModel {
// 🔴 [수정] swagger.json에 명시된 필드명과 타입, 기본값을 정확히 일치시킵니다.
// 불필요한 characterId, createdAt, lastModifiedAt 필드를 삭제합니다.
  @JsonKey(name: 'exp', defaultValue: 0)
  int get exp => throw _privateConstructorUsedError;
  @JsonKey(name: 'wateringChance', defaultValue: 0)
  int get wateringChance => throw _privateConstructorUsedError;
  @JsonKey(name: 'nickname', defaultValue: '새싹')
  String get nickname => throw _privateConstructorUsedError;

  /// Serializes this CharacterInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CharacterInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterInfoModelCopyWith<CharacterInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterInfoModelCopyWith<$Res> {
  factory $CharacterInfoModelCopyWith(
          CharacterInfoModel value, $Res Function(CharacterInfoModel) then) =
      _$CharacterInfoModelCopyWithImpl<$Res, CharacterInfoModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'exp', defaultValue: 0) int exp,
      @JsonKey(name: 'wateringChance', defaultValue: 0) int wateringChance,
      @JsonKey(name: 'nickname', defaultValue: '새싹') String nickname});
}

/// @nodoc
class _$CharacterInfoModelCopyWithImpl<$Res, $Val extends CharacterInfoModel>
    implements $CharacterInfoModelCopyWith<$Res> {
  _$CharacterInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exp = null,
    Object? wateringChance = null,
    Object? nickname = null,
  }) {
    return _then(_value.copyWith(
      exp: null == exp
          ? _value.exp
          : exp // ignore: cast_nullable_to_non_nullable
              as int,
      wateringChance: null == wateringChance
          ? _value.wateringChance
          : wateringChance // ignore: cast_nullable_to_non_nullable
              as int,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CharacterInfoModelImplCopyWith<$Res>
    implements $CharacterInfoModelCopyWith<$Res> {
  factory _$$CharacterInfoModelImplCopyWith(_$CharacterInfoModelImpl value,
          $Res Function(_$CharacterInfoModelImpl) then) =
      __$$CharacterInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'exp', defaultValue: 0) int exp,
      @JsonKey(name: 'wateringChance', defaultValue: 0) int wateringChance,
      @JsonKey(name: 'nickname', defaultValue: '새싹') String nickname});
}

/// @nodoc
class __$$CharacterInfoModelImplCopyWithImpl<$Res>
    extends _$CharacterInfoModelCopyWithImpl<$Res, _$CharacterInfoModelImpl>
    implements _$$CharacterInfoModelImplCopyWith<$Res> {
  __$$CharacterInfoModelImplCopyWithImpl(_$CharacterInfoModelImpl _value,
      $Res Function(_$CharacterInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CharacterInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exp = null,
    Object? wateringChance = null,
    Object? nickname = null,
  }) {
    return _then(_$CharacterInfoModelImpl(
      exp: null == exp
          ? _value.exp
          : exp // ignore: cast_nullable_to_non_nullable
              as int,
      wateringChance: null == wateringChance
          ? _value.wateringChance
          : wateringChance // ignore: cast_nullable_to_non_nullable
              as int,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterInfoModelImpl implements _CharacterInfoModel {
  const _$CharacterInfoModelImpl(
      {@JsonKey(name: 'exp', defaultValue: 0) this.exp = 0,
      @JsonKey(name: 'wateringChance', defaultValue: 0) this.wateringChance = 0,
      @JsonKey(name: 'nickname', defaultValue: '새싹') required this.nickname});

  factory _$CharacterInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterInfoModelImplFromJson(json);

// 🔴 [수정] swagger.json에 명시된 필드명과 타입, 기본값을 정확히 일치시킵니다.
// 불필요한 characterId, createdAt, lastModifiedAt 필드를 삭제합니다.
  @override
  @JsonKey(name: 'exp', defaultValue: 0)
  final int exp;
  @override
  @JsonKey(name: 'wateringChance', defaultValue: 0)
  final int wateringChance;
  @override
  @JsonKey(name: 'nickname', defaultValue: '새싹')
  final String nickname;

  @override
  String toString() {
    return 'CharacterInfoModel(exp: $exp, wateringChance: $wateringChance, nickname: $nickname)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterInfoModelImpl &&
            (identical(other.exp, exp) || other.exp == exp) &&
            (identical(other.wateringChance, wateringChance) ||
                other.wateringChance == wateringChance) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, exp, wateringChance, nickname);

  /// Create a copy of CharacterInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterInfoModelImplCopyWith<_$CharacterInfoModelImpl> get copyWith =>
      __$$CharacterInfoModelImplCopyWithImpl<_$CharacterInfoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterInfoModelImplToJson(
      this,
    );
  }
}

abstract class _CharacterInfoModel implements CharacterInfoModel {
  const factory _CharacterInfoModel(
      {@JsonKey(name: 'exp', defaultValue: 0) final int exp,
      @JsonKey(name: 'wateringChance', defaultValue: 0)
      final int wateringChance,
      @JsonKey(name: 'nickname', defaultValue: '새싹')
      required final String nickname}) = _$CharacterInfoModelImpl;

  factory _CharacterInfoModel.fromJson(Map<String, dynamic> json) =
      _$CharacterInfoModelImpl.fromJson;

// 🔴 [수정] swagger.json에 명시된 필드명과 타입, 기본값을 정확히 일치시킵니다.
// 불필요한 characterId, createdAt, lastModifiedAt 필드를 삭제합니다.
  @override
  @JsonKey(name: 'exp', defaultValue: 0)
  int get exp;
  @override
  @JsonKey(name: 'wateringChance', defaultValue: 0)
  int get wateringChance;
  @override
  @JsonKey(name: 'nickname', defaultValue: '새싹')
  String get nickname;

  /// Create a copy of CharacterInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterInfoModelImplCopyWith<_$CharacterInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
