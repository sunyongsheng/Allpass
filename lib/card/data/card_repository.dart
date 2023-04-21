import 'package:allpass/card/data/card_data_source.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

class CardRepository {
  late final CardDataSource _localDataSource;

  CardRepository({CardDataSource? cardDao}) {
    _localDataSource = cardDao ?? CardDataSource();
  }

  Future<CardBean> create(CardBean param) async {
    var key = await _localDataSource.insert(param);
    param.uniqueKey = key;
    _assignColor(param);
    return param;
  }

  Future<CardBean?> findById(String id) async {
    var result = await _localDataSource.findById(id);
    if (result != null) {
      _assignColor(result);
    }
    return result;
  }

  Future<List<CardBean>> requestAll() async {
    var result = await _localDataSource.findAll();
    result.forEach((element) {
      _assignColor(element);
    });
    return result;
  }

  Future<int> deleteById(int key) async {
    return await _localDataSource.deleteById(key);
  }

  Future<int> updateById(CardBean bean) async {
    return await _localDataSource.updateById(bean);
  }

  Future<int> deleteAll() async {
    return await _localDataSource.deleteContent();
  }

  Future<void> dropTable() async {
    await _localDataSource.deleteTable();
  }

  void _assignColor(CardBean bean) {
    if (bean.gradientColor == null) {
      var gradient = getNextGradient();
      bean.color = getCenterColor(gradient.colors);
      bean.gradientColor = gradient;
    }
  }
}
