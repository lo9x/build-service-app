enum UserRole { guest, customer, specialist }

enum CustomerType { company, entrepreneur, selfEmployed }

enum VerificationStatus { pending, approved, rejected, notRequired }

UserRole userRoleFromString(String? value) {
  switch (value) {
    case 'customer':
      return UserRole.customer;
    case 'specialist':
      return UserRole.specialist;
    default:
      return UserRole.guest;
  }
}

CustomerType? customerTypeFromString(String? value) {
  switch (value) {
    case 'company':
      return CustomerType.company;
    case 'entrepreneur':
      return CustomerType.entrepreneur;
    case 'selfEmployed':
      return CustomerType.selfEmployed;
    default:
      return null;
  }
}

VerificationStatus verificationStatusFromString(String? value) {
  switch (value) {
    case 'approved':
      return VerificationStatus.approved;
    case 'rejected':
      return VerificationStatus.rejected;
    case 'pending':
      return VerificationStatus.pending;
    default:
      return VerificationStatus.notRequired;
  }
}

String userRoleToString(UserRole value) {
  switch (value) {
    case UserRole.customer:
      return 'customer';
    case UserRole.specialist:
      return 'specialist';
    case UserRole.guest:
      return 'guest';
  }
}

String customerTypeToString(CustomerType? value) {
  switch (value) {
    case CustomerType.company:
      return 'company';
    case CustomerType.entrepreneur:
      return 'entrepreneur';
    case CustomerType.selfEmployed:
      return 'selfEmployed';
    case null:
      return '';
  }
}

String verificationStatusToString(VerificationStatus value) {
  switch (value) {
    case VerificationStatus.pending:
      return 'pending';
    case VerificationStatus.approved:
      return 'approved';
    case VerificationStatus.rejected:
      return 'rejected';
    case VerificationStatus.notRequired:
      return 'notRequired';
  }
}

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.customer:
        return 'Заказчик';
      case UserRole.specialist:
        return 'Специалист';
      case UserRole.guest:
        return 'Гость';
    }
  }
}

extension CustomerTypeX on CustomerType {
  String get label {
    switch (this) {
      case CustomerType.company:
        return 'Компания';
      case CustomerType.entrepreneur:
        return 'ИП';
      case CustomerType.selfEmployed:
        return 'Самозанятый';
    }
  }
}

extension VerificationStatusX on VerificationStatus {
  String get label {
    switch (this) {
      case VerificationStatus.pending:
        return 'На проверке';
      case VerificationStatus.approved:
        return 'Подтверждено';
      case VerificationStatus.rejected:
        return 'Отклонено';
      case VerificationStatus.notRequired:
        return 'Не требуется';
    }
  }
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.city,
    this.customerType,
    this.inn,
    this.verificationDocumentUrl,
    this.verificationStatus = VerificationStatus.notRequired,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String city;
  final CustomerType? customerType;
  final String? inn;
  final String? verificationDocumentUrl;
  final VerificationStatus verificationStatus;

  bool get isCustomer => role == UserRole.customer;
  bool get isSpecialist => role == UserRole.specialist;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? city,
    CustomerType? customerType,
    String? inn,
    String? verificationDocumentUrl,
    VerificationStatus? verificationStatus,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      city: city ?? this.city,
      customerType: customerType ?? this.customerType,
      inn: inn ?? this.inn,
      verificationDocumentUrl:
          verificationDocumentUrl ?? this.verificationDocumentUrl,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'].toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: userRoleFromString(json['role']?.toString()),
      city: (json['city'] ?? '').toString(),
      customerType: customerTypeFromString(json['customerType']?.toString()),
      inn: json['inn']?.toString(),
      verificationDocumentUrl: json['verificationDocumentUrl']?.toString(),
      verificationStatus:
          verificationStatusFromString(json['verificationStatus']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': userRoleToString(role),
      'city': city,
      'customerType': customerTypeToString(customerType),
      'inn': inn,
      'verificationDocumentUrl': verificationDocumentUrl,
      'verificationStatus': verificationStatusToString(verificationStatus),
    };
  }
}
