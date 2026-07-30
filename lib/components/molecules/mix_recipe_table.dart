import 'package:elchemist_app/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MixRecipeTable extends StatelessWidget {
  final List<Ingredient> nicBases;
  final List<Ingredient> flavorings;
  final Ingredient vg;
  final Ingredient pg;

  const MixRecipeTable({
    super.key,
    required this.nicBases,
    required this.flavorings,
    required this.vg,
    required this.pg,
  });

  List<Ingredient> get _ingredients => [
        ...nicBases,
        ...flavorings,
        vg,
        pg,
      ];

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Theme.of(context).focusColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Ingredient',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Volume',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Weight',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        for (final ingredient in _ingredients)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  ingredient.name,
                  style: GoogleFonts.robotoMono(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${ingredient.volume.toStringAsFixed(2)} mL',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.robotoMono(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${ingredient.weight.toStringAsFixed(2)} g',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.robotoMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 2,
                color: Theme.of(context).focusColor,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Sum',
                style: GoogleFonts.robotoMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '${_ingredients.fold(0.0, (sum, ingredient) => ingredient.volume).toStringAsFixed(2)} mL',
                textAlign: TextAlign.right,
                style: GoogleFonts.robotoMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '${_ingredients.fold(0.0, (sum, ingredient) => ingredient.weight).toStringAsFixed(2)} g',
                textAlign: TextAlign.right,
                style: GoogleFonts.robotoMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
