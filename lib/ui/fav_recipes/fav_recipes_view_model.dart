import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/repositories/recipe_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/utils/config/env.dart';
import 'package:get/get.dart';

class FavRecipesViewModel extends GetxController {
  final _repository = getIt<RecipeRepository>();

  final RxList<Recipe> _favRecipes = <Recipe>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  List<Recipe> get favRecipes => _favRecipes;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  Future<void> getFavRecipes() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _favRecipes.value = await _repository.getFavRecipes(Env.userId);
    } catch (e) {
      _errorMessage.value = 'Falha ao buscar receitas favoritas: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }
}
