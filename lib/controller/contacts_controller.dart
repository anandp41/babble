import 'package:babble/repositories/contacts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getContactsProvider = FutureProvider((ref) {
  final contactsRepository = ref.watch(contactsRepositoryProvider);
  return contactsRepository.getContacts();
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
