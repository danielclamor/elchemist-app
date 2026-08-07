import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';

class FormulaSearchSection extends StatelessWidget {
  final double? width;
  final SearchController searchController;
  final SuggestionsBuilder suggestionsBuilder;

  const FormulaSearchSection({
    super.key,
    this.width,
    required this.searchController,
    required this.suggestionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: "FORMULA",
      child: SearchAnchor(
        searchController: searchController,
        viewShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        viewSide: const BorderSide(
          color: Colors.white,
        ),
        builder: (context, controller) {
          return SearchBar(
            onTap: () {
              searchController.openView();
            },
            leading: const Icon(Icons.search),
            elevation: const WidgetStatePropertyAll(
              0.0,
            ),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                side: BorderSide(),
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
            ),
          );
        },
        suggestionsBuilder: suggestionsBuilder,
      ),
    );
  }
}
