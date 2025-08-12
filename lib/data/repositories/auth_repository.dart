import 'package:app_recipes/data/models/services/auth_service.dart';
import 'package:app_recipes/data/user_profile.dart';
import 'package:app_recipes/di/service_locator.dart';
import 'package:app_recipes/utils/app_error.dart';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';

class AuthRepository extends GetxController {
  final _service = getIt<AuthService>();

  Future<Either<AppError, UserProfile>> get currentUser async {
    final user = _service.currentUser;

    final profile = await _service.fetchUserProfile(user!.id);

    // return UserProfile.fromSupabase(user.toJson(), profile.right!);
    return profile.fold(
      (error) => Left(error),
      (right) => Right(UserProfile.fromSupabase(user.toJson(), right!)),
    );
  }

  Future<Either<AppError, UserProfile>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final result = await _service.signInWithPassword(
      email: email,
      password: password,
    );

    return result.fold((error) => Left(error), (success) async {
      final user = success.user!;
      final profileResult = await _service.fetchUserProfile(user.id);

      return profileResult.fold(
        (error) => Left(error),
        (right) => Right(UserProfile.fromSupabase(user.toJson(), right!)),
      );
    });
  }
}
