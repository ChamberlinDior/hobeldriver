import 'package:flutter/material.dart';

import '../services/firebase_services/firebase_collections.dart';

class TermsProvider extends ChangeNotifier {
  bool load = false;

  showLoading() {
    load = true;
    notifyListeners();
  }

  hideLoading() {
    load = false;
    notifyListeners();
  }

  String terms = '';

  getTerms() async {
    showLoading();
    try {
      var snapshots = await FirebaseCollections.adminSettingsCollection
          .doc('privacy')
          .get();
      terms = (snapshots.data() as Map)['en'];
    } catch (e) {}
    hideLoading();
  }
}
