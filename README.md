# generic_json_serializable

Extend from [json_serializable](https://github.com/google/json_serializable.dart) to provide another way to solve the problem of serialization and deserialization of the generic.
Usually used in conjunction with [generic_api_generator](https://github.com/wenjunxiao/generic_api_generator.dart).

## Usage

 Add `dependencies` and `dev_dependencies`.
```yaml
dependencies:
  generic_json_annotation: any # use latest version

dev_dependencies:
  generic_json_serializable: any # use latest version
```

  Decorate the generic field with `GenericKey`, [api_result.dart](test/generic/api_result.dart).
```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:generic_json_annotation/generic_json_annotation.dart';

part 'api_result.g.dart';

@JsonSerializable()
@JsonSerializable()
class ApiResult<E, D> {
  @JsonKey(name: 'success')
  final bool success;
  @GenericKey(name: 'error')
  final E error;
  @GenericKey(name: 'data')
  final D data;

  ApiResult(this.success, this.error, this.data);
}
```

  Run code generation.
```bash
$ flutter pub run build_runner build
```

  Then the following code will be generated, [api_result.g.dart](test/generic/api_result.g.dart).
```dart
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
```

  Bind to class `ApiResult<E, D>` as follow
```dart
class ApiResult<E, D> {
  // ...
  factory ApiResult.fromJson(Map<String, dynamic> json,
          {Function fromJson1, Function fromJson2}) =>
      _$ApiResultFromJson<E, D>(json,
          fromJsonE: fromJson1, fromJsonD: fromJson2);

  Map<String, dynamic> toJson({Function toJson1, Function toJson2}) =>
      _$ApiResultToJson<E, D>(this, toJsonE: toJson1, toJsonD: toJson2);
}
```

> Why the parameter name in the generated function `ApiResultToJson`/`ApiResultToJson` is `fromJsonE`/`fromJsonD`/`toJsonE`/`toJsonD`,
But the parameter name in the functions `fromJson`/`toJson` is indeed `fromJson1`/`fromJson2`/`toJson1`/`toJson2`?  
Because, This is because in the current definition context, we can clearly know which field is pointed to by the letter `E`/`D`; but when used, as in the example below, we only have specific types, such as `User`/`String`, and there is no letter `E`/`D`, so we can only use the generic parameter order to determine which field. And fortunately, in the context of the current definition, we know how to associate the two representations.

  Use `fromJson`
```dart
final Map<String, dynamic> json = <String, dynamic>{
  'success': true,
  'error': 'error',
  'data': <String, dynamic>{'uid': 'uid', 'name': 'name'}
};
ApiResult<String, User>.fromJson(json, fromJson1: (v) => v, fromJson2: (v) => User.fromJson(v));
```
  Use `toJson`
```dart
ApiResult<String, User>(true, 'error', User('uid', 'name')).toJson(toJson1: (v) => v, toJson2: (v) => v.toJson());
```

  If the parameter is a basic type, you can ignore the conversion of the parameter,  but other types can not be ignored.
```dart
// fromJson
ApiResult<String, User>.fromJson(json,  fromJson2: (v) => User.fromJson(v));

// toJson
ApiResult<String, User>(true, 'error', User('uid', 'name')).toJson(toJson1: toJson2: (v) => v.toJson());
```
  If `generic_api_generator` is used to automatically generate code,
  this omission is unnecessary.
