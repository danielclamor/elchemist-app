import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/formula/domain/nic_base.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/nic_base_entry_row.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MixNicBaseSection extends StatefulWidget {
  final double? width;
  final double nicStr;
  final double vg;
  final double pg;
  final List<NicBase> nicBases;
  final Widget? addEntryButton;
  final bool isCustom;

  const MixNicBaseSection({
    super.key,
    this.width,
    required this.nicStr,
    required this.vg,
    required this.pg,
    required this.nicBases,
    this.addEntryButton,
    this.isCustom = false,
  });

  @override
  State<MixNicBaseSection> createState() => _MixNicBaseSectionState();
}

class _MixNicBaseSectionState extends State<MixNicBaseSection> {
  late final TextEditingController _nicStrController;
  late final TextEditingController _vgController;
  late final TextEditingController _pgController;

  @override
  void initState() {
    super.initState();
    _nicStrController = TextEditingController(text: '${widget.nicStr * 100}');
    _vgController = TextEditingController(text: '${widget.vg * 100}');
    _pgController = TextEditingController(text: '${widget.pg * 100}');
  }

  @override
  void dispose() {
    super.dispose();
    _nicStrController.dispose();
    _vgController.dispose();
    _pgController.dispose();
  }

  final _nicBaseEntries = <String, NicBaseEntry>{};

  NicBaseEntry _nicBaseEntry(NicBaseOption o, double? ratio) => _nicBaseEntries
      .putIfAbsent(o.id, () => NicBaseEntry(nicBaseOption: o, ratio: ratio));

  @override
  Widget build(BuildContext context) {
    final nicBases = widget.nicBases;
    final isCustom = widget.isCustom;

    return SectionCard(
      width: widget.width,
      title: "NIC BASE",
      child: Column(
        children: [
          ElTextField(
            controller: _nicStrController,
            contentType: ElTextFieldContentType.numeric,
            labelText: 'Nic Str',
            labelPosition: ElTextFieldLabelPosition.left,
            readOnly: !isCustom,
            suffixText: '%',
            onSubmitted: (value) {},
          ),
          const Gap(8.0),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: ElTextField(
                  controller: _vgController,
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'VG',
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: !isCustom,
                  suffixText: '%',
                  onSubmitted: (value) {},
                ),
              ),
              Expanded(
                child: ElTextField(
                  controller: _pgController,
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'PG',
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: !isCustom,
                  suffixText: '%',
                  onSubmitted: (value) {},
                ),
              ),
            ],
          ),
          nicBases.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    const Gap(16.0),
                    Divider(
                      thickness: 1,
                      color: Theme.of(context).focusColor,
                    ),
                    const Gap(16.0),
                    Row(
                      spacing: 4.0,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )),
                        Expanded(
                            flex: 4,
                            child: Text(
                              'Percentage',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.right,
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              'VG',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ),
                    const Gap(8.0),
                    Column(
                      spacing: 8.0,
                      children: List.generate(
                        nicBases.length,
                        (index) {
                          final nicBase = nicBases[index];
                          final entry = _nicBaseEntry(
                            nicBase.nicBaseOption,
                            nicBase.ratio,
                          );
                          return NicBaseEntryRow(
                            entry: entry,
                            isCustom: isCustom,
                            onPercentSubmitted:
                                isCustom ? (value) => setState(() {}) : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
          widget.addEntryButton ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
