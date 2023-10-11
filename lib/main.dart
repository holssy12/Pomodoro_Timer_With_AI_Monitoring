import 'package:flutter/material.dart';
import 'homepage.dart';

// --------------------------------
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  //const MyApp(({Key? key}) : super(key: key);
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) {
          final mediaQueryData = MediaQuery.of(context);
          final screenWidth = 250.0;
          final screenHeight = 400.0;
          return MediaQuery(
            data: mediaQueryData.copyWith(
              size: Size(screenWidth, screenHeight),
              devicePixelRatio: mediaQueryData.devicePixelRatio,
            ),
            child: Container(
              width: screenWidth,
              height: screenHeight,
              child:
                  HomePage(), // 2023.10.06, LJK  landingpage 삭제//및 landing.dart 삭제 homepage class로의 연결
            ),
          );
        },
      ),
    );
  }
}
