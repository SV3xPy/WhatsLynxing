// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/contact.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whatslynxing/common/widgets/error.dart';
// import 'package:whatslynxing/common/widgets/loader.dart';
// import 'package:whatslynxing/features/auth/controller/auth_controller.dart';
// import 'package:whatslynxing/features/select_contacts/controller/select_contact_controller.dart';
// import 'package:whatslynxing/features/select_contacts/repository/select_contact_repository.dart';
// import 'package:whatslynxing/features/select_contacts/screens/contact_search.dart';
// import 'package:whatslynxing/models/user_model.dart';
// import 'package:whatslynxing/features/chat/widgets/contacts_list.dart';

// class SelectContactsScreen extends ConsumerWidget {
//   static const String routeName = '/select-contact';
//   const SelectContactsScreen({super.key});

//   // void selectContact(
//   //     WidgetRef ref, Contact selectedContact, BuildContext context) {
//   //   ref
//   //       .read(selectContactsRepositoryProvider)
//   //       .selectContact(selectedContact, context);
//   // }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final usersAsyncValue = ref.watch(getUsersProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Seleccionar contacto"),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               final List<UserModel> users = usersAsyncValue.asData!.value;
//               print("Lista de usuarios: $users");
//               // final searchTerm = await showSearch(
//               //   context: context,
//               //   delegate: ContactSearchDelegate(
//               //     users: users,
//               //   ),
//               // );
//               showSearch(
//                 context: context,
//                 delegate: ContactSearchDelegate(
//                   users: users,
//                 ),
//               );
//               // if (searchTerm != null) {
//               //   ref
//               //       .read(selectUsersRepositoryProvider)
//               //       .searchUsers(searchTerm, context);
//               // }
//             },
//             icon: const Icon(Icons.search),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.more_vert),
//           ),
//         ],
//       ),
//       // body: ref.watch(getContactsProvider).when(
//       //       data: (contactList) => ListView.builder(
//       //         itemCount: contactList.length,
//       //         itemBuilder: (context, index) {
//       //           final contact = contactList[index];
//       //           return InkWell(
//       //             onTap: () => selectContact(ref, contact, context),
//       //             child: Padding(
//       //               padding: const EdgeInsets.only(bottom: 8.0),
//       //               child: ListTile(
//       //                 title: Text(
//       //                   contact.displayName,
//       //                   style: const TextStyle(fontSize: 18),
//       //                 ),
//       //                 leading: contact.photo == null
//       //                     ? null
//       //                     : CircleAvatar(
//       //                         backgroundImage: MemoryImage(
//       //                           contact.photo!,
//       //                         ),
//       //                         radius: 30,
//       //                       ),
//       //               ),
//       //             ),
//       //           );
//       //         },
//       //       ),
//       //       error: (err, trace) => ErrorScreen(error: err.toString()),
//       //       loading: () => const Loader(),
//       //     ),
//     );
//   }
// }
