import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarkFulfilledDialog extends ConsumerStatefulWidget {
  final String id;

  const MarkFulfilledDialog({super.key, required this.id});

  @override
  ConsumerState<MarkFulfilledDialog> createState() =>
      _MarkFulfilledDialogState();
}

class _MarkFulfilledDialogState extends ConsumerState<MarkFulfilledDialog> {
  final _quantityController = TextEditingController();
  String? _errorMessage;
  bool _hasError() => _errorMessage != null;

  bool _isSubmitting = false;

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
  }

  Future<void> _submit(
    int fulfilledQuantity,
  ) async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await ref.read(productionOrderRepositoryProvider).markFulfilled(
            id: widget.id,
            fulfilledQuantity: fulfilledQuantity,
          );

      setState(() => _isSubmitting = false);

      if (!mounted) return;
      Navigator.of(context).pop();
      ref.invalidate(productionOrderDetailsProvider(widget.id));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = e is Exception
            ? e.toString()
            : 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints(maxWidth: 400, minWidth: 400),
      title: Text(
        'Enter fulfilled quantity',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElTextField(
            controller: _quantityController,
            contentType: ElTextFieldContentType.numeric,
            hasError: _hasError(),
            onSubmitted: (value) {
              setState(() => _quantityController.text = value);
            },
          ),
          if (_errorMessage != "")
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorMessage ?? "",
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: _isSubmitting
              ? null
              : () {
                  final qty = int.tryParse(_quantityController.text);
                  if (qty == null) {
                    setState(() => _errorMessage = "Quantity is required");
                    return;
                  }
                  _submit(qty);
                },
          child: Text('Submit'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
