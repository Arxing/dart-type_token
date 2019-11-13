import 'package:type_token/type_token.dart';

main() {
  TypeToken token;

  // ways to get a instance of TypeToken
  token = TypeToken.of(int); // int
  token = TypeToken.ofInt(); // int
  token = TypeToken.parse(10); // int
  token = TypeToken.ofName("int"); // int

  // get instance of TypeToken with generic
  Type listType = <int>[].runtimeType;
  token = TypeToken.of(listType); // List<int>
  token = TypeToken.ofList<int>(); // List<int>
  token = TypeToken.parse([1, 2, 3]); // List<int>
  token = TypeToken.ofName("List", [TypeToken.ofInt()]); // List<int>
  token = TypeToken.ofName2("List", [int]); // List<int>
  token = TypeToken.ofFullName("List<int>"); // List<int>

  // determine what type is
  token.isInt; // int
  token.isDouble; // double
  token.isString; // string
  token.isBool; // bool
  token.isList; // list
  token.isMap; // map
  token.isDynamic; // dynamic
  token.isVoid; // void
  token.isPrimitive; // int, double, bool and string
  token.isNotPrimitive; // is not primitive
  token.isNativeType; // int, double, bool, string, list and map

  // parse to native type
  // only native type can parse, or throw error
  Type nativeType = token.nativeType;

  // generics
  // get all generic types
  token = TypeToken.ofMapByType(int, String); // Map<int, String>
  token.generics; // [int, String]

  // nested generic type
  TypeToken genericToken;
  token = TypeToken.ofListByToken(TypeToken.ofList<int>()); // List<List<int>>
  genericToken = token.generics[0].generics[0]; // int
  genericToken = token.firstGeneric.firstGeneric; // int
  genericToken = token[0][0]; //int

  // to string
  token.typeName; // without generic type
  token.fullTypeName; // with full generic type
  token.toString(); // same with fullTypeName
}
