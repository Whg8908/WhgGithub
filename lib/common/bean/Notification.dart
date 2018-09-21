import 'package:github/common/bean/NotificationSubject.dart';
import 'package:github/common/bean/Repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Notification.g.dart';

@JsonSerializable()
class Notification extends Object with _$NotificationSerializerMixin {
  String id;
  bool unread;
  String reason;
  @JsonKey(name: "updated_at")
  DateTime updateAt;
  @JsonKey(name: "last_read_at")
  DateTime lastReadAt;
  Repository repository;
  NotificationSubject subject;

  Notification(this.id, this.unread, this.reason, this.updateAt,
      this.lastReadAt, this.repository, this.subject);

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}
