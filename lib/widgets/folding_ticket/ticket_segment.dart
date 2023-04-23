import 'package:flutter/material.dart';

abstract class TicketSegment extends Widget{
  const TicketSegment({super.key});

  Size get preferredSize;
}