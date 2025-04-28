import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            leading: Icon(Icons.add_a_photo),
            title: Text('Add Face'),
            onTap: () => Navigator.pushReplacementNamed(context, '/add'),
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Detector'),
            onTap: () => Navigator.pushReplacementNamed(context, '/detect'),
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Face Data'),
            onTap: () => Navigator.pushReplacementNamed(context, '/data'),
          ),
        ],
      ),
    );
  }
}
