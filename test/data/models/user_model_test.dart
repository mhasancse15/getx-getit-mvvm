import 'package:flutter_test/flutter_test.dart';
import 'package:getxwithmvvmdemo/data/models/user/user_model.dart';



void main() {
  test('parses the API user JSON without exposing password', () {
    final model = UserModel.fromJson(<String, dynamic>{
      'id': 1,
      'firstName': 'Emily',
      'lastName': 'Johnson',
      'username': 'emilys',
      'email': 'emily@example.com',
      'phone': '123',
      'age': 28,
      'gender': 'female',
      'birthDate': '1996-5-12',
      'image': 'https://example.com/image.png',
      'height': 1.72,
      'weight': 70,
      'bloodGroup': 'O+',
      'eyeColor': 'Green',
      'password': 'must-not-be-used',
      'address': <String, dynamic>{
        'address': '123 Main St',
        'city': 'Springfield',
        'state': 'Illinois',
        'country': 'United States',
      },
      'company': <String, dynamic>{
        'name': 'Acme',
        'title': 'Engineer',
        'department': 'Engineering',
      },
      'role': 'admin',
    });

    expect(model.firstName, 'Emily');
    expect(model.toEntity().company.name, 'Acme');
    expect(model.toJson().containsKey('password'), isFalse);
  });
}
