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
          title: Text(
            name,
            style: h4.copyWith(
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          leading: Icon(
            icon,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        if (isActive)
          Positioned(
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              color: primaryColor,
            ),
          )
      ],
    );
  }
}
