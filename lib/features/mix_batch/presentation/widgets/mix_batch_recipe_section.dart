import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/mix_batch/presentation/providers/mix_batch_providers.dart';
import 'package:elchemist_app/features/recipe/providers/recipe_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MixBatchRecipeSection extends ConsumerWidget {
  final double? width;
  final String formulaId;

  const MixBatchRecipeSection({
    super.key,
    this.width,
    required this.formulaId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchVolumeMl = ref.watch(mixBatchVolumeMlValueProvider);

    final recipeInput = (
      formulaId: formulaId,
      batchVolumeMl: batchVolumeMl,
    );

    final async = ref.watch(recipeDetailsProvider(recipeInput));
    final recipe = async.hasValue ? async.value : null;
    final ingredients = recipe?.ingredients ?? [];
    final totalVolumeMl = recipe?.totalVolumeMl ?? 0.0;
    final totalWeightG = recipe?.totalWeightG ?? 0.0;

    return SectionCard(
      width: width,
      title: "RECIPE",
      child: Table(
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
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
          for (final ingredient in ingredients)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    ingredient.name,
                    style: GoogleFonts.robotoMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '${ingredient.volumeMl.toStringAsFixed(2)} mL',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.robotoMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '${ingredient.weightG.toStringAsFixed(2)} g',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.robotoMono(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          TableRow(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 4,
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${totalVolumeMl.toStringAsFixed(2)} mL',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.robotoMono(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${totalWeightG.toStringAsFixed(2)} g',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.robotoMono(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
