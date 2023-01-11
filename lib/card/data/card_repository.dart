import 'package:allpass/card/data/card_dao.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

class CardRepository {
  late final CardDao _cardDao;

  CardRepository({CardDao? cardDao}) {
    _cardDao = cardDao ?? CardDao();
  }

  Future<CardBean> create(CardBean param) async {
    var key = await _cardDao.insert(param);
    param.uniqueKey = key;
    _assignColor(param);
    return param;
  }

  Future<CardBean?> findById(String id) async {
    var result = await _cardDao.findById(id);
    if (result != null) {
      _assignColor(result);
    }
    return result;
  }

  Future<List<CardBean>> requestAll() async {
    var result = await _cardDao.findAll();
    result.forEach((element) {
      _assignColor(element);
    });
    return result;
  }

  Future<int> deleteById(int key) async {
    return await _cardDao.deleteById(key);
  }

  Future<int> updateById(CardBean bean) async {
    return await _cardDao.updateById(bean);
  }

  Future<int> deleteAll() async {
    return await _cardDao.deleteContent();
  }

  Future<void> dropTable() async {
    await _cardDao.deleteTable();
  }

  void _assignColor(CardBean bean) {
    if (bean.gradientColor == null) {
      var gradient = getNextGradient();
      bean.color = getCenterColor(gradient.colors);
      bean.gradientColor = gradient;
    }
  }
}
