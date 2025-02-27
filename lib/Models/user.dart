class User {
  int? id;
  String userName;
  String city;
  String state;
  String email;
  String mobileNumber;
  String dateOfBirth;
  String address;
  String gender;
  String age;
  String password;
  String confirmPassword;
  int isFavorite;

  // Constructor
  User({
    this.id,
    required this.userName,
    required this.city,
    required this.address,
    required this.state,
    required this.email,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.age,
    required this.password,
    required this.confirmPassword,
    this.isFavorite = 0, // Default value,
  });

  // Convert a User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'city': city,
      'state': state,
      'email': email,
      'mobileNumber': mobileNumber,
      'dateOfBirth': dateOfBirth,
      'address':address,
      'gender': gender,
      'age': age,
      'password': password,
      'confirmPassword': confirmPassword,
      'isFavorite': isFavorite,
    };
  }

  // Extract a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      userName: map['userName'],
      city: map['city'],
      state: map['state'],
      email: map['email'],
      mobileNumber: map['mobileNumber'],
      dateOfBirth: map['dateOfBirth'],
      gender: map['gender'],
      age: map['age'],
      password: map['password'],
      confirmPassword: map['confirmPassword'],
      isFavorite: map['isFavorite'] ?? 0,
      address: map['address'],
    );
  }
}
