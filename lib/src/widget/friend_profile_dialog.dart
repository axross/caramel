import 'package:caramel/domains.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';

class FriendProfileDialog extends StatelessWidget {
  const FriendProfileDialog({
    @required this.hero,
    @required this.friendship,
    Key key,
  })  : assert(hero != null),
        assert(friendship != null),
        super(key: key);

  final SignedInUser hero;
  final Friendship friendship;

  @override
  Widget build(BuildContext context) => Consumer<FriendshipDeleteUsecase>(
        builder: (context, deleteFriendship) => FutureBuilder<User>(
              future: friendship.user,
              initialData: friendship.user.value,
              builder: (context, snapshot) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 320,
                          height: 180,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Colors.green),
                          child: Stack(
                            children: [
                              Align(
                                alignment: const Alignment(0, 2.1),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  child: snapshot.hasData
                                      ? CircleAvatar(
                                          backgroundImage: FirebaseStorageImage(
                                            snapshot.requireData.imageUrl
                                                .toString(),
                                          ),
                                        )
                                      : CircleAvatar(),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: PopupMenuButton(
                                    itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 0,
                                            child: Text('Delete'),
                                          ),
                                        ],
                                    onSelected: (_) {
                                      deleteFriendship(
                                        hero: hero,
                                        friendship: friendship,
                                      );

                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.more_vert),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 56, left: 24, right: 24),
                          child: Column(
                            children: [
                              Text(
                                  snapshot.hasData
                                      ? snapshot.requireData.name
                                      : 'Loading...',
                                  style: Theme.of(context).textTheme.headline),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 24),
                    actions: [
                      FlatButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
            ),
      );
}
