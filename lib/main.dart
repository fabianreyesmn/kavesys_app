
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './services/app_state_service.dart';
import './screens/client_view.dart';
import './screens/home_screen.dart' as home_screen;
import './screens/login_screen.dart';
import './screens/main_layout.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KaveSys',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'sans-serif',
        ),
        home: Consumer<AppStateService>(
          builder: (context, appState, child) {
            if (appState.isClientView) {
              return ClientView(onExit: appState.exitClientView);
            } else if (appState.user != null) {
              return const MainLayout();
            } else if (appState.showHome) {
              return home_screen.HomeScreen(
                onProductsNavigator: appState.viewAsClient,
                onLoginNavigator: appState.goToLogin,
              );
            } else {
              return LoginScreen(
                onClientView: appState.viewAsClient,
                onLogin: (email, pass) => appState.login(email, pass),
                onBack: appState.goToHome,
              );
            }
          },
        ),
      ),
    );
  }
}
