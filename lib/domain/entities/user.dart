class User {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.birthDate,
    required this.image,
    required this.height,
    required this.weight,
    required this.bloodGroup,
    required this.eyeColor,
    required this.address,
    required this.company,
    required this.role,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phone;
  final int age;
  final String gender;
  final String birthDate;
  final String image;
  final double height;
  final double weight;
  final String bloodGroup;
  final String eyeColor;
  final UserAddress address;
  final UserCompany company;
  final String role;

  String get fullName => '$firstName $lastName'.trim();
}

class UserAddress {
  const UserAddress({
    this.address = '',
    this.city = '',
    this.state = '',
    this.country = '',
  });

  final String address;
  final String city;
  final String state;
  final String country;

  String get displayValue => <String>[address, city, state, country]
      .where((value) => value.isNotEmpty)
      .join(', ');
}

class UserCompany {
  const UserCompany({
    this.name = '',
    this.title = '',
    this.department = '',
  });

  final String name;
  final String title;
  final String department;
}

class UsersPage {
  const UsersPage({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<User> users;
  final int total;
  final int skip;
  final int limit;
}
