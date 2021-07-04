import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/models/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: Text(
            "Together",
            style: TextStyle(
              fontFamily: "Pacifico",
              color: Colors.white,
            ),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout_rounded),
          title: Text("Log Out"),
          onTap: () async {
            Navigator.of(context).pop();
            await Provider.of<Auth>(context, listen: false).logout();
          },
        )
      ],
    ));
  }
}
