import 'package:json_annotation/json_annotation.dart';
import 'package:generic_json_annotation/generic_json_annotation.dart';

part 'api_result.g.dart';

@JsonSerializable()
class ApiResult<E, D> {
  @JsonKey(name: 'success')
  final bool success;
  @GenericKey(name: 'error')
  final E error;
  @GenericKey(name: 'data')
  final D data;

  ApiResult(this.success, this.error, this.data);

  factory ApiResult.fromJson(Map<String, dynamic> json,
          {Function fromJson1, Function fromJson2}) =>
      _$ApiResultFromJson<E, D>(json,
          fromJsonE: fromJson1, fromJsonD: fromJson2);

  Map<String, dynamic> toJson({Function toJson1, Function toJson2}) =>
      _$ApiResultToJson<E, D>(this, toJsonE: toJson1, toJsonD: toJson2);
}
