// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tree_map_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TreeMapState {
  bool get isLoading => throw _privateConstructorUsedError;
  LatLng? get currentPosition => throw _privateConstructorUsedError;
  Set<Marker> get markers => throw _privateConstructorUsedError;
  List<TreeModel> get myTrees => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of TreeMapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TreeMapStateCopyWith<TreeMapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TreeMapStateCopyWith<$Res> {
  factory $TreeMapStateCopyWith(
          TreeMapState value, $Res Function(TreeMapState) then) =
      _$TreeMapStateCopyWithImpl<$Res, TreeMapState>;
  @useResult
  $Res call(
      {bool isLoading,
      LatLng? currentPosition,
      Set<Marker> markers,
      List<TreeModel> myTrees,
      String? errorMessage});
}

/// @nodoc
class _$TreeMapStateCopyWithImpl<$Res, $Val extends TreeMapState>
    implements $TreeMapStateCopyWith<$Res> {
  _$TreeMapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TreeMapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? currentPosition = freezed,
    Object? markers = null,
    Object? myTrees = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPosition: freezed == currentPosition
          ? _value.currentPosition
          : currentPosition // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      markers: null == markers
          ? _value.markers
          : markers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      myTrees: null == myTrees
          ? _value.myTrees
          : myTrees // ignore: cast_nullable_to_non_nullable
              as List<TreeModel>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TreeMapStateImplCopyWith<$Res>
    implements $TreeMapStateCopyWith<$Res> {
  factory _$$TreeMapStateImplCopyWith(
          _$TreeMapStateImpl value, $Res Function(_$TreeMapStateImpl) then) =
      __$$TreeMapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      LatLng? currentPosition,
      Set<Marker> markers,
      List<TreeModel> myTrees,
      String? errorMessage});
}

/// @nodoc
class __$$TreeMapStateImplCopyWithImpl<$Res>
    extends _$TreeMapStateCopyWithImpl<$Res, _$TreeMapStateImpl>
    implements _$$TreeMapStateImplCopyWith<$Res> {
  __$$TreeMapStateImplCopyWithImpl(
      _$TreeMapStateImpl _value, $Res Function(_$TreeMapStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TreeMapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? currentPosition = freezed,
    Object? markers = null,
    Object? myTrees = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$TreeMapStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPosition: freezed == currentPosition
          ? _value.currentPosition
          : currentPosition // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      markers: null == markers
          ? _value._markers
          : markers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      myTrees: null == myTrees
          ? _value._myTrees
          : myTrees // ignore: cast_nullable_to_non_nullable
              as List<TreeModel>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TreeMapStateImpl implements _TreeMapState {
  const _$TreeMapStateImpl(
      {this.isLoading = true,
      this.currentPosition,
      final Set<Marker> markers = const {},
      final List<TreeModel> myTrees = const [],
      this.errorMessage})
      : _markers = markers,
        _myTrees = myTrees;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final LatLng? currentPosition;
  final Set<Marker> _markers;
  @override
  @JsonKey()
  Set<Marker> get markers {
    if (_markers is EqualUnmodifiableSetView) return _markers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_markers);
  }

  final List<TreeModel> _myTrees;
  @override
  @JsonKey()
  List<TreeModel> get myTrees {
    if (_myTrees is EqualUnmodifiableListView) return _myTrees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myTrees);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TreeMapState(isLoading: $isLoading, currentPosition: $currentPosition, markers: $markers, myTrees: $myTrees, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TreeMapStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.currentPosition, currentPosition) ||
                other.currentPosition == currentPosition) &&
            const DeepCollectionEquality().equals(other._markers, _markers) &&
            const DeepCollectionEquality().equals(other._myTrees, _myTrees) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      currentPosition,
      const DeepCollectionEquality().hash(_markers),
      const DeepCollectionEquality().hash(_myTrees),
      errorMessage);

  /// Create a copy of TreeMapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TreeMapStateImplCopyWith<_$TreeMapStateImpl> get copyWith =>
      __$$TreeMapStateImplCopyWithImpl<_$TreeMapStateImpl>(this, _$identity);
}

abstract class _TreeMapState implements TreeMapState {
  const factory _TreeMapState(
      {final bool isLoading,
      final LatLng? currentPosition,
      final Set<Marker> markers,
      final List<TreeModel> myTrees,
      final String? errorMessage}) = _$TreeMapStateImpl;

  @override
  bool get isLoading;
  @override
  LatLng? get currentPosition;
  @override
  Set<Marker> get markers;
  @override
  List<TreeModel> get myTrees;
  @override
  String? get errorMessage;

  /// Create a copy of TreeMapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TreeMapStateImplCopyWith<_$TreeMapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
