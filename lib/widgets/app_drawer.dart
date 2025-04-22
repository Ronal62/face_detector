import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Menu')),
          ListTile(
            title: Text('Home'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            title: Text('Add Face'),
            onTap: () => Navigator.pushReplacementNamed(context, '/add'),
          ),
          ListTile(
            title: Text('Detector'),
            onTap: () => Navigator.pushReplacementNamed(context, '/detect'),
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Face Data'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/data');
            },
          ),
        ],
      ),
    );
  }
}
