// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressModel _$AddressModelFromJson(Map<String, dynamic> json) =>
    _AddressModel(
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );

Map<String, dynamic> _$AddressModelToJson(_AddressModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
    };

_CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) =>
    _CompanyModel(
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      department: json['department'] as String? ?? '',
    );

Map<String, dynamic> _$CompanyModelToJson(_CompanyModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'title': instance.title,
      'department': instance.department,
    };

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String? ?? '',
  lastName: json['lastName'] as String? ?? '',
  username: json['username'] as String? ?? '',
  email: json['email'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  age: (json['age'] as num?)?.toInt(),
  gender: json['gender'] as String? ?? '',
  birthDate: json['birthDate'] as String? ?? '',
  image: json['image'] as String? ?? '',
  height: (json['height'] as num?)?.toDouble(),
  weight: (json['weight'] as num?)?.toDouble(),
  bloodGroup: json['bloodGroup'] as String? ?? '',
  eyeColor: json['eyeColor'] as String? ?? '',
  address: json['address'] == null
      ? null
      : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
  company: json['company'] == null
      ? null
      : CompanyModel.fromJson(json['company'] as Map<String, dynamic>),
  role: json['role'] as String? ?? '',
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'age': instance.age,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
      'image': instance.image,
      'height': instance.height,
      'weight': instance.weight,
      'bloodGroup': instance.bloodGroup,
      'eyeColor': instance.eyeColor,
      'address': instance.address,
      'company': instance.company,
      'role': instance.role,
    };
