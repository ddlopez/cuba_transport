import 'package:flutter/foundation.dart';
import 'package:truck_reservas/models/user_model.dart';

export 'package:provider/provider.dart';

class OwnerProvider with ChangeNotifier {
  Owner _owner = Owner();

  Owner get owner => _owner;

  set owner(Owner owner) {
    _owner = owner;

    notifyListeners();
  }
}
