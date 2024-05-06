import 'package:babble/features/select_contacts/repository/contacts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getContactsProvider = FutureProvider((ref) async {
  final contactsRepository = ref.watch(contactsRepositoryProvider);
  return await contactsRepository.getContacts();
});
final contactsOnBabbleProvider = FutureProvider((ref) async {
  final contactsRepository = ref.watch(contactsRepositoryProvider);
  return await contactsRepository.checkIfOnBabble();
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
}
