import 'dart:ffi';

import 'package:flutter/material.dart';

class ServiceModel {
  final String title;
  final IconData icon;
  final String? svgPath;
  final Color color;
  final Color? iconColor;
  final double? width;
  final bool hasDeliveryBadge;

  ServiceModel({
    required this.title,
    required this.icon,
    this.svgPath,
    this.width,
    required this.color,
    this.iconColor,
    this.hasDeliveryBadge = false,
  });
}
