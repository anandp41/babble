import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/contacts_repository.dart';

final getContactsProvider = FutureProvider((ref) async {
  final contactsRepository = ref.watch(selectContactControllerProvider);
  return await contactsRepository.getContacts();
});
final savedContactsOnBabbleProvider = FutureProvider((ref) async {
  final contactsRepository = ref.watch(selectContactControllerProvider);
  return await contactsRepository.savedContactsOnBabble();
});
final selectContactControllerProvider = Provider((ref) {
  final contactsRepository = ref.watch(contactsRepositoryProvider);
  return SelectContactController(
      ref: ref, contactsRepository: contactsRepository);
});

class SelectContactController {
  final ProviderRef ref;
  final ContactsRepository contactsRepository;
  SelectContactController(
      {required this.ref, required this.contactsRepository});

  Future<List<Contact>> getContacts() async =>
      await contactsRepository.getContacts();

  Future<String> ifSavedContactName(
          {required String phoneNumberFromServerToCheck}) async =>
      await contactsRepository.ifSavedContactName(
          phoneNumberFromServerToCheck: phoneNumberFromServerToCheck);

  Future<List<Map<String, String>>> savedContactsOnBabble() async =>
      await contactsRepository.savedContactsOnBabble();

  Future<void> updateSavedContactsListToServe({required WidgetRef ref}) async =>
      await contactsRepository.updateSavedContactsListToServer(ref: ref);
}
