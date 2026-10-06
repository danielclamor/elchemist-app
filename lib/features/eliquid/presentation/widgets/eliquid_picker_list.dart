import 'package:elchemist_app/features/eliquid/presentation/providers/eliquid_providers.dart';
import 'package:elchemist_app/features/eliquid/presentation/widgets/eliquid_picker_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EliquidPickerList extends ConsumerStatefulWidget {
  const EliquidPickerList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EliquidPickerList();
}

class _EliquidPickerList extends ConsumerState<EliquidPickerList> {
  @override
  Widget build(BuildContext context) {
    final pager = ref.watch(eliquidListPagerProvider);
    final pageKey = (after: pager.currentCursor);
    final pageAsync = ref.watch(eliquidListPageProvider(pageKey));

    return pageAsync.when(
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: TextButton(
          onPressed: () => ref.invalidate(
            eliquidListPageProvider(pageKey),
          ),
          child: Text('Failed to load. Retry\n$e'),
        ),
      ),
      data: (page) {
        if (page.items.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                'No e-liquids',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: page.items.length,
          separatorBuilder: (context, index) => Divider(
            height: 0.0,
            thickness: 0.25,
          ),
          itemBuilder: (context, index) {
            final eliquid = page.items[index];
            // final isSelected = selectedIndex == index;
            final isSelected = false;

            return EliquidPickerListTile(
              key: ValueKey(eliquid.id),
              eliquid: eliquid,
              isSelected: isSelected,
              onTap: () {},
            );
          },
        );
      },
    );
  }
}
