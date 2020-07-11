import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:json_serializable/json_serializable.dart';
import 'package:json_serializable/type_helper.dart';
import 'package:generic_json_annotation/generic_json_annotation.dart';
import 'package:analyzer/dart/constant/value.dart';

const _genericKeyChecker = TypeChecker.fromRuntime(GenericKey);

DartObject _genericKeyAnnotation(FieldElement element) =>
    _genericKeyChecker.firstAnnotationOf(element) ??
    (element.getter == null
        ? null
        : _genericKeyChecker.firstAnnotationOf(element.getter));

bool hasGenericKeyAnnotation(FieldElement element) =>
    _genericKeyAnnotation(element) != null;

Builder genericJsonBuilder([BuilderOptions options]) {
  final config = JsonSerializable.fromJson(options.config);
  return SharedPartBuilder(
    [
      GenericSerializableGenerator(config: config),
      const JsonLiteralGenerator()
    ],
    'generic_json',
  );
}

class GenericHelper extends TypeHelper<TypeHelperContextWithConfig> {
  const GenericHelper();
  @override
  Object deserialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context) {
    if (targetType is! TypeParameterType) {
      return null;
    }
    var createFactory = context.config?.createFactory;
    if (!createFactory) {
      return null;
    }
    var fn = 'fromJson${targetType.element.name}';
    return '($fn == null ? $expression : $fn($expression)) as ${targetType.element.name}';
  }

  @override
  Object serialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context) {
    if (!_canSerialize(context.config, targetType)) {
      return null;
    }
    var fn = 'toJson${targetType.element.name}';
    return '$fn == null ? $expression : $fn($expression)';
  }
}

bool _canSerialize(JsonSerializable config, DartType type) {
  if (type is TypeParameterType) {
    final toJsonMethod = null;
    if (toJsonMethod != null) {
      return true;
    }
    if (config?.createToJson == true) {
      return true;
    }
  }
  return false;
}

class GenericSerializableGenerator extends JsonSerializableGenerator {
  static const _defaultHelpers = <TypeHelper>[
    BigIntHelper(),
    DateTimeHelper(),
    DurationHelper(),
    JsonHelper(),
    UriHelper(),
    GenericHelper(),
  ];
  const GenericSerializableGenerator({
    JsonSerializable config,
    List<TypeHelper> typeHelpers,
  }) : super(config: config, typeHelpers: typeHelpers ?? _defaultHelpers);

  @override
  Iterable<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    Iterable<String> itr =
        super.generateForAnnotatedElement(element, annotation, buildStep);
    if (itr.length > 0 &&
        element is ClassElement &&
        element.typeParameters.isNotEmpty &&
        element.fields
                .where((element) => _genericKeyChecker.hasAnnotationOf(element))
                .length >
            0) {
      return _fixArguments(itr, element);
    } else {
      return itr;
    }
  }

  Iterable<String> _fixArguments(
      Iterable<String> itr, ClassElement element) sync* {
    RegExp json = new RegExp(
        "(_\\\$${element.name}(FromJson|ToJson)\\s*<([^>]+)>\\s*\\([^)]*)");
    for (var value in itr) {
      yield value.replaceFirstMapped(json, (match) {
        final act = match.group(2).replaceAllMapped(
            RegExp(r"^(\w)"), (match) => match.group(1).toLowerCase());
        return match.group(1) +
            ', {' +
            match
                .group(3)
                .split(',')
                .map((e) => 'Function ' + act + e.trim())
                .join(',') +
            '}';
      });
    }
  }
}
