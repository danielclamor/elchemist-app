import 'package:elchemist_app/features/formula/presentation/widgets/formula_detail_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FormulaDetailScreen extends StatelessWidget {
  final String id;

  const FormulaDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            constraints: BoxConstraints(),
            child: Column(
              children: [
                Row(
                  spacing: 8.0,
                  children: [
                    Tooltip(
                      message: "Formulas",
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            shape: const CircleBorder(),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Formulas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: SizedBox.shrink()),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                      ),
                      onPressed: () {}, // TODO implement edit state
                      label: Text("Edit"),
                      icon: Icon(Icons.edit),
                    ),
                    Gap(4.0),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                      ),
                      onPressed: () {},
                      label: Text("Mix a batch"),
                      icon: Icon(Icons.science_rounded),
                    ),
                  ],
                ),
                Gap(16.0),
                FormulaDetailWrapper(
                  id: id,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
