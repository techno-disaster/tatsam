import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tatsam/constants.dart';
import 'package:tatsam/screens/countries.dart';

import 'countries/models/country.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Bloc.observer = SimpleBlocObserver();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(CountryAdapter());
  Hive.openBox(favoritesBox);
  runApp(MyApp());
  
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CountryPage(),
    );
  }
  
}

// Logs events and states during transition
class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}
