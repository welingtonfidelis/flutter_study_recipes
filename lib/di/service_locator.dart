import 'package:app_recipes/data/models/services/recipe_service.dart';
import 'package:app_recipes/data/repositories/recipe_repository.dart';
import 'package:app_recipes/ui/fav_recipes/fav_recipes_view_model.dart';
import 'package:app_recipes/ui/recipe_detail/recipe_detail_view_model.dart';
import 'package:app_recipes/ui/recipes/recipes_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Supabase Client
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

  // Recipe Service
  getIt.registerLazySingleton<RecipeService>(() => RecipeService());

  // Recipe Repository
  getIt.registerLazySingleton<RecipeRepository>(() => RecipeRepository());

  // Recipe View Model
  getIt.registerLazySingleton<RecipesViewModel>(() => RecipesViewModel());

  // Recipe Detail View Model
  getIt.registerLazySingleton<RecipeDetailViewModel>(
    () => RecipeDetailViewModel(),
  );

  // Fav Recipe View Model 
    getIt.registerLazySingleton<FavRecipesViewModel>(
    () => FavRecipesViewModel(),
  );
}
