import 'package:elchemist_app/core/widgets/fading_vertical_scroll.dart';
import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';
import 'package:elchemist_app/features/eliquid/presentation/providers/eliquid_providers.dart';
import 'package:elchemist_app/features/eliquid/presentation/widgets/eliquid_picker_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EliquidPickerList extends ConsumerWidget {
  final String? selectedId;
  final ValueChanged<EliquidSummary> onSelected;

  const EliquidPickerList({
    super.key,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pager = ref.watch(eliquidListPagerProvider);
    final pageKey = (after: pager.currentCursor);
    final pageAsync = ref.watch(eliquidListPageProvider(pageKey));

    return pageAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: TextButton(
          onPressed: () => ref.invalidate(eliquidListPageProvider(pageKey)),
          child: Text('Failed to load. Retry\n$e'),
        ),
      ),
      data: (page) {
        if (page.items.isEmpty) {
          return const Center(
            child: Text(
              'No e-liquids',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }
        return FadingVerticalScroll(
          fadeHeight: 16,
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: page.items.length,
            separatorBuilder: (context, index) => const Divider(
              height: 0.0,
              thickness: 0.25,
            ),
            itemBuilder: (context, index) {
              final eliquid = page.items[index];
              return EliquidPickerListTile(
                key: ValueKey(eliquid.id),
                eliquid: eliquid,
                isSelected: eliquid.id == selectedId,
                onTap: () => onSelected(eliquid),
              );
            },
          ),
        );
      },
    );
  }
}
