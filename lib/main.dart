import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider_api_demo/ui/home_page.dart';
import 'core/view_model/home_viewmodel.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
            primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<HomeViewModel>(create: (_) => HomeViewModel()),

];
