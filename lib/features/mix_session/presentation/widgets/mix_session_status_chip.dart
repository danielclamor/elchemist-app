import 'package:elchemist_app/core/widgets/el_chip.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:flutter/material.dart';

class MixSessionStatusChip extends StatelessWidget {
  final IconData? labelIcon;
  final String labelText;
  final Color fgColor;
  final Color bgColor;

  const MixSessionStatusChip({
    super.key,
    this.labelIcon,
    required this.labelText,
    required this.fgColor,
    required this.bgColor,
  });

  factory MixSessionStatusChip.fromStatus({
    required MixSessionStatus status,
  }) =>
      switch (status) {
        MixSessionStatus.inProgress => MixSessionStatusChip(
            labelIcon: Icons.radio_button_checked_rounded,
            labelText: status.toString(),
            fgColor: Colors.blue.shade900,
            bgColor: Colors.blue.shade200,
          ),
        MixSessionStatus.mixed => MixSessionStatusChip(
            labelIcon: Icons.radio_button_checked_rounded,
            labelText: status.toString(),
            fgColor: Colors.grey.shade800,
            bgColor: Colors.grey,
          ),
      };

  @override
  Widget build(BuildContext context) {
    return ElChip(
      labelIcon: labelIcon,
      labelText: labelText,
      fgColor: fgColor,
      bgColor: bgColor,
    );
  }
}
