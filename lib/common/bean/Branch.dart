import 'package:json_annotation/json_annotation.dart';

part 'Branch.g.dart';

@JsonSerializable()
class Branch extends Object with _$BranchSerializerMixin {
  String name;
  String tarballUrl;
  @JsonKey(name: "zipball_url")
  String zipballUrl;
  @JsonKey(name: "tarball_url")
  bool isBranch = true;

  Branch(this.name, this.isBranch, this.tarballUrl, this.zipballUrl);

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}
