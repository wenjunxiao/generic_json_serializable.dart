// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_result.dart';

// **************************************************************************
// GenericSerializableGenerator
// **************************************************************************

ApiResult<E, D> _$ApiResultFromJson<E, D>(Map<String, dynamic> json,
    {Function fromJsonE, Function fromJsonD}) {
  return ApiResult<E, D>(
    json['success'] as bool,
    json['error'] == null
        ? null
        : (fromJsonE == null ? json['error'] : fromJsonE(json['error'])) as E,
    json['data'] == null
        ? null
        : (fromJsonD == null ? json['data'] : fromJsonD(json['data'])) as D,
  );
}

Map<String, dynamic> _$ApiResultToJson<E, D>(ApiResult<E, D> instance,
        {Function toJsonE, Function toJsonD}) =>
    <String, dynamic>{
      'success': instance.success,
      'error': toJsonE == null ? instance.error : toJsonE(instance.error),
      'data': toJsonD == null ? instance.data : toJsonD(instance.data),
    };

ApiResults<T> _$ApiResultsFromJson<T>(Map<String, dynamic> json,
    {Function fromJsonT}) {
  return ApiResults<T>(
    json['success'] as bool,
    json['error'] as String,
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : (fromJsonT == null ? e : fromJsonT(e)) as T)
        ?.toList(),
  );
}

Map<String, dynamic> _$ApiResultsToJson<T>(ApiResults<T> instance,
        {Function toJsonT}) =>
    <String, dynamic>{
      'error': instance.error,
      'success': instance.success,
      'data':
          instance.data?.map((e) => toJsonT == null ? e : toJsonT(e))?.toList(),
    };
