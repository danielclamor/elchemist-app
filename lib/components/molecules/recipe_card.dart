import 'package:elchemist_app/models/recipe.dart';
import 'package:elchemist_app/transitions.dart';
import 'package:elchemist_app/views/recipe_details_view.dart';
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
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0.0,
      child: InkWell(
        hoverColor: Colors.grey[5],
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (
                context,
                animation,
                secondaryAnimation,
              ) =>
                  RecipeDetailsView(recipe: recipe),
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
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.brand.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${recipe.nicType.toString()} — ${recipe.chilltype.toString()}",
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
