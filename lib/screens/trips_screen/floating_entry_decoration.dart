import 'package:flutter/material.dart';
import 'package:layover_party/styles/styles.dart';

final floatingEntryDecoration = BoxDecoration(
  borderRadius: Corners.smBorderRadius,
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      spreadRadius: 1,
      offset: const Offset(0, 2),
    ),
  ],
);
