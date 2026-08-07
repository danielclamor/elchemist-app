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
  final SearchController searchController;
  final SuggestionsBuilder suggestionsBuilder;
  final VoidCallback? onChangeFormula;
  final NicProfile? nicProfile;
  final ValueChanged<NicProfile?>? onNicProfileSelected;
  final TextEditingController nicLevelController;
  final ValueChanged<String>? onNicLevelSubmitted;
  final bool isCustom;
  final ValueChanged<bool?>? onIsCustomChanged;

  const FormulaSection({
    super.key,
    this.width,
    required this.formula,
    required this.searchController,
    required this.suggestionsBuilder,
    this.onChangeFormula,
    required this.nicProfile,
    this.onNicProfileSelected,
    required this.nicLevelController,
    this.onNicLevelSubmitted,
    this.isCustom = false,
    this.onIsCustomChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: "FORMULA",
      child: formula == null
          ? SearchAnchor(
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
            )
          : Column(
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
                    onChangeFormula == null
                        ? const SizedBox.shrink()
                        : IconButton(
                            icon: const Icon(
                              Icons.change_circle_sharp,
                            ),
                            onPressed: onChangeFormula,
                          ),
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
                          formula!.nicProfiles
                              .map<DropdownMenuEntry<NicProfile>>(
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
                    ElCheckbox(
                      width: 50,
                      value: isCustom,
                      labelText: 'Custom',
                      onChanged: onIsCustomChanged,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
