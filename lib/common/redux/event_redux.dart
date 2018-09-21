import 'package:github/common/bean/Event.dart';
import 'package:redux/redux.dart';

final EventReducer = combineReducers<List<Event>>([
  TypedReducer<List<Event>, RefreshEventAction>(_refresh),
  TypedReducer<List<Event>, LoadMoreEventAction>(_loadMore),
]);

//刷新
List<Event> _refresh(List<Event> list, action) {
  list.clear();
  if (action.list == null) {
    return list;
  } else {
    list.addAll(action.list);
    return list;
  }
}

//加载更多
List<Event> _loadMore(List<Event> list, action) {
  if (action.list != null) {
    list.addAll(action.list);
  }
  return list;
}

class RefreshEventAction {
  final List<Event> list;

  RefreshEventAction(this.list);
}

class LoadMoreEventAction {
  final List<Event> list;

  LoadMoreEventAction(this.list);
}
