class User {
  final String idNumber;
  final String pass;
  final String email;
  final String name;
  bool hasVoted = false;

  User({required this.idNumber, required this.pass, required this.email, required this.name});

 User.simplified({required this.name})
      : idNumber = '',
        pass = '',
        email = '';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idNumber: json['id'],
      pass: json['password'],
      name: json['fname'] + " " + json['lname'],
      email: json['email'],
    );
  }

  void printData() {
    print('ID: $idNumber');
    print('Name: $name');
    print('Email: $email');
  }

}