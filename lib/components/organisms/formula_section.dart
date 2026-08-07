import 'dart:collection';

import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/el_dropdown_menu.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FormulaSection extends StatelessWidget {
  final double? width;
  final Formula? formula;
  final Widget? auxiliaryTool;
  final NicProfile? nicProfile;
  final bool isNicProfileFinal;
  final ValueChanged<NicProfile?>? onNicProfileSelected;
  final TextEditingController nicLevelController;
  final ValueChanged<String>? onNicLevelSubmitted;
  final bool showCustomCheckBox;
  final bool isCustom;
  final ValueChanged<bool?>? onIsCustomChanged;

  const FormulaSection({
    super.key,
    this.width,
    required this.formula,
    this.auxiliaryTool,
    required this.nicProfile,
    bool isNicProfileFinal = false,
    this.onNicProfileSelected,
    required this.nicLevelController,
    this.onNicLevelSubmitted,
    this.showCustomCheckBox = false,
    this.isCustom = false,
    this.onIsCustomChanged,
  }) : isNicProfileFinal = nicProfile == null ? false : isNicProfileFinal;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: "FORMULA",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formula!.brand.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    formula!.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${formula!.nicType.toString()} — ${formula!.chilltype.toString()}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              auxiliaryTool ?? const SizedBox.shrink(),
            ],
          ),
          const Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ElDropdownMenu<NicProfile>(
                  width: 360,
                  labelText: 'Profile',
                  initialSelection: nicProfile,
                  enabled: true,
                  dropdownMenuEntries:
                      UnmodifiableListView<DropdownMenuEntry<NicProfile>>(
                    formula!.nicProfiles.map<DropdownMenuEntry<NicProfile>>(
                      (nicProfile) => DropdownMenuEntry<NicProfile>(
                        value: nicProfile,
                        label: nicProfile.label,
                      ),
                    ),
                  ),
                  onSelected: onNicProfileSelected,
                ),
              ),
              SizedBox(
                width: 140,
                child: Padding(
                  padding: const EdgeInsetsGeometry.only(
                    left: 8.0,
                    right: 12.0,
                  ),
                  child: ElTextField(
                    controller: nicLevelController,
                    contentType: ElTextFieldContentType.numeric,
                    readOnly: onNicLevelSubmitted == null,
                    labelText: 'Nic Level',
                    suffixText: 'mg',
                    onSubmitted: onNicLevelSubmitted,
                  ),
                ),
              ),
              showCustomCheckBox
                  ? ElCheckbox(
                      width: 50,
                      value: isCustom,
                      labelText: 'Custom',
                      onChanged: onIsCustomChanged,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
