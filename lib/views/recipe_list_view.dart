import 'package:elchemist_app/components/molecules/recipe_card.dart';
import 'package:elchemist_app/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
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
                        borderSide: BorderSide(
                          color: Color(0xFF6CA0C4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Color(0xFF0E76BD),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsetsGeometry.all(20.0),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsetsGeometry.symmetric(
                          vertical: 4,
                          horizontal: 0,
                        ),
                        child: RecipeCard(
                          recipe: filteredRecipes[index],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
