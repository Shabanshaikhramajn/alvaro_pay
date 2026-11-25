import 'package:alvaro_pay/features/auth/domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({required super.id, required super.fullName, required super.email});

  factory AppUserModel.fromEntity(AppUser user) {
    return AppUserModel(id: user.id, fullName: user.fullName, email: user.email);
  }
}
