import 'package:app_recipes/di/service_locator.dart';
import 'package:app_recipes/utils/app_error.dart';
import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  User? get currentUser => _supabaseClient.auth.currentUser;

  Future<Either<AppError, AuthResponse>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      return Right(response);
    } on AuthException catch (e) {
      switch (e.message) {
        case 'Invalid login credentials':
          return Left(
            AppError('Usuário não cadastrado ou credenciais inválidas'),
          );

        case 'Email not confirmed':
          return Left(AppError('Email não confirmado'));

        default:
          return Left(AppError('Erro ao fazer login', e));
      }
    }
  }

  Future<Either<AppError, Map<String, dynamic>?>> fetchUserProfile(
    String userId,
  ) async {
    try {
      final data = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return Right(data);
    } catch (e) {
      return Left(AppError('Erro ao carregar perfil'));
    }
  }

  // sing up
  // _supabaseClient.auth.singUp();
}
