import 'package:elchemist_app/components/molecules/formula_card.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:elchemist_app/models/nic_base_option.dart';
import 'package:flutter/material.dart';

class FormulaListView extends StatefulWidget {
  final List<Formula> formulas;
  final List<NicBaseOption> nicBaseOptions;

  const FormulaListView({
    super.key,
    required this.formulas,
    required this.nicBaseOptions,
  });

  @override
  State<FormulaListView> createState() => _FormulaListViewState();
}

class _FormulaListViewState extends State<FormulaListView> {
  late TextEditingController _controller;
  String searchText = '';

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Formula> recipes = widget.formulas;

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
                        return FormulaCard(
                          formula: filteredRecipes[index],
                          nicBaseOptions: widget.nicBaseOptions,
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
