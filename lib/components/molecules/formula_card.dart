import 'package:elchemist_app/models/formula.dart';
import 'package:elchemist_app/models/nic_base_option.dart';
import 'package:elchemist_app/transitions.dart';
import 'package:elchemist_app/views/formula_details_view.dart';
import 'package:flutter/material.dart';

class FormulaCard extends StatefulWidget {
  final Formula formula;
  final List<NicBaseOption> nicBaseOptions;

  const FormulaCard({
    super.key,
    required this.formula,
    required this.nicBaseOptions,
  });

  @override
  State<FormulaCard> createState() => _FormulaCardState();
}

class _FormulaCardState extends State<FormulaCard> {
  @override
  Widget build(BuildContext context) {
    final recipe = widget.formula;
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      surfaceTintColor: Colors.transparent,
      elevation: 0.0,
      child: InkWell(
        // hoverColor: Colors.grey[5],
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (
                context,
                animation,
                secondaryAnimation,
              ) =>
                  RecipeDetailsView(
                formula: recipe,
                nicBaseOptions: widget.nicBaseOptions,
              ),
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
                "${recipe.nicType.toString()} — ${recipe.chillType.toString()}",
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
