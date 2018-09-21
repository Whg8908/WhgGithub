import 'package:json_annotation/json_annotation.dart';

part 'License.g.dart';

@JsonSerializable()
class License extends Object with _$LicenseSerializerMixin {
  String name;

  License(this.name);

  factory License.fromJson(Map<String, dynamic> json) =>
      _$LicenseFromJson(json);
}
