import 'package:json_annotation/json_annotation.dart';

part 'CommitStats.g.dart';

@JsonSerializable()
class CommitStats extends Object with _$CommitStatsSerializerMixin {
  int total;
  int additions;
  int deletions;

  CommitStats(this.total, this.additions, this.deletions);

  factory CommitStats.fromJson(Map<String, dynamic> json) =>
      _$CommitStatsFromJson(json);
}
