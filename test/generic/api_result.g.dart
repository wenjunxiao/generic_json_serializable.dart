// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_result.dart';

// **************************************************************************
// GenericSerializableGenerator
// **************************************************************************

ApiResult<E, D> _$ApiResultFromJson<E, D>(Map<String, dynamic> json,
    {Function fromJsonE, Function fromJsonD}) {
  return ApiResult<E, D>(
    json['success'] as bool,
    (fromJsonE == null ? json['error'] : fromJsonE(json['error'])) as E,
    (fromJsonD == null ? json['data'] : fromJsonD(json['data'])) as D,
  );
}

Map<String, dynamic> _$ApiResultToJson<E, D>(ApiResult<E, D> instance,
        {Function toJsonE, Function toJsonD}) =>
    <String, dynamic>{
      'success': instance.success,
      'error': toJsonE == null ? instance.error : toJsonE(instance.error),
      'data': toJsonD == null ? instance.data : toJsonD(instance.data),
    };
