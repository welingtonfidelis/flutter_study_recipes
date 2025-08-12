import 'package:app_recipes/ui/auth/auth_view.dart';
import 'package:app_recipes/ui/base_screen.dart';
import 'package:app_recipes/ui/fav_recipes/fav_recipes_view.dart';
import 'package:app_recipes/ui/recipe_detail/recipe_detail_view.dart';
import 'package:app_recipes/ui/recipes/recipes_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: '/login',
      routes: [
        ShellRoute(
          builder: (context, state, child) => BaseScreen(child: child),
          routes: [
            GoRoute(path: '/login', builder: (context, state) => const AuthView()),
            GoRoute(path: '/', builder: (context, state) => RecipesView()),
            GoRoute(
              path: '/recipe/:id',
              builder: (context, state) =>
                  RecipeDetailView(id: state.pathParameters['id']!),
            ),
            GoRoute(
              path: '/favorites',
              builder: (context, state) => FavRecipesView(),
            ),
          ],
        ),
      ],
    );
  }
}
