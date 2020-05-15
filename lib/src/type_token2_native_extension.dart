part of 'type_token2.dart';

extension _NativeExtension on TypeToken2 {
  bool get isInt => this == TypeToken2.ofInt();

  bool get isDouble => this == TypeToken2.ofDouble();

  bool get isString => this == TypeToken2.ofString();

  bool get isBool => this == TypeToken2.ofBool();

  bool get isList => this.typeName == 'List';

  bool get isSet => this.typeName == 'Set';

  bool get isMap => this.typeName == 'Map';

  bool get isFuture => this.typeName == 'Future';

  bool get isStream => this.typeName == 'Stream';

  bool get isDynamic => this.typeName == 'dynamic';

  bool get isVoid => this.typeName == 'void';

  bool get isPrimitive => [isInt, isDouble, isString, isBool].any((o) => o);

  bool get isNotPrimitive => !isPrimitive;

  bool get isNative => [
        isPrimitive,
        isList,
        isSet,
        isMap,
        isFuture,
        isStream,
        isDynamic,
      ].any((o) => o);

  Type toNativeType() {
    if (isInt) return int;
    if (isDouble) return double;
    if (isBool) return bool;
    if (isString) return String;
    if (isList) return List;
    if (isSet) return Set;
    if (isMap) return Map;
    if (isFuture) return Future;
    if (isStream) return Stream;
    if (isDynamic) return dynamic;
    throw 'This type token is not a native type: $fullTypeName';
  }
}
