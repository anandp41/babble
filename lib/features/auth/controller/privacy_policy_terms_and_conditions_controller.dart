import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/privacy_policy_terms_and_conditions_repository.dart';

final privacyPolicyTermsAndConditionsControllerProvider =
    FutureProvider((ref) async {
  final privacyPolicyTermsAndConditionsController =
      ref.watch(pPTCDataControllerProvider);
  return await privacyPolicyTermsAndConditionsController.getData();
});
final pPTCDataControllerProvider = Provider((ref) {
  final ppTcRepository = ref.watch(privacyPolicyTermsAndConditionsProvider);
  return PrivacyPolicyTermsAndConditionsController(
    privacyPolicyTermsAndConditionsRepository: ppTcRepository,
  );
});

class PrivacyPolicyTermsAndConditionsController {
  final PrivacyPolicyTermsAndConditionsRepository
      privacyPolicyTermsAndConditionsRepository;
  PrivacyPolicyTermsAndConditionsController({
    required this.privacyPolicyTermsAndConditionsRepository,
  });

  Future<Map<String, String>> getData() async {
    return await privacyPolicyTermsAndConditionsRepository.getData();
  }
}
