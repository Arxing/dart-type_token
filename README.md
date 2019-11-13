![](https://img.shields.io/badge/language-dart-orange.svg)
![](https://img.shields.io/badge/pub-v1.0.4-blue.svg)

`type_token` extend on dart `Type` for more helpful functions, like more easier way to determine 
what type it is, free transforms between `Type` and `TypeToken` and easily resolve generic type.

## Usage

#### Instance

There are 4 ways to get instance of `TypeToken`.
```dart
main(){
  TypeToken token;
  token = TypeToken.of(int); // int
  token = TypeToken.ofInt(); // int
  token = TypeToken.parse(10); // int
  token = TypeToken.ofName("int"); // int
}
```

#### Types

after got a instance, you can determine what type it is.
```dart
main(){
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
}
```

### Transforms

`TypeToken` can transform to native type, but it will throw error if it is not a native type.
```dart
main(){
  Type nativeType = token.nativeType;  
}
```

### Generic types

`TypeToken` support very easy way for resolving generic types.
```dart
main(){
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
}
```

### toString()

```dart
main(){
  // to string
  token.typeName; // without generic type
  token.fullTypeName; // with full generic type
  token.toString(); // same with fullTypeName
}
```



