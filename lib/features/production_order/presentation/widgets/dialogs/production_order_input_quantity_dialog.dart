import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductionOrderInputQuantityDialog extends ConsumerStatefulWidget {
  final String id;
  final int? orderedQuantity;
  final ProductionOrderJobType jobType;

  const ProductionOrderInputQuantityDialog({
    super.key,
    required this.id,
    required this.orderedQuantity,
    required this.jobType,
  });

  @override
  ConsumerState<ProductionOrderInputQuantityDialog> createState() =>
      _ProductionOrderInputQuantityDialogState();
}

class _ProductionOrderInputQuantityDialogState
    extends ConsumerState<ProductionOrderInputQuantityDialog> {
  final _quantityController = TextEditingController();
  String? _errorMessage;
  bool _hasError() => _errorMessage != null;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.orderedQuantity != null) {
      _quantityController.text = widget.orderedQuantity.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
  }

  Future<void> _submit(
    int? orderedQuantity,
    ProductionOrderJobType jobType,
  ) async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await ref.read(productionOrderRepositoryProvider).assignJob(
            id: widget.id,
            orderedQuantity: orderedQuantity,
            jobType: jobType,
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
        '${widget.orderedQuantity != null ? 'Confirm' : 'Enter'} ordered quantity',
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
          if (widget.jobType == ProductionOrderJobType.mix)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Quantity is required for mixing',
                style: TextStyle(color: Colors.grey),
              ),
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
                  _submit(qty, widget.jobType);
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
