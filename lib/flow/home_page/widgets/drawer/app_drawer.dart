import 'package:flutter/material.dart';
import 'package:whatsapp_status_saver/util/app_data.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset(AppData.logo),
          ),
          const ListTile(
            leading: Icon(Icons.light_mode),
            title: Text('Light Mode'),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Languages'),
          ),
          const ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
          ),
          const ListTile(
            leading: Icon(Icons.document_scanner),
            title: Text('Terms & Conditions'),
          ),
          const ListTile(
            leading: Icon(Icons.star),
            title: Text('Rate Us'),
          ),
        ],
      ),
    );
  }
}
