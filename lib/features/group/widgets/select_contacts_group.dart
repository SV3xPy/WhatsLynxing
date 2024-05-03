import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatslynxing/common/widgets/error.dart';
import 'package:whatslynxing/common/widgets/loader.dart';
import 'package:whatslynxing/features/auth/controller/auth_controller.dart';
import 'package:whatslynxing/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatslynxing/models/user_model.dart';

final selectedGroupContacts = StateProvider<List<UserModel>>((ref) => []);
class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];
  void selectContact(int index, UserModel contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref.read(selectedGroupContacts.state).update((state) => [...state,contact]);
  }

  @override
  Widget build(BuildContext context) {
    final userDataAsyncValue = ref.watch(userDataAuthProvider);
    UserModel? user = userDataAsyncValue.value;
    return ref.watch(getUsersProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                // Verificar si el nombre del contacto es diferente al nombre del usuario actual
                if (contact.name != user!.name) {
                  return InkWell(
                    onTap: () => selectContact(index, contact),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                          title: Text(
                            contact.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          leading: selectedContactsIndex.contains(index)
                              ? IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.done),
                                )
                              : null),
                    ),
                  );
                } else {
                  // Si el nombre del contacto es igual al del usuario actual, no mostrar nada
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          error: (err, trace) => ErrorScreen(
            error: err.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
