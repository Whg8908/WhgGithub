import 'package:github/common/bean/User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PushEventCommit.g.dart';

@JsonSerializable()
class PushEventCommit extends Object with _$PushEventCommitSerializerMixin {
  String sha;
  User author;
  String message;
  bool distinct;
  String url;

  PushEventCommit(
    this.sha,
    this.author,
    this.message,
    this.distinct,
    this.url,
  );

  factory PushEventCommit.fromJson(Map<String, dynamic> json) =>
      _$PushEventCommitFromJson(json);
}
