// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AdminUserModel {
  late String image;
  late String email;
  late String name;
  late String id;
  late String? token;
  late bool? authorize;
  late bool isSuperAdmin;
  AdminUserModel({
    required this.image,
    required this.email,
    required this.name,
    required this.id,
    this.token,
    required this.authorize,
    required this.isSuperAdmin,
  });

  AdminUserModel copyWith({
    String? image,
    String? email,
    String? name,
    String? id,
    String? token,
    bool? authorize,
    bool? isSuperAdmin,
  }) {
    return AdminUserModel(
      image: image ?? this.image,
      email: email ?? this.email,
      name: name ?? this.name,
      id: id ?? this.id,
      token: token ?? this.token,
      authorize: authorize ?? this.authorize,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'email': email,
      'name': name,
      'id': id,
      'token': token,
      'authorize': authorize,
      'isSuperAdmin': isSuperAdmin,
    };
  }

  factory AdminUserModel.fromMap(Map<String, dynamic> map) {
    return AdminUserModel(
      image: map['image'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      id: map['id'] as String,
      token: map['token'] != null ? map['token'] as String : null,
      authorize: map['authorize'] as bool?,
      isSuperAdmin: map['isSuperAdmin'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminUserModel.fromJson(String source) =>
      AdminUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdminUserModel(image: $image, email: $email, name: $name, id: $id, token: $token, authorize: $authorize, isSuperAdmin: $isSuperAdmin)';
  }

  @override
  bool operator ==(covariant AdminUserModel other) {
    if (identical(this, other)) return true;

    return other.image == image &&
        other.email == email &&
        other.name == name &&
        other.id == id &&
        other.token == token &&
        other.authorize == authorize &&
        other.isSuperAdmin == isSuperAdmin;
  }

  @override
  int get hashCode {
    return image.hashCode ^
        email.hashCode ^
        name.hashCode ^
        id.hashCode ^
        token.hashCode ^
        authorize.hashCode ^
        isSuperAdmin.hashCode;
  }
}
