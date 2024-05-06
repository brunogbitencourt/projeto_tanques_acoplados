class User {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? address;
  String? role;

  User({
    this.name,
    this.email,
    this.password,
    this.phone,
    this.address,
    this.role,
  });

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    address = json['address'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['address'] = address;
    data['role'] = role;
    return data;
  }
  
}
