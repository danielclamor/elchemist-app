import 'package:elchemist_app/models/recipe.dart';
import 'package:elchemist_app/transitions.dart';
import 'package:elchemist_app/views/recipe_view.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return InkWell(
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            4.0,
          ),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${recipe.brand} - ${recipe.nicType.name.toUpperCase()}",
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (
              context,
              animation,
              secondaryAnimation,
            ) =>
                RecipeView(recipe: recipe),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) =>
                slideTransitionBuilder(
              context,
              animation,
              secondaryAnimation,
              child,
            ),
          ),
        );
      },
    );
  }
}
