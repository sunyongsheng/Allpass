abstract class LetterIndexProvider {
  /// 按字母表顺序进行排序后，记录每个字母前面有多少元素的Map，符号或数字的key=#，value=0
  /// 例如{'#': 0, 'A': 5, 'C': 9} 代表第一个以数字或字母开头的元素索引为0，第一个为'A'
  /// 或'a'为首字母的元素索引为5，第一个以'C'或'c'为首字母的元素索引为9
  Map<String, int> get letterIndexMap;
}

final List<String> lettersWithoutHash = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
];

final List<String> letters = ['#']..addAll(lettersWithoutHash);