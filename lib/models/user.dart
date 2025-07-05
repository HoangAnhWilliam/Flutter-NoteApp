class User {
  String? name;
  String? email;
  String? matkhau;
  String? xacnhanmatkhau;
  String? avatar;

  User({
    this.name,
    this.email,
    this.matkhau,
    this.xacnhanmatkhau,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'matkhau': matkhau,
      'xacnhanmatkhau': xacnhanmatkhau,
      'avatar': avatar,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      matkhau: json['matkhau'],
      xacnhanmatkhau: json['xacnhanmatkhau'],
      avatar: json['avatar'],
    );
  }

  User copyWith({
    String? name,
    String? email,
    String? matkhau,
    String? xacnhanmatkhau,
    String? avatar,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      matkhau: matkhau ?? this.matkhau,
      xacnhanmatkhau: xacnhanmatkhau ?? this.xacnhanmatkhau,
      avatar: avatar ?? this.avatar,
    );
  }

  bool get isValid {
    return email != null && 
           email!.contains('@') && 
           matkhau != null && 
           matkhau!.length >= 6;
  }

  bool get isPasswordConfirmed {
    return matkhau == xacnhanmatkhau;
  }
}