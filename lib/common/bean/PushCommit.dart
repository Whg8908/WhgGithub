import 'package:github/common/bean/CommitFile.dart';
import 'package:github/common/bean/CommitGitInfo.dart';
import 'package:github/common/bean/CommitStats.dart';
import 'package:github/common/bean/RepoCommit.dart';
import 'package:github/common/bean/User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PushCommit.g.dart';

@JsonSerializable()
class PushCommit extends Object with _$PushCommitSerializerMixin {
  List<CommitFile> files;

  CommitStats stats;

  String sha;
  String url;
  @JsonKey(name: "html_url")
  String htmlUrl;
  @JsonKey(name: "comments_url")
  String commentsUrl;

  CommitGitInfo commit;
  User author;
  User committer;
  List<RepoCommit> parents;

  PushCommit(
    this.files,
    this.stats,
    this.sha,
    this.url,
    this.htmlUrl,
    this.commentsUrl,
    this.commit,
    this.author,
    this.committer,
    this.parents,
  );

  factory PushCommit.fromJson(Map<String, dynamic> json) =>
      _$PushCommitFromJson(json);
}
