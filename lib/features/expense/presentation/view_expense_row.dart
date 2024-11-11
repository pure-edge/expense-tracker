import 'package:flutter/material.dart';

class LabelValueRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Text("$value"),
      ],
    );
  }
}
