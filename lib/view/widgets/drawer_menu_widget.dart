import 'package:flutter/material.dart';
import 'package:snplay/constant.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key, required this.onTap, required this.name, required this.icon, required this.isActive});
  final void Function() onTap;
  final String name;
  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListTile(
          onTap: onTap,
          title: Text(name),
          leading: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        if (isActive)
          Positioned(
            top: 0,
            bottom: 0,
            child: Container(
              width: 5,
              color: primaryColor,
            ),
          )
      ],
    );
  }
}
