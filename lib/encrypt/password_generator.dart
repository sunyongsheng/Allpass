import 'dart:math';

class PasswordGenerator {
  static var _capitalList = [
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'O',
    'K',
    'L',
    'M',
    'A',
    'B',
    'C',
    'X',
    'Y',
    'N',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'Z'
  ];

  static var _lowCaseList = [
    'a',
    'v',
    'w',
    'f',
    'g',
    'x',
    'm',
    'h',
    'i',
    'k',
    'l',
    'n',
    'b',
    'c',
    'd',
    'e',
    'o',
    'p',
    'r',
    'j',
    's',
    't',
    'u',
    'y',
    'q',
    'z'
  ];

  static var _numberList = ['1', '9', '0', '2', '5', '6', '3', '4', '7', '8'];

  static var _symbolList = ['!', '@', '*', '?', '#', '%', '~', '='];

  PasswordGenerator._();

  static String generate(
    int len, {
    bool cap = true,
    bool low = true,
    bool number = true,
    bool sym = true,
  }) {
    assert(cap || low || number || sym);

    List<String> list = [];
    if (cap) {
      list.addAll(_capitalList);
    }
    if (low) {
      list.addAll(_lowCaseList);
    }
    if (number) {
      list.addAll(_numberList);
    }
    if (sym) {
      list.addAll(_symbolList);
    }
    StringBuffer stringBuffer = StringBuffer();
    Random random = Random.secure();
    for (int i = 0; i < len; i++) {
      int index = random.nextInt(list.length);
      stringBuffer.write(list[index]);
    }
    return stringBuffer.toString();
  }
}
