import 'package:elchemist_app/features/diy_mix/presentations/widgets/diy_mix_nic_base_section.dart';
import 'package:elchemist_app/features/diy_mix/presentations/widgets/diy_mix_recipe_section.dart';
import 'package:elchemist_app/features/diy_mix/presentations/widgets/diy_mix_target_section.dart';
import 'package:elchemist_app/features/diy_mix/presentations/widgets/diy_mix_volume_section.dart';
import 'package:flutter/material.dart';

class DiyMixScreen extends StatelessWidget {
  const DiyMixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var mixWrapperWidth = screenSize.width < 1920 ? 1000.0 : double.infinity;
    var sectionWidth = 350.0;
    var recipeSectionWidth =
        screenSize.width < 1920 ? sectionWidth : sectionWidth + 350;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            constraints: BoxConstraints(maxWidth: mixWrapperWidth),
            child: Wrap(
              spacing: 20.0,
              children: [
                DiyMixVolumeSection(
                  width: sectionWidth,
                ),
                Column(
                  spacing: 20.0,
                  children: [
                    DiyMixNicBaseSection(
                      width: sectionWidth,
                    ),
                    DiyMixTargetSection(
                      width: sectionWidth,
                    ),
                  ],
                ),
                DiyMixRecipeSection(
                  width: recipeSectionWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
