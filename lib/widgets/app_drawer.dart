import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text("Welcome!", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text("app@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'), // Ganti dengan path gambar profil
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  text: 'Home',
                  routeName: '/home',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.add_a_photo,
                  text: 'Add Face',
                  routeName: '/add',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.camera_alt,
                  text: 'Detector',
                  routeName: '/detect',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.list_alt,
                  text: 'Face Data',
                  routeName: '/data',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String text,
        required String routeName,
      }) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context); // Menutup drawer sebelum navigasi
        Future.delayed(const Duration(milliseconds: 150), () {
          Navigator.pushReplacementNamed(context, routeName);
        });
      },
    );
  }
}
