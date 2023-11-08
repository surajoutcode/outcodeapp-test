import 'package:freezed_annotation/freezed_annotation.dart';

import 'outh_token_data.dart';

part 'oauth_token_wrapper_data.g.dart';

@JsonSerializable()
class OauthTokenWrapperData {
  final OauthTokenData data;

  OauthTokenWrapperData(this.data);

  factory OauthTokenWrapperData.fromJson(Map<String, dynamic> json) =>
      _$OauthTokenWrapperDataFromJson(json);
  Map<String, dynamic> toJson() => _$OauthTokenWrapperDataToJson(this);
}
