import 'dart:convert';

import 'package:github/common/bean/Event.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/db/sql_provider.dart';
import 'package:github/common/net/address.dart';
import 'package:github/common/net/data_result.dart';
import 'package:github/common/net/httpmanager.dart';
import 'package:github/common/redux/event_redux.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:redux/redux.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description EventDao 动态页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class EventDao {
  static getEventReceived(Store<WhgState> store, {page = 1}) async {
    User user = store.state.userInfo;
    if (user == null || user.login == null) {
      return null;
    }

    String userName = user.login;
    String url =
        Address.getEventReceived(userName) + Address.getPageParams("?", page);

    ReceivedEventDbProvider provider = new ReceivedEventDbProvider();

    List<Event> dbList = await provider.getEvents();
    if (dbList.length > 0) {
      store.dispatch(new RefreshEventAction(dbList));
    }

    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<Event> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return null;
      }

      await provider.insert(json.encode(data));

      for (int i = 0; i < data.length; i++) {
        list.add(Event.fromJson(data[i]));
      }
      if (page == 1) {
        store.dispatch(new RefreshEventAction(list));
      } else {
        store.dispatch(new LoadMoreEventAction(list));
      }
      return list;
    } else {
      return null;
    }
  }

  /**
   * 用户行为事件
   */
  static getEventDao(userName, {page = 0}) async {
    new UserEventDbProvider().open();

    String url = Address.getEvent(userName) + Address.getPageParams("?", page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<Event> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return null;
      }
      for (int i = 0; i < data.length; i++) {
        list.add(Event.fromJson(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return null;
    }
  }

  static clearEvent(Store store) {
    store.state.eventList.clear();
    store.dispatch(new RefreshEventAction([]));
  }
}
