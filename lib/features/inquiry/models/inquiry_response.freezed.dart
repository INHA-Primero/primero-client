// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inquiry_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InquiryResponse _$InquiryResponseFromJson(Map<String, dynamic> json) {
  return _InquiryResponse.fromJson(json);
}

/// @nodoc
mixin _$InquiryResponse {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get writer => throw _privateConstructorUsedError;
  List<AnswerResponse> get answers => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get lastModifiedAt => throw _privateConstructorUsedError;

  /// Serializes this InquiryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InquiryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InquiryResponseCopyWith<InquiryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InquiryResponseCopyWith<$Res> {
  factory $InquiryResponseCopyWith(
          InquiryResponse value, $Res Function(InquiryResponse) then) =
      _$InquiryResponseCopyWithImpl<$Res, InquiryResponse>;
  @useResult
  $Res call(
      {int id,
      String title,
      String content,
      String status,
      String writer,
      List<AnswerResponse> answers,
      String createdAt,
      String lastModifiedAt});
}

/// @nodoc
class _$InquiryResponseCopyWithImpl<$Res, $Val extends InquiryResponse>
    implements $InquiryResponseCopyWith<$Res> {
  _$InquiryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InquiryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? status = null,
    Object? writer = null,
    Object? answers = null,
    Object? createdAt = null,
    Object? lastModifiedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      writer: null == writer
          ? _value.writer
          : writer // ignore: cast_nullable_to_non_nullable
              as String,
      answers: null == answers
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<AnswerResponse>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      lastModifiedAt: null == lastModifiedAt
          ? _value.lastModifiedAt
          : lastModifiedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InquiryResponseImplCopyWith<$Res>
    implements $InquiryResponseCopyWith<$Res> {
  factory _$$InquiryResponseImplCopyWith(_$InquiryResponseImpl value,
          $Res Function(_$InquiryResponseImpl) then) =
      __$$InquiryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String content,
      String status,
      String writer,
      List<AnswerResponse> answers,
      String createdAt,
      String lastModifiedAt});
}

