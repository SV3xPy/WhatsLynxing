import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatslynxing/features/auth/controller/auth_controller.dart';
import 'package:whatslynxing/features/auth/repository/auth_repository.dart';
import 'package:whatslynxing/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatslynxing/features/select_contacts/repository/select_contact_repository.dart';
import 'package:whatslynxing/models/user_model.dart';
import 'package:whatslynxing/features/chat/screens/mobile_chat_screen.dart';

class ContactSearchDelegate extends SearchDelegate<String> {
  final List<UserModel> users;

  List<UserModel> _filter = [];

  ContactSearchDelegate({
    required this.users,
  });

  @override
  String get searchFieldLabel => "Buscar usuario";

  @override
  Widget buildSuggestions(BuildContext context) {
    _filter = users.where((user) {
      return user.email.contains(query) ||
          user.name.toLowerCase().contains(query);
    }).toList();
    // // Aquí puedes mostrar sugerencias de búsqueda mientras el usuario escribe.
    // return Container();
    // return FutureBuilder<List<UserModel>>(
    //   future: ref.watch(getUsersProvider(currentUserId)).future,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else if (snapshot.hasError) {
    //       return const Center(
    //         child: Text("Ocurrió un error inesperado"),
    //       );
    //     } else {
    //       final List<UserModel> users = snapshot.data ?? [];
    //       return ListView.builder(
    //         itemCount: users.length,
    //         itemBuilder: (context, index) {
    //           final user = users[index];
    //           return ListTile(
    //             title: Text(
    //               user.name,
    //               style: const TextStyle(fontSize: 18),
    //             ),
    //             leading: CircleAvatar(
    //               backgroundImage: NetworkImage(
    //                 user.profilePic,
    //               ),
    //               radius: 30,
    //             ),
    //             subtitle: Text(
    //               user.email, // Aplica el estilo directamente aquí
    //             ),
    //           );
    //         },
    //       );
    //     }
    //   },
    // );
    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (context, index) {
        final user = _filter[index];
        return InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': user.name,
              'uid': user.uid,
            },
          ),
          child: ListTile(
            title: Text(user.name, style: const TextStyle(fontSize: 18)),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 30,
            ),
            subtitle: Text(user.email),
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Aquí puedes mostrar los resultados de la búsqueda.
    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (context, index) {
        final user = _filter[index];
        return InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': user.name,
              'uid': user.uid,
            },
          ),
          child: ListTile(
            title: Text(user.name, style: const TextStyle(fontSize: 18)),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 30,
            ),
            subtitle: Text(user.email),
          ),
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
          buildSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, "");
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
}
