import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'users_response_model.freezed.dart';
part 'users_response_model.g.dart';

@freezed
abstract class UsersResponseModel with _$UsersResponseModel {
  const factory UsersResponseModel({
    @Default(<UserModel>[]) List<UserModel> users,
    @Default(0) int total,
    @Default(0) int skip,
    @Default(0) int limit,
  }) = _UsersResponseModel;

  const UsersResponseModel._();

  factory UsersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UsersResponseModelFromJson(json);
}
