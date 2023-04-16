import 'package:flutter/material.dart';
import 'package:takos_korner/utils/colors.dart';

class IngrediantScreen extends StatefulWidget {
  const IngrediantScreen({super.key});
  static const routeName = "/IngrediantScreen";
  @override
  State<IngrediantScreen> createState() => _IngrediantScreenState();
}

class _IngrediantScreenState extends State<IngrediantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
    );
  }
}