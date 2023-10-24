import 'package:flutter/material.dart';

class GroupHeader extends StatelessWidget {
  const GroupHeader({super.key, required this.heading});

  final String heading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 24),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(heading),
      ),
    );
  }
}
