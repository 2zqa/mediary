import 'package:flutter/material.dart';

class GroupHeader extends StatelessWidget {
  const GroupHeader({Key? key, required this.heading}) : super(key: key);

  final String heading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 20.0),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(heading),
      ),
    );
  }
}
