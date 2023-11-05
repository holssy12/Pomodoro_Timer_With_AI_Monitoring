import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

class MyCameraSession extends StatefulWidget {
  final String breakTime;
  final String workTime;
  final String workSessions;
  const MyCameraSession(
      {Key? key,
      required this.breakTime,
      required this.workTime,
      required this.workSessions})
      : super(key: key);

  @override
  State<MyCameraSession> createState() => _MyCameraSessionState();
}

class _MyCameraSessionState extends State<MyCameraSession>
    with WidgetsBindingObserver {
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  bool? predicting;
  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);
    // 새로운 Isolate를 생성
    // 카메라 초기화
    initializeCamera();
  }

  void initializeCamera() async {
    cameras = await availableCameras();
    // cameras[1]은 후면 카메라
    cameraController =
        CameraController(cameras![1], ResolutionPreset.low, enableAudio: false);
    cameraController?.initialize().then((_) async {
      // onLatestImageAvailable 함수를 전달하여 각 프레임에 대한 인식을 수행
      await cameraController?.startImageStream(onLatestImageAvailable);
      // 현재 카메라의 미리보기의 크기
    });
  }

  onLatestImageAvailable(CameraImage cameraImage) async {
    if (predicting ?? false) {
      return;
    }
    setState(() {
      // 이전 추론 완료
      predicting = true;
    });

    // print(cameraImage.height);
    Uint8List uint8list = cameraImage.planes[0].bytes;
    // Uint8List uint8list2 = cameraImage.planes[1].bytes;
    // Uint8List uint8list3 = cameraImage.planes[2].bytes;
    print(uint8list); // 76800
    // print(uint8list2.length); //38399
    // print(uint8list3.length); // 38399

    setState(() {
      predicting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1 / cameraController!.value.aspectRatio,
            child: CameraPreview(cameraController!),
          ),
          MyTimer(
              breakTime: widget.breakTime,
              workTime: widget.workTime,
              workSessions: widget.workSessions)
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      // 앱이 일시 중지되면 카메라 컨트롤러의 이미지 스트림 중지
      case AppLifecycleState.paused:
        cameraController?.stopImageStream();
        break;
      // 앱이 재개되면 카메라 컨트롤러의 이미지 스트림을 다시 시작
      case AppLifecycleState.resumed:
        if (!cameraController!.value.isStreamingImages) {
          await cameraController?.startImageStream(onLatestImageAvailable);
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }
}

class MyTimer extends StatefulWidget {
  final String breakTime;
  final String workTime;
  final String workSessions;

  const MyTimer(
      {Key? key,
      required this.breakTime,
      required this.workTime,
      required this.workSessions})
      : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<MyTimer> {
  bool _isRunning = false;
  Duration _time = const Duration(minutes: 60);
  Duration _break = const Duration(minutes: 10);
  int _timeInt = 60;
  int _counter = 1;
  int _sessionCount = 4;
  int _timerCount = 0;
  int _currMax = 60;
  Timer? _timer;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.breakTime == '0') {
        throw Exception('휴식 시간은 0분보다 커야합니다');
      }
      _timeInt = int.parse(widget.workTime);
      _time = Duration(minutes: _timeInt);
      _break = Duration(minutes: int.parse(widget.breakTime));
      _sessionCount = int.parse(widget.workSessions);
      _currMax = _timeInt;
    } catch (e) {
      _timeInt = 60;
      _time = Duration(minutes: _timeInt);
      _break = const Duration(minutes: 10);
      _sessionCount = 4;
      AnimatedSnackBar(
        builder: ((context) {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.redAccent,
            height: 65,
            child: Flex(
              direction: Axis.vertical,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.close,
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      '잘못된 입력입니다!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    SizedBox(
                        width:
                            50), // Add some horizontal spacing to align the text with the first message
                    Text(
                      "(올바른 분을 입력해주세요)",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ).show(context);
      Navigator.pop(context);
    }
    _getPrefs();
  }
  ////

  void _getPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _storeTime() async {
    String? curr = '';
    curr = _prefs?.getString('time');
    var now = new DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    String formattedDate = "${date.day}-${date.month}-${date.year}";
    await _prefs!.setString(
        'time', '$curr / ${_sessionCount * _timeInt} $formattedDate');
  }

  Future<void> _resetTime() async {
    await _prefs!.setString('time', '');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _time = _time - const Duration(seconds: 1);
        if (_time.inSeconds <= 0) {
          if (_timerCount % 2 == 1) {
            _time = Duration(minutes: _timeInt);
            _currMax = _timeInt;
            _timerCount++;
          } else {
            _time = _break;
            _currMax = _break.inMinutes;
            _counter++;
            _timerCount++;
          }
          if (_counter > _sessionCount) {
            AnimatedSnackBar(
              builder: ((context) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.greenAccent,
                  height: 65,
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle_outline,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            '집중시간이 끝났습니다!',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                              width:
                                  50), // Add some horizontal spacing to align the text with the first message
                          Text(
                            '${_sessionCount * _timeInt}분 동안 집중하셨습니다.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ).show(context);
            FocusManager.instance.primaryFocus?.unfocus();
            _storeTime();
            Navigator.pop(context);
          }

          _stopTimer();
          _isRunning = false;
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      if (_isRunning) {
        _stopTimer();
      }
      _time = const Duration(minutes: 60);
      if (_timerCount % 2 == 1) {
        _time = Duration(minutes: _break.inMinutes);
      } else {
        _time = Duration(minutes: _timeInt);
      }
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int minutes = _time.inMinutes;
    final int seconds = _time.inSeconds % 60;
    String timerState = "휴식";
    if (_timerCount % 2 == 0) {
      timerState = '$_counter / $_sessionCount';
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.black,
        title: Text.rich(
          TextSpan(
            text: '집중 중', // text for title
            style: TextStyle(
              fontSize: 24,
              color: Colors.greenAccent,
              fontFamily: 'Arial',
            ),
          ),
        ),

        // Create a button to pause/resume the timer
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20.0),
            icon: const Icon(Icons.restart_alt,
                color: Colors.greenAccent, size: 30),
            onPressed: () {
              setState(() {
                _resetTimer();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                        backgroundColor: Color.fromARGB(255, 212, 82, 82),
                        value: _time.inSeconds /
                            (_currMax *
                                60), // calculates the progress as a value between 0 and 1
                        strokeWidth: 2,
                      ),
                    )),
                Positioned(
                  top: 33,
                  left: 25,
                  child: Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.greenAccent,
                      fontFamily: 'Arial',
                    ),
                  ),
                ),
                Positioned(
                  bottom: 33,
                  left: 40,
                  child: Text(
                    timerState,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.greenAccent,
                      fontFamily: 'Arial',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_isRunning) {
              _stopTimer();
            } else {
              _startTimer();
            }
            _isRunning = !_isRunning;
          });
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        mini: false,
        child: _isRunning
            ? const Icon(Icons.pause, color: Colors.greenAccent)
            : const Icon(Icons.play_arrow, color: Colors.greenAccent),
      ),
    );
  }
}
