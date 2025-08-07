import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/models/services/recipe_service.dart';
import 'package:app4_receitas/di/service_locator.dart';

class RecipeRepository {
  final _service = getIt<RecipeService>();

  Future<List<Recipe>> getRecipes() async {
    try {
      final rawData = await _service.fetchRecipes();
      return rawData.map((data) => Recipe.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Falha ao carregar receitas: ${e.toString()}');
    }
  }

  Future<Recipe?> getRecipeById(String id) async {
    try {
      final rawData = await _service.fetchRecipeById(id);
      return Recipe.fromJson(rawData);
    } catch (e) {
      throw Exception('Falha ao carrega receita: ${e.toString()}');
    }
  }

  Future<List<Recipe>> getFavRecipes(String userId) async {
    try {
      final rawData = await _service.fetchFavRecipes(userId);
      return rawData
          .where((data) => data['recipes'] != null)
          .map(
            (data) => Recipe.fromJson(data['recipes'] as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Falha ao carregar receitas: ${e.toString()}');
    }
  }
}