/// @nodoc
class __$$InquiryResponseImplCopyWithImpl<$Res>
    extends _$InquiryResponseCopyWithImpl<$Res, _$InquiryResponseImpl>
    implements _$$InquiryResponseImplCopyWith<$Res> {
  __$$InquiryResponseImplCopyWithImpl(
      _$InquiryResponseImpl _value, $Res Function(_$InquiryResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of InquiryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? status = null,
    Object? writer = null,
    Object? answers = null,
    Object? createdAt = null,
    Object? lastModifiedAt = null,
  }) {
    return _then(_$InquiryResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      writer: null == writer
          ? _value.writer
          : writer // ignore: cast_nullable_to_non_nullable
              as String,
      answers: null == answers
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<AnswerResponse>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      lastModifiedAt: null == lastModifiedAt
          ? _value.lastModifiedAt
          : lastModifiedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InquiryResponseImpl implements _InquiryResponse {
  const _$InquiryResponseImpl(
      {required this.id,
      required this.title,
      required this.content,
      required this.status,
      required this.writer,
      required final List<AnswerResponse> answers,
      required this.createdAt,
      required this.lastModifiedAt})
      : _answers = answers;

  factory _$InquiryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InquiryResponseImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String content;
  @override
  final String status;
  @override
  final String writer;
  final List<AnswerResponse> _answers;
  @override
  List<AnswerResponse> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  final String createdAt;
  @override
  final String lastModifiedAt;

  @override
  String toString() {
    return 'InquiryResponse(id: $id, title: $title, content: $content, status: $status, writer: $writer, answers: $answers, createdAt: $createdAt, lastModifiedAt: $lastModifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InquiryResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.writer, writer) || other.writer == writer) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastModifiedAt, lastModifiedAt) ||
                other.lastModifiedAt == lastModifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      content,
      status,
      writer,
      const DeepCollectionEquality().hash(_answers),
      createdAt,
      lastModifiedAt);

  /// Create a copy of InquiryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InquiryResponseImplCopyWith<_$InquiryResponseImpl> get copyWith =>
      __$$InquiryResponseImplCopyWithImpl<_$InquiryResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InquiryResponseImplToJson(
      this,
    );
  }
}

abstract class _InquiryResponse implements InquiryResponse {
  const factory _InquiryResponse(
      {required final int id,
      required final String title,
      required final String content,
      required final String status,
      required final String writer,
      required final List<AnswerResponse> answers,
      required final String createdAt,
      required final String lastModifiedAt}) = _$InquiryResponseImpl;

  factory _InquiryResponse.fromJson(Map<String, dynamic> json) =
      _$InquiryResponseImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get content;
  @override
  String get status;
  @override
  String get writer;
  @override
  List<AnswerResponse> get answers;
  @override
  String get createdAt;
  @override
  String get lastModifiedAt;

  /// Create a copy of InquiryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InquiryResponseImplCopyWith<_$InquiryResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnswerResponse _$AnswerResponseFromJson(Map<String, dynamic> json) {
  return _AnswerResponse.fromJson(json);
}

/// @nodoc
mixin _$AnswerResponse {
  int get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get lastModifiedAt => throw _privateConstructorUsedError;

  /// Serializes this AnswerResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnswerResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnswerResponseCopyWith<AnswerResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerResponseCopyWith<$Res> {
  factory $AnswerResponseCopyWith(
          AnswerResponse value, $Res Function(AnswerResponse) then) =
      _$AnswerResponseCopyWithImpl<$Res, AnswerResponse>;
  @useResult
  $Res call({int id, String content, String createdAt, String lastModifiedAt});
}

/// @nodoc
class _$AnswerResponseCopyWithImpl<$Res, $Val extends AnswerResponse>
    implements $AnswerResponseCopyWith<$Res> {
  _$AnswerResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnswerResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = null,
    Object? lastModifiedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      lastModifiedAt: null == lastModifiedAt
          ? _value.lastModifiedAt
          : lastModifiedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnswerResponseImplCopyWith<$Res>
    implements $AnswerResponseCopyWith<$Res> {
  factory _$$AnswerResponseImplCopyWith(_$AnswerResponseImpl value,
          $Res Function(_$AnswerResponseImpl) then) =
      __$$AnswerResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String content, String createdAt, String lastModifiedAt});
}

/// @nodoc
class __$$AnswerResponseImplCopyWithImpl<$Res>
    extends _$AnswerResponseCopyWithImpl<$Res, _$AnswerResponseImpl>
    implements _$$AnswerResponseImplCopyWith<$Res> {
  __$$AnswerResponseImplCopyWithImpl(
      _$AnswerResponseImpl _value, $Res Function(_$AnswerResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnswerResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = null,
    Object? lastModifiedAt = null,
  }) {
    return _then(_$AnswerResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      lastModifiedAt: null == lastModifiedAt
          ? _value.lastModifiedAt
          : lastModifiedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerResponseImpl implements _AnswerResponse {
  const _$AnswerResponseImpl(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.lastModifiedAt});

  factory _$AnswerResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerResponseImplFromJson(json);

  @override
  final int id;
  @override
  final String content;
  @override
  final String createdAt;
  @override
  final String lastModifiedAt;

  @override
  String toString() {
    return 'AnswerResponse(id: $id, content: $content, createdAt: $createdAt, lastModifiedAt: $lastModifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastModifiedAt, lastModifiedAt) ||
                other.lastModifiedAt == lastModifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, createdAt, lastModifiedAt);

  /// Create a copy of AnswerResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerResponseImplCopyWith<_$AnswerResponseImpl> get copyWith =>
      __$$AnswerResponseImplCopyWithImpl<_$AnswerResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerResponseImplToJson(
      this,
    );
  }
}

abstract class _AnswerResponse implements AnswerResponse {
  const factory _AnswerResponse(
      {required final int id,
      required final String content,
      required final String createdAt,
      required final String lastModifiedAt}) = _$AnswerResponseImpl;

  factory _AnswerResponse.fromJson(Map<String, dynamic> json) =
      _$AnswerResponseImpl.fromJson;

  @override
  int get id;
  @override
  String get content;
  @override
  String get createdAt;
  @override
  String get lastModifiedAt;

  /// Create a copy of AnswerResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerResponseImplCopyWith<_$AnswerResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
