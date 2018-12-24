import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';

class FriendListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticatedScreen(
      builder: (context, user) => DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: Text('Friends'),
                  actions: [
                    IconButton(
                      icon: Icon(CustomIcons.qr),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => FriendCodeDialog(user: user),
                        );
                      },
                    ),
                  ],
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.face),
                        text: 'Friends',
                      ),
                      Tab(
                        icon: Icon(Icons.chat),
                        text: 'Chats',
                      ),
                    ],
                  ),
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
                body: TabBarView(
                  children: [
                    FriendList(
                        user: user,
                        onItemTapped: (friendship) => print(friendship)),
                    Container(),
                  ],
                )),
          ),
    );
  }
}
