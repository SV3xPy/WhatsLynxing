import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatslynxing/colors.dart';
import 'package:whatslynxing/common/utils/utils.dart';
import 'package:whatslynxing/features/auth/controller/auth_controller.dart';
import 'package:whatslynxing/features/auth/screens/login_screen.dart';
import 'package:whatslynxing/features/group/screens/create_group_screen.dart';
import 'package:whatslynxing/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatslynxing/features/select_contacts/screens/contact_search.dart';
import 'package:whatslynxing/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatslynxing/features/chat/widgets/contacts_list.dart';
import 'package:whatslynxing/features/status/screens/confirm_status_screen.dart';
import 'package:whatslynxing/features/status/screens/status_users_screen.dart';
import 'package:whatslynxing/models/user_model.dart';

enum Options { ajustes, logout, grupo }

class MobileLayoutScreen extends ConsumerStatefulWidget {
  static const routeName = '/chats';
  const MobileLayoutScreen({super.key});

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  var _popupMenuItemIndex = 0;
  late TabController tabBarController;

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.grey,
          ),
          Text(title),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value) {
    setState(() {
      _popupMenuItemIndex = value;
    });

    if (value == Options.ajustes.index) {
    } else if (value == Options.logout.index) {
      ref.read(authControllerProvider).signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } else if (value == Options.grupo.index) {
      Navigator.pushNamed(context, CreateGroupScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsyncValue = ref.watch(getUsersProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'WhatsLynxing',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              onSelected: (value) {
                _onMenuItemSelected(value as int);
              },
              itemBuilder: (context) => [
                _buildPopupMenuItem(
                    "Ajustes", Icons.settings, Options.ajustes.index),
                _buildPopupMenuItem(
                    "Crear Grupo", Icons.group, Options.grupo.index),
                _buildPopupMenuItem(
                    "Cerrar sesión", Icons.logout, Options.logout.index),
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'Chats',
              ),
              Tab(
                text: 'Estados',
              ),
              Tab(
                text: 'Llamadas',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: const [
            ContactsList(),
            StatusUsersScreen(),
            Text("Calls"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabBarController.index == 0) {
              final List<UserModel> users = usersAsyncValue.asData!.value;
              showSearch(
                context: context,
                delegate: ContactSearchDelegate(
                  users: users,
                ),
              );
            } else {
              File? pickedImage = await pickImageGallery(context);
              if (pickedImage != null) {
                Navigator.pushNamed(
                  context,
                  ConfirmStatusScreen.routeName,
                  arguments: pickedImage,
                );
              }
            }
            //Navigator.pushNamed(context, SelectContactsScreen.routeName);
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
