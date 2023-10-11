import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'timer.dart';

class Habit extends StatelessWidget {
  const Habit({super.key});

  @override
  Widget build(BuildContext context) {
    Color col = Colors.greenAccent;
    final TextEditingController _workController = TextEditingController();
    final TextEditingController _breakController = TextEditingController();
    final TextEditingController _sessionController = TextEditingController();

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: false,
                backgroundColor: Colors.black,
                title: Text.rich(
                  TextSpan(
                    text: '집중을 시작하세요', // text for title
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.greenAccent,
                      fontFamily: 'Arial',
                    ),
                  ),
                )),
            body: SingleChildScrollView(
                child: (Container(
              width: double.infinity,
              color: Colors.black38,
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "집중할 시간",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'Arial',
                    ),
                  ),
                  SizedBox(
                      height:
                          10), // add a space between the text and the input field
                  TextField(
                    controller: _workController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontFamily: 'Arial',
                    ),
                    keyboardType:
                        TextInputType.number, // set the keyboard type to number
                    keyboardAppearance: Brightness.dark,
                    decoration: const InputDecoration(
                      // filled: true,
                      fillColor: Colors.black12,
                      labelText: '(분 단위로 적어주세요)',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          borderSide: BorderSide(color: Colors.white10)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          borderSide: BorderSide(color: Colors.white10)),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "휴식할 시간",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'Arial',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _breakController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontFamily: 'Arial',
                    ),
                    keyboardType:
                        TextInputType.number, // set the keyboard type to number
                    keyboardAppearance: Brightness.dark,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      labelText: '(분 단위로 적어주세요)',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          borderSide: BorderSide(color: Colors.white10)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          borderSide: BorderSide(color: Colors.white10)),
                    ),
                  ),
                  const SizedBox(
                      height:
                          25), // add a space between the text and the input field
                  const Text(
                    "횟수",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'Arial',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _sessionController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontFamily: 'Arial',
                    ),
                    keyboardType:
                        TextInputType.number, // set the keyboard type to number
                    keyboardAppearance: Brightness.dark,
                    decoration: const InputDecoration(
                      // filled: true,
                      fillColor: Colors.black12,
                      labelText: '(횟수를 적어주세요)',
                      labelStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          borderSide: BorderSide(color: Colors.white10)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          borderSide: BorderSide(color: Colors.white10)),
                    ),
                  ),
                  SizedBox(
                      height:
                          80), // add a space between the text and the input field
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(seconds: 1),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return FadeTransition(
                            opacity: animation,
                            child: MyCameraSession(
                              breakTime: _breakController.text,
                              workTime: _workController.text,
                              workSessions: _sessionController.text,
                            ),
                          );
                        },
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        padding: EdgeInsets.zero,
                        minimumSize: Size(150, 50),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.black12, width: 2.0),
                        )),
                    child: const Text(
                      "집중 시작",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ),
                ],
              ),
            )))));
  }
}
