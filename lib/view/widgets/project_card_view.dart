import 'package:flutter/material.dart';

class ProjectCardView extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProjectCardView({super.key, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the card
        borderRadius: BorderRadius.circular(16.0), // Rounded corners
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Shadow color
            spreadRadius: 2, // How much the shadow spreads
            blurRadius: 8, // Softness of the shadow
            offset: const Offset(0, 4), // Offset of the shadow (x, y)
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFFE4F7F7),
          child: Text(title[0], style: TextStyle(color: Color(0xFF00C2AE))),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}