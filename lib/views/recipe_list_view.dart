import 'package:elchemist_app/components/molecules/recipe_card.dart';
import 'package:elchemist_app/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeListView extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeListView({
    super.key,
    required this.recipes,
  });

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  late TextEditingController _controller;
  String searchText = '';

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Recipe> recipes = widget.recipes;

    final filteredRecipes = recipes
        .where((recipe) =>
            recipe.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(24.0),
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            margin: EdgeInsetsGeometry.zero,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsetsGeometry.all(20.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          recipe: filteredRecipes[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
