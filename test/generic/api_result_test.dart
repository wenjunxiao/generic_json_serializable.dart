import 'package:test/test.dart';
import './api_result.dart';
import './user.dart';

class ApiResultMatcher extends Matcher {
  final ApiResult<String, User> expected;
  ApiResultMatcher(this.expected);
  @override
  Description describe(Description description) {
    return description;
  }

  @override
  bool matches(desc, Map matchState) {
    if (desc is ApiResult<String, User>) {
      // 或者重写
      // class ApiResult {
      //   bool operator ==(o) => o is ApiResult && o.success == success && o.error == error && o.data == data;
      //   int get hashCode => hash3(success.hashCode, error.hashCode, data.hashCode);
      // }
      // class User {
      //   bool operator ==(o) => o is User && o.uid == uid && o.name == name;
      //   int get hashCode => hash2(uid.hashCode, name.hashCode);
      // }
      return desc.success == expected.success &&
          desc.error == expected.error &&
          desc.data.uid == expected.data.uid &&
          desc.data.name == expected.data.name;
    }
    return false;
  }
}

void main() {
  final Map<String, dynamic> json = <String, dynamic>{
    'success': true,
    'error': 'error',
    'data': <String, dynamic>{'uid': 'uid', 'name': 'name'}
  };
  final data = ApiResult<String, User>(true, 'error', User('uid', 'name'));
  group('toJson', () {
    test('specify all generic field convert', () {
      expect(data.toJson(toJson1: (v) => v, toJson2: (v) => v.toJson()), json);
    });
    test('ignore basic type field convert', () {
      expect(data.toJson(toJson2: (v) => v.toJson()), json);
    });
    test('cannot ignore all type field convert', () {
      expect(() => expect(data.toJson(), json), throwsA(isA<TestFailure>()));
    });
  });

  group('fromJson', () {
    test('specify all generic field convert', () {
      expect(
          ApiResult<String, User>.fromJson(json,
              fromJson1: (v) => v, fromJson2: (v) => User.fromJson(v)),
          ApiResultMatcher(data));
    });
    test('ignore basic type field convert', () {
      expect(
          ApiResult<String, User>.fromJson(json,
              fromJson2: (v) => User.fromJson(v)),
          ApiResultMatcher(data));
    });
    test('cannot ignore all type field convert', () {
      expect(() => ApiResult<String, User>.fromJson(json),
          throwsA(isA<CastError>()));
    });
  });
}
