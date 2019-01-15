import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:flutter/material.dart';
import './signed_in.dart';

class App extends StatefulWidget {
  const App({
    @required this.analytics,
    @required this.deviceService,
    @required this.notificationManager,
    @required this.userRepository,
    @required this.authenticate,
    @required this.listChat,
    @required this.participateChat,
    @required this.getFriendCode,
    @required this.createFriendship,
    @required this.listFriend,
    Key key,
  })  : assert(analytics != null),
        assert(deviceService != null),
        assert(notificationManager != null),
        assert(userRepository != null),
        assert(authenticate != null),
        assert(listChat != null),
        assert(participateChat != null),
        assert(getFriendCode != null),
        assert(createFriendship != null),
        assert(listFriend != null),
        super(key: key);

  final FirebaseAnalytics analytics;
  final DeviceService deviceService;
  final NotificationManager notificationManager;
  final UserRepository userRepository;
  final AuthenticateUsecase authenticate;
  final ChatListUsecase listChat;
  final ChatParticipateUsecase participateChat;
  final FriendCodeGetUsecase getFriendCode;
  final FriendshipCreateUsecase createFriendship;
  final FriendListUsecase listFriend;

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  StatefulStream<SignedInUser> _hero;

  @override
  void initState() {
    super.initState();

    _hero = widget.authenticate()
      ..listen((signedInUser) async {
        if (signedInUser == null) {
          return;
        }

        final deviceInformation = await widget.deviceService.deviceInformation;
        final pushNotificationDestinationId =
            await widget.notificationManager.pushNotificationDestinationId;

        await widget.userRepository.setDevice(
          hero: signedInUser,
          deviceInformation: deviceInformation,
          pushNotificationDestinationId: pushNotificationDestinationId,
        );
      });
  }

  @override
  Widget build(BuildContext context) => Provider(
        value: widget.listChat,
        child: Provider(
          value: widget.participateChat,
          child: Provider(
            value: widget.getFriendCode,
            child: Provider(
              value: widget.createFriendship,
              child: Provider(
                value: widget.listFriend,
                child: StreamBuilder<User>(
                  stream: _hero,
                  initialData: _hero.latest,
                  builder: (_, snapshot) => snapshot.hasData
                      ? SignedIn(
                          hero: snapshot.requireData,
                          analytics: widget.analytics,
                          notificationManager: widget.notificationManager,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(128),
                              child: Image.asset(
                                'assets/images/icon.png',
                                width: 256,
                                height: 256,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      );
}
