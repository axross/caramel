import 'package:flutter/material.dart';
import '../component/authenticated_screen.dart';
import '../component/friend_code_dialog.dart';
import '../component/friend_list.dart';
import '../component/user_drawer_header.dart';

class FriendListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticatedScreen(
      builder: (context, user) => Scaffold(
            appBar: AppBar(
              title: Text('Friends'),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => FriendCodeDialog(),
                    );
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  UserDrawerHeader(),
                  ListTile(
                    title: Text('Item 1'),
                    onTap: () {
                      print('item 1');
                    },
                  ),
                ],
              ),
            ),
            body: FriendList(user: user),
          ),
    );
  }
}
