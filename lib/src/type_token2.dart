import 'package:useful_extension/useful_extension.dart';

part 'type_token2_native_extension.dart';

class TypeToken2 {
  bool _isFunction;

  // general
  String _typeName;
  List<TypeToken2> _typeParameters = [];

  // function
  TypeToken2 _funcReturnType;
  List<TypeToken2> _funcArgTypes = [];

  /// Return type name without type parameters.
  String get typeName => _typeName;

  /// Return only type parameters.
  List<TypeToken2> get typeParameters => _typeParameters;

  /// Return whether has type parameter.
  bool get hasTypeParameter => typeParameters.isNotEmpty;

  /// Return first type parameter, or null if not set.
  TypeToken2 get typeParameter => hasTypeParameter ? typeParameters.first : null;

  /// Return type name with type parameters.
  String get fullTypeName {
    if (hasTypeParameter) {
      typeParameters.forEach((t) {
        print('-------- $t');
      });
      return "$typeName<${typeParameters.map((token) => token.fullTypeName).join(", ")}>";
    } else {
      return typeName;
    }
  }

  /// Create a [TypeToken2] by type name and type parameters.
  TypeToken2.createByTypeName(String typeName, [List<TypeToken2> typeParameters = const []]) {
    _typeName = typeName;
    _typeParameters.addAll(typeParameters);
    _isFunction = false;
  }

  /// Create a [TypeToken2] by type and type parameters.
  TypeToken2.createByType(Type type, [List<TypeToken2> generics = const []]) : this.createByTypeName(type.toString(), generics);

  /// Create a [TypeToken2] of function.
  TypeToken2.createByFunction(TypeToken2 returnType, [List<TypeToken2> argTypes]) {
    _funcReturnType = returnType;
    _funcArgTypes.addAll(argTypes);
    _isFunction = true;
  }

  /// Parse a type to [TypeToken2], type can be [String], [Type] or [TypeToken2].
  factory TypeToken2.parse(dynamic anyType) {
    if (anyType == null) return TypeToken2.ofDynamic();
    if (anyType is String) return TypeToken2.parseString(anyType);
    if (anyType is Type) return TypeToken2.parseType(anyType);
    throw '$anyType can not parse to TypeToken.';
  }

  /// Parse any string to [TypeToken2], [fullString] can be a type name, type name with type parameters or a function.
  factory TypeToken2.parseString(String fullString) {
    if (_functionRegex.hasMatch(fullString)) {
      print('function');
      return _resolveFunction(fullString);
    } else if (_typeRegex.hasMatch(fullString)) {
      print('type');
      return _resolveType(fullString);
    }
    return null;
  }

  /// Parse a type to [TypeToken2].
  factory TypeToken2.parseType(Type type) => TypeToken2.parseString(type.toString());

  /// Get [TypeToken2] from instance.
  factory TypeToken2.fromInstance(dynamic instance) {
    return TypeToken2.createByType(instance?.runtimeType);
  }

  // ----------------------------- Primitive ---------------------------------

  factory TypeToken2.ofDynamic() => TypeToken2.createByType(dynamic);

  factory TypeToken2.ofInt() => TypeToken2.createByType(int);

  factory TypeToken2.ofString() => TypeToken2.createByType(String);

  factory TypeToken2.ofDouble() => TypeToken2.createByType(double);

  factory TypeToken2.ofBool() => TypeToken2.createByType(bool);

  factory TypeToken2.ofVoid() => TypeToken2.createByTypeName('void');

  // ----------------------------- Collection ---------------------------------

  // List

  static TypeToken2 ofListByToken(TypeToken2 componentType) => TypeToken2.createByType(List, [componentType]);

  static TypeToken2 ofListByType(Type componentType) => ofListByToken(TypeToken2.createByType(componentType));

  static TypeToken2 ofList<T>() => ofListByType(T);

  // Set

  static TypeToken2 ofSetByToken(TypeToken2 componentType) => TypeToken2.createByType(Set, [componentType]);

  static TypeToken2 ofSetByType(Type componentType) => ofSetByToken(TypeToken2.createByType(componentType));

  static TypeToken2 ofSet<T>() => ofSetByType(T);

  // Map

  static TypeToken2 ofMapByToken(TypeToken2 keyType, TypeToken2 valueType) => TypeToken2.createByType(Map, [keyType, valueType]);

  static TypeToken2 ofMapByType(Type keyType, Type valueType) =>
      ofMapByToken(TypeToken2.createByType(keyType), TypeToken2.createByType(valueType));

  static TypeToken2 ofMap<K, V>() => ofMapByType(K, V);

  // ------------------------------- Future --------------------------------------

