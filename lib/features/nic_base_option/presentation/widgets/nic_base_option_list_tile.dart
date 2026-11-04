import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option.dart';
import 'package:flutter/material.dart';

class NicBaseOptionPickerListTile extends StatelessWidget {
  final NicBaseOption nicBaseOption;
  final bool isSelected;
  final VoidCallback? onTap;

  const NicBaseOptionPickerListTile({
    super.key,
    required this.nicBaseOption,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      enabled: onTap != null,
      selected: isSelected,
      title: Text(nicBaseOption.label),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 4.0,
      ),
      trailing: Icon(
        isSelected
            ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded,
      ),
    );
  }
}
