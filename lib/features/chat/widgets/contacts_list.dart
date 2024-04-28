import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatslynxing/colors.dart';
import 'package:whatslynxing/common/widgets/loader.dart';
import 'package:whatslynxing/features/chat/controller/chat_controller.dart';
//import 'package:whatslynxing/info.dart';
import 'package:whatslynxing/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatslynxing/models/chat_contact.dart';
import 'package:whatslynxing/features/auth/controller/auth_controller.dart';
import 'package:whatslynxing/models/user_model.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el usuario actual
    final userDataAsyncValue = ref.watch(userDataAuthProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chatContactData = snapshot.data![index];
                var name = chatContactData.name;
                UserModel? user = userDataAsyncValue.value;
                if (user?.name == chatContactData.name) {
                  name = '${chatContactData.name} (Tú)';
                }

                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MobileChatScreen.routeName,
                          arguments: {
                            'name': chatContactData.name,
                            'uid': chatContactData.contacId,
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              chatContactData.lastMessage,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              chatContactData.profilePic,
                            ),
                            radius: 30,
                          ),
                          trailing: Text(
                            DateFormat.Hm().format(chatContactData.timeSent),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: dividerColor, indent: 85),
                  ],
                );
              },
            );
          }),
    );
  }
}
