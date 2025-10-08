import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Helpline extends Equatable {
  final String number;
  final String name;
  final IconData icon;
  final Color color;

  const Helpline({
    required this.number,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [number, name, icon, color];
}
