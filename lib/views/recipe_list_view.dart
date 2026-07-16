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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Mix",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2.0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsetsGeometry.fromLTRB(36, 24, 36, 0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: SearchBar(
                  controller: _controller,
                  leading: const Icon(Icons.search),
                  elevation: const WidgetStatePropertyAll(0.0),
                  shape: const WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
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
    );
  }
}
