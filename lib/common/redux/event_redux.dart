import 'package:redux/redux.dart';
import 'package:whg_github/common/bean/event_view_model.dart';

final EventReducer = combineReducers<List<EventViewModel>>([
  TypedReducer<List<EventViewModel>, RefreshEventAction>(_refresh),
  TypedReducer<List<EventViewModel>, LoadMoreEventAction>(_loadMore),
]);

//刷新
List<EventViewModel> _refresh(List<EventViewModel> list, action) {
  list.clear();
  if (action.list == null) {
    return list;
  } else {
    list.addAll(action.list);
    return list;
  }
}

//加载更多
List<EventViewModel> _loadMore(List<EventViewModel> list, action) {
  if (action.list != null) {
    list.addAll(action.list);
  }
  return list;
}

class RefreshEventAction {
  final List<EventViewModel> list;

  RefreshEventAction(this.list);
}

class LoadMoreEventAction {
  final List<EventViewModel> list;

  LoadMoreEventAction(this.list);
}
