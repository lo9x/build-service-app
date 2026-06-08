import 'app_user.dart';

class SpecialistProfile {
  const SpecialistProfile({
    required this.id,
    required this.userId,
    required this.profession,
    required this.experience,
    required this.description,
    required this.priceFrom,
    required this.user,
  });

  final String id;
  final String userId;
  final String profession;
  final int experience;
  final String description;
  final double priceFrom;
  final AppUser user;

  SpecialistProfile copyWith({
    String? id,
    String? userId,
    String? profession,
    int? experience,
    String? description,
    double? priceFrom,
    AppUser? user,
  }) {
    return SpecialistProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profession: profession ?? this.profession,
      experience: experience ?? this.experience,
      description: description ?? this.description,
      priceFrom: priceFrom ?? this.priceFrom,
      user: user ?? this.user,
    );
  }

  factory SpecialistProfile.fromJson(Map<String, dynamic> json) {
    final nestedUser = json['user'];
    final user = nestedUser is Map<String, dynamic>
        ? AppUser.fromJson(nestedUser)
        : AppUser(
            id: (json['userId'] ?? '').toString(),
            name: (json['name'] ?? '').toString(),
            email: (json['email'] ?? '').toString(),
            role: UserRole.specialist,
            city: (json['city'] ?? '').toString(),
          );

    return SpecialistProfile(
      id: json['id'].toString(),
      userId: (json['userId'] ?? user.id).toString(),
      profession: (json['profession'] ?? '').toString(),
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      description: (json['description'] ?? '').toString(),
      priceFrom: (json['priceFrom'] as num?)?.toDouble() ?? 0,
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'profession': profession,
      'experience': experience,
      'description': description,
      'priceFrom': priceFrom,
      'user': user.toJson(),
    };
  }
}
