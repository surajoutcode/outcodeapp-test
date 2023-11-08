import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_data/user_data.dart';

part 'user_data_wrapper.g.dart';

@JsonSerializable()
class UserDataWrapper {
  @JsonKey(name: "data")
  final UserData user;
  UserDataWrapper(this.user);

  factory UserDataWrapper.fromJson(Map<String, dynamic> json) =>
      _$UserDataWrapperFromJson(json);
}
