import 'package:flutter/material.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/widgets/custom_scaffold.dart';

class PartiesScreen extends StatefulWidget {
  const PartiesScreen({Key? key}) : super(key: key);

  @override
  State<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends State<PartiesScreen> {

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: ListView(
        children: const [
          Text('Parties', style: TextStyles.h1),
        ],
      ),
    );
  }
}
