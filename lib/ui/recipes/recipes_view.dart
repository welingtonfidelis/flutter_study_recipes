import 'package:app_recipes/di/service_locator.dart';
import 'package:app_recipes/ui/fav_recipes/fav_recipes_view_model.dart';
import 'package:app_recipes/ui/recipes/recipes_view_model.dart';
import 'package:app_recipes/ui/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  final viewModel = getIt<RecipesViewModel>();
  final favRecipeViewModel = getIt<FavRecipesViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.getRecipes();
      favRecipeViewModel.getFavRecipes();
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
                    viewModel.getRecipes();
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
              child: viewModel.recipes.isNotEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Text(
                            '${viewModel.recipes.length} receitas(s)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.recipes.length,
                              itemBuilder: (context, index) {
                                final recipe = viewModel.recipes[index];

                                // TODO fix dont update icon after add/remove fav
                                final isFavorite = favRecipeViewModel
                                    .isFavorite(recipe.id);
                                final toggleFavErrorMessage =
                                    favRecipeViewModel.toggleFavErrorMessage;

                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          context.go('/recipe/${recipe.id}'),
                                      child: RecipeCard(recipe: recipe),
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 8,
                                      child: IconButton(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 32,
                                          color: isFavorite ? Colors.red : null,
                                        ),
                                        onPressed: () {
                                          if (isFavorite) {
                                            favRecipeViewModel.removeFavRecipe(
                                              recipe.id,
                                            );

                                            // TODO fix dont showing error message
                                            if (toggleFavErrorMessage != '') {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).clearSnackBars();
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    toggleFavErrorMessage!,
                                                  ),
                                                  duration: Duration(
                                                    seconds: 6,
                                                  ),
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

                                            // if (context.mounted) {
                                            //   ScaffoldMessenger.of(
                                            //     context,
                                            //   ).clearSnackBars();
                                            //   ScaffoldMessenger.of(
                                            //     context,
                                            //   ).showSnackBar(
                                            //     SnackBar(
                                            //       content: Text(
                                            //         '${recipe.name} desfavoritada!',
                                            //       ),
                                            //       duration: Duration(
                                            //         seconds: 3,
                                            //       ),
                                            //       action: SnackBarAction(
                                            //         label: 'DESFAZER',
                                            //         onPressed: () {
                                            //           viewModel.addToFavorites(
                                            //             recipe,
                                            //           );
                                            //         },
                                            //       ),
                                            //     ),
                                            //   );
                                            // }
                                          } else {
                                            favRecipeViewModel.addFavRecipe(
                                              recipe.id,
                                            );

                                            if (toggleFavErrorMessage != '') {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).clearSnackBars();
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    toggleFavErrorMessage!,
                                                  ),
                                                  duration: Duration(
                                                    seconds: 6,
                                                  ),
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

                                            // if (context.mounted) {
                                            //   ScaffoldMessenger.of(
                                            //     context,
                                            //   ).clearSnackBars();
                                            //   ScaffoldMessenger.of(
                                            //     context,
                                            //   ).showSnackBar(
                                            //     SnackBar(
                                            //       content: Text(
                                            //         '${recipe.name} favoritada!',
                                            //       ),
                                            //       duration: const Duration(
                                            //         seconds: 2,
                                            //       ),
                                            //     ),
                                            //   );
                                            // }
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
