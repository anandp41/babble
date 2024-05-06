import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/strings.dart';

final privacyPolicyTermsAndConditionsProvider =
    Provider((ref) => PrivacyPolicyTermsAndConditionsRepository(
          firestore: FirebaseFirestore.instance,
        ));

class PrivacyPolicyTermsAndConditionsRepository {
  final FirebaseFirestore firestore;
  PrivacyPolicyTermsAndConditionsRepository({
    required this.firestore,
  });

  Future<Map<String, String>> getData() async {
    var privacyPolicyMap = await firestore
        .collection(firebasePPTCCollection)
        .doc(firebasePrivacyPolicyDocument)
        .get();
    var pPmap = Map.from(privacyPolicyMap.data()!);
    String privacyPolicy = pPmap[firebasePPTCCollectionHTMLfield];
    var termsAndConditionsMap = await firestore
        .collection(firebasePPTCCollection)
        .doc(firebaseTermsAndConditionsDocument)
        .get();
    var tCmap = Map.from(termsAndConditionsMap.data()!);
    String termsAndConditions = tCmap[firebasePPTCCollectionHTMLfield];
    return {
      firebasePrivacyPolicyDocument: privacyPolicy,
      firebaseTermsAndConditionsDocument: termsAndConditions
    };
  }
}