  static TypeToken2 ofFutureByToken(TypeToken2 type) => TypeToken2.createByType(Future, [type]);

  static TypeToken2 ofFutureByType(Type type) => ofFutureByToken(TypeToken2.createByType(type));

  static TypeToken2 ofFuture<T>() => ofFutureByType(T);

  // -------------------------------- Stream ---------------------------------------

  static TypeToken2 ofStreamOrByToken(TypeToken2 type) => TypeToken2.createByType(Stream, [type]);

  static TypeToken2 ofStreamByType(Type type) => ofStreamOrByToken(TypeToken2.createByType(type));

  static TypeToken2 ofStream<T>() => ofStreamByType(T);

  // --------------------------------------------------------------------------------

  /// Get type parameter by index.
  TypeToken2 getTypeParameter(int index) {
    return _typeParameters.length > index ? _typeParameters[index] : null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TypeToken2 && runtimeType == other.runtimeType && _typeName == other._typeName &&
              _typeParameters == other._typeParameters;

  @override
  int get hashCode => _typeName.hashCode ^ _typeParameters.hashCode;

  @override
  String toString() {
    return 'TypeToken2{$fullTypeName}';
  }

  static bool isFunction(String fullTypeString) {
    if (fullTypeString == 'Function') return true;
    var firstStartBrace = _findFunctionFirstBrace(fullTypeString);
  }

  static int _findFunctionFirstBrace(String s) {
    var chars = s.split('').withIndex().map((iv) {
      switch (iv.value) {
        case ')':
          return -1;
        case '(':
          return 1;
        default:
          return 0;
      }
    }).toList();
    var sum = 0;
    for (var i = chars.length - 1; i >= 0; i--) {
      sum += chars[i];
      if (sum == 0) return i;
    }
    return -1;
  }
}

final String _functionPattern = r'(.+?) Function\((.*)\)';
final String _typePattern = '([a-zA-Z0-9_\$]+)(<(.+)>)?';
final RegExp _functionRegex = RegExp(_functionPattern);
final RegExp _typeRegex = RegExp(_typePattern);

TypeToken2 _resolveType(String fullTypeString) {
  var matcher = _typeRegex.firstMatch(fullTypeString);
  var typeName = matcher.group(1);
  var typeParametersString = matcher.group(3);
  var splitTypeParametersString = _splitTypeParameters(typeParametersString);
  var typeParameters = splitTypeParametersString.map((split) => TypeToken2.parseString(split)).toList();
  return TypeToken2.createByTypeName(typeName, typeParameters);
}

Iterable<String> _splitTypeParameters(String fullTypeParametersString) sync* {
  if (fullTypeParametersString == null || fullTypeParametersString.isEmpty) {
    yield* [];
  } else {
    var tmp = '';
    var output = true;
    for (var idx = 0; idx < fullTypeParametersString.length; idx++) {
      var s = fullTypeParametersString[idx];
      if (s == ',') {
        if (output) {
          yield tmp.trim();
          tmp = '';
        } else {
          tmp += s;
        }
      } else if (s == '<') {
        output = false;
        tmp += s;
      } else if (s == '>') {
        output = true;
        tmp += s;
      } else {
        tmp += s;
      }
    }
    yield tmp.trim();
  }
}


TypeToken2 _resolveFunction(String fullFunctionString) {
  var firstBraceIndex = _findFunctionFirstBrace(fullFunctionString);
  var paramsString = fullFunctionString.substring(firstBraceIndex + 1, fullFunctionString.length - 1);
  var functionIndex = firstBraceIndex - 'Function'.length;
  var functionString = fullFunctionString.substring(functionIndex);
  var returnString = fullFunctionString.substring(0, functionIndex - 1);
  var params = _splitSegment(paramsString);

  print("        ='$fullFunctionString'");
  print("params  ='$paramsString'");
  print("return  ='$returnString'");
  print(' ');
  print(params.join('\n'));
}

Iterable<String> _splitSegment(String s) sync* {
  var tmp = '';
  var flag1 = 0;
  var flag2 = 0;
  var list = s.split('').toList();
  for (var i = 0; i < list.length; i++) {
    var char = list[i];
    var acc = true;
    switch (char) {
      case ',':
        if (flag1 == 0 && flag2 == 0) {
          tmp = tmp.trim();
          yield tmp;
          tmp = '';
          acc = false;
        }
        break;
      case '(':
        flag1 += 1;
        break;
      case ')':
        flag1 -= 1;
        break;
      case '<':
        flag2 += 1;
        break;
      case '>':
        flag2 -= 1;
        break;
    }
    if (acc) tmp += char;
  }
  tmp = tmp.trim();
  if (tmp.isNotEmpty) yield tmp;
}
