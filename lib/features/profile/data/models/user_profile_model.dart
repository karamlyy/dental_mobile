class UserProfileModel {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? doctorId;
  final String? clinicName;
  final DateTime createdAt;
  final String? gender;
  final String? address;
  final String? phoneNumber;
  final String? specialization;
  final DateTime? dateOfBirth;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.doctorId,
    this.clinicName,
    required this.createdAt,
    this.gender,
    this.address,
    this.phoneNumber,
    this.specialization,
    this.dateOfBirth,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
      doctorId: json['doctorId'] as String?,
      clinicName: json['clinicName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      specialization: json['specialization'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'doctorId': doctorId,
      'clinicName': clinicName,
      'createdAt': createdAt.toIso8601String(),
      'gender': gender,
      'address': address,
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  String get displayRole {
    switch (role) {
      case 'DOCTOR':
        return 'Həkim';
      case 'ASSISTANT':
        return 'Assistent';
      default:
        return role;
    }
  }

  String get displayGender {
    switch (gender) {
      case 'MALE':
        return 'Kişi';
      case 'FEMALE':
        return 'Qadın';
      default:
        return 'Göstərilməyib';
    }
  }
}
