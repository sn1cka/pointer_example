import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizon_pointer/overlay_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OverlayScreen(
          child: Scaffold(
            appBar: AppBar(),
        body: Row(
          children: [
            SizedBox(
              height: 400,
              width: 400,
              child: ElevatedButton(
                child: Text('Test'),
                onPressed: () => print('test'),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
