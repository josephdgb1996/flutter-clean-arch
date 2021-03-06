import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:provider/provider.dart';

import 'injection_container.dart' as di;
import 'layers/domain/usecases/get_all_characters.dart';
import 'layers/presentation/home_with_provider/notifiers/home_notifier.dart';
import 'layers/presentation/home_with_state_notifier/state/home_state.dart'
    as stateNotifier;
import 'layers/presentation/home_with_state_notifier/state/home_state_notifier.dart';
import 'layers/presentation/main_page.dart';

void main() async {
  // Plug in stetho
  if (kDebugMode) Stetho.initialize();

  // Initialize the injection container
  await di.init();

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // * USED by the plain Provider version
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeNotifier>(
          create: (_) => di.sl<HomeNotifier>(),
        ),
        StateNotifierProvider<HomeStateNotifier, stateNotifier.HomeState>(
          create: (_) =>
              HomeStateNotifier(getAllCharacters: di.sl<GetAllCharacters>()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainPage(),
      ),
    );
  }
}
