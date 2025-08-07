import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/ui/recipe_detail/recipe_detail_view_model.dart';
import 'package:app4_receitas/ui/widgets/recipe_row_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';

class RecipeDetailView extends StatefulWidget {
  const RecipeDetailView({super.key, required this.id});

  final String id;

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  final viewModel = getIt<RecipeDetailViewModel>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.getRecipe(widget.id);
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
                    context.go('/');
                  },
                  child: Text('VOLTAR'),
                ),
              ],
            ),
          ),
        );
      }

      final recipe = viewModel.recipe!;
      return SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              recipe.image!,
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                  ? child
                  : Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
              errorBuilder: (context, child, stackTrace) => Container(
                height: 400,
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.error),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(recipe.name),
                  SizedBox(height: 16),
                  RecipeRowDetails(recipe: recipe),
                  SizedBox(height: 16),

                  recipe.ingredients.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Ingredientes'),
                            SizedBox(height: 16),
                            Text(recipe.ingredients.join('\n')),
                          ],
                        )
                      : Text('Nenhum ingrediente listado.'),

                  SizedBox(height: 24),

                  recipe.instructions.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Instruções'),
                            SizedBox(height: 16),
                            Text(recipe.instructions.join('\n')),
                          ],
                        )
                      : Text('Nenhuma instrução listada.'),

                  SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/'),
                        child: Text('VOLTAR'),
                      ),

                      ElevatedButton(
                        onPressed: () {}, //() => viewModel.toggleFavorite(),
                        child: Text(viewModel.isFavorite ? 'DESFAVORITAR' : 'FAVORITAR'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
