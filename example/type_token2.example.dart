import 'package:type_token/type_token.dart';
import 'package:useful_extension/useful_extension.dart';
import 'package:analyzer/analyzer.dart';

typedef F1 = Function(int, [List<int>, bool]);

// Function()
// void Function(int)
// Function() Function()
// dynamic Function(double) Function(int, Function, int Function(bool))
main() {
  var s = 'void Function<T>(List<int>) Function<T>(bool, String Function<int, bool>(), bool)';

  var ps = 'Map<dynamic Function(), F>, String Function<int, bool>(), bool, void Function<T>(dynamic Function<E>(bool, int))';


  TypeToken2.parseString(s);
}

Iterable<String> splitSegment(String s) sync* {
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
