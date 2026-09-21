import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/user/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class AddressModel with _$AddressModel {
  const factory AddressModel({
    @Default('') String address,
    @Default('') String city,
    @Default('') String state,
    @Default('') String country,
  }) = _AddressModel;

  const AddressModel._();

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  UserAddress toEntity() => UserAddress(
        address: address,
        city: city,
        state: state,
        country: country,
      );
}

@freezed
abstract class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    @Default('') String name,
    @Default('') String title,
    @Default('') String department,
  }) = _CompanyModel;

  const CompanyModel._();

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  UserCompany toEntity() => UserCompany(
        name: name,
        title: title,
        department: department,
      );
}

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String username,
    @Default('') String email,
    @Default('') String phone,
    int? age,
    @Default('') String gender,
    @Default('') String birthDate,
    @Default('') String image,
    double? height,
    double? weight,
    @Default('') String bloodGroup,
    @Default('') String eyeColor,
    AddressModel? address,
    CompanyModel? company,
    @Default('') String role,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  User toEntity() => User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phone: phone,
        age: age ?? 0,
        gender: gender,
        birthDate: birthDate,
        image: image,
        height: height ?? 0,
        weight: weight ?? 0,
        bloodGroup: bloodGroup,
        eyeColor: eyeColor,
        address: address?.toEntity() ?? const UserAddress(),
        company: company?.toEntity() ?? const UserCompany(),
        role: role,
      );
}
