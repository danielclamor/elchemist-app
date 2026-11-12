import 'package:elchemist_app/features/formula/presentation/widgets/formula_detail_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FormulaDetailScreen extends StatelessWidget {
  final String id;

  const FormulaDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var wrapperWidth = screenSize.width < 1920 ? 800.0 : 1000.0;
    var sectionWidth = 500.0;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
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
                  ],
                ),
                Gap(16.0),
                FormulaDetailWrapper(
                  wrapperWidth: wrapperWidth,
                  sectionWidth: sectionWidth,
                  id: id,
                  showMixButton: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
