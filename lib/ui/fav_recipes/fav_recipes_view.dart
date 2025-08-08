import 'package:app_recipes/di/service_locator.dart';
import 'package:app_recipes/ui/fav_recipes/fav_recipes_view_model.dart';
import 'package:app_recipes/ui/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';

class FavRecipesView extends StatefulWidget {
  const FavRecipesView({super.key});

  @override
  State<FavRecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<FavRecipesView> {
  final viewModel = getIt<FavRecipesViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.getFavRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading) {
        return Center(
          child: SizedBox(
            height: 96,
            width: 96,
            child: CircularProgressIndicator(strokeWidth: 12),
          ),
        );
      }

      if (viewModel.errorMessage != '') {
        return Center(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Column(
              spacing: 32,
              children: [
                Text(
                  'Erro: ${viewModel.errorMessage}',
                  style: TextStyle(fontSize: 24),
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.getFavRecipes();
                  },
                  child: Text('TENTAR NOVAMENTE'),
                ),
              ],
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: viewModel.favRecipes.isNotEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Text(
                            '${viewModel.favRecipes.length} receitas(s)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.favRecipes.length,
                              itemBuilder: (context, index) {
                                final recipe = viewModel.favRecipes[index];

                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          context.go('/recipe/${recipe.id}'),
                                      child: RecipeCard(recipe: recipe),
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          size: 32,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          viewModel.removeFavRecipe(recipe.id);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).clearSnackBars();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${recipe.name} desfavoritada!',
                                                ),
                                                duration: Duration(seconds: 3),
                                                // action: SnackBarAction(
                                                //   label: 'DESFAZER',
                                                //   onPressed: () {
                                                //     viewModel.addToFavorites(
                                                //       recipe,
                                                //     );
                                                //   },
                                                // ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 64),
                          Icon(
                            Icons.favorite,
                            size: 96,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Adicione suas receitas favoritas!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}
