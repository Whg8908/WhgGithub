import 'package:json_annotation/json_annotation.dart';

part 'NotificationSubject.g.dart';

@JsonSerializable()
class NotificationSubject extends Object
    with _$NotificationSubjectSerializerMixin {
  String title;
  String url;
  String type;

  NotificationSubject(this.title, this.url, this.type);

  factory NotificationSubject.fromJson(Map<String, dynamic> json) =>
      _$NotificationSubjectFromJson(json);
}
