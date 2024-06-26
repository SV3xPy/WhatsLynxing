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
import 'package:whatslynxing/models/group.dart';
import 'package:whatslynxing/models/user_model.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el usuario actual
    final userDataAsyncValue = ref.watch(userDataAuthProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Grupos AQUI HAY ERROR NOOOOO
            StreamBuilder<List<Group>>(
                stream: ref.watch(chatControllerProvider).chatGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var groupData = snapshot.data![index];
                      DateTime currentDate = DateTime.now();
                      String formattedTime = '';
                      if (groupData.timeSent.year == currentDate.year &&
                          groupData.timeSent.month == currentDate.month &&
                          groupData.timeSent.day == currentDate.day) {
                        // Si es el día actual, muestra solo la hora
                        formattedTime =
                            DateFormat.Hm().format(groupData.timeSent);
                      } else {
                        // Si no es el día actual, muestra la fecha completa
                        formattedTime =
                            DateFormat('dd/MM/yy').format(groupData.timeSent);
                      }
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MobileChatScreen.routeName,
                                arguments: {
                                  'name': groupData.name,
                                  'uid': groupData.groupId,
                                  'isGroupChat': true,
                                  'profilePic': groupData.groupPic,
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  groupData.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    groupData.lastMessage,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    groupData.groupPic,
                                  ),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  formattedTime,
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
            //CHATS
            StreamBuilder<List<ChatContact>>(
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
                      DateTime currentDate = DateTime.now();
                      String formattedTime = '';
                      if (chatContactData.timeSent.year == currentDate.year &&
                          chatContactData.timeSent.month == currentDate.month &&
                          chatContactData.timeSent.day == currentDate.day) {
                        // Si es el día actual, muestra solo la hora
                        formattedTime =
                            DateFormat.Hm().format(chatContactData.timeSent);
                      } else {
                        // Si no es el día actual, muestra la fecha completa
                        formattedTime =
                            DateFormat('dd/MM/yy').format(chatContactData.timeSent);
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
                                  'isGroupChat': false,
                                  'profilePic': chatContactData.profilePic,
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
                                  formattedTime,
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
          ],
        ),
      ),
    );
  }
}
