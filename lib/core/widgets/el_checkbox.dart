import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ElCheckbox extends StatelessWidget {
  final double? width;
  final String? labelText;
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;

  const ElCheckbox({
    super.key,
    this.width,
    this.labelText,
    this.value,
    this.onChanged,
    this.tristate = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 24,
      child: Column(
        children: [
          labelText != null
              ? Text(labelText ?? '',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ))
              : const SizedBox.shrink(),
          labelText != null ? const Gap(10.0) : const Gap(2.0),
          Checkbox(
            value: value,
            onChanged: onChanged,
            tristate: tristate,
            visualDensity: VisualDensity.compact,
            side: BorderSide(color: Theme.of(context).focusColor),
            fillColor: onChanged != null
                ? WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).hoverColor.withAlpha(250);
                    }
                    return Theme.of(context).colorScheme.surfaceContainer;
                  })
                : null,
          ),
        ],
      ),
    );
  }
}
