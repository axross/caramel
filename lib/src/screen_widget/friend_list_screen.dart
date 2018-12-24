import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';
import './chat_message_list_screen.dart';

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
                      builder: (_) => FriendCodeDialog(user: user),
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
            body: FriendList(
              user: user,
              onItemTapped: (friendship) =>
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChatMessageListScreen(
                          chatReference: friendship.chat,
                        ),
                  )),
            ),
          ),
    );
  }
}
