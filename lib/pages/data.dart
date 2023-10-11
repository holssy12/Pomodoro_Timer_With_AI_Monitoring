import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DataState();
  }
}

class _DataState extends State<Data> {
  SharedPreferences? _prefs;
  String _data = '';
  late Map<int, String> _sessions;
  List<String> _dates = [];
  List<String> _sesh = [];
  int _totalMin = 0;
  int _longestSesh = 0;
  int _seshNum = 0;
  double _avgSesh = 0;

  @override
  void initState() {
    super.initState();
    _getPrefs();
  }

  Future<void> _resetTime() async {
    await _prefs!.setString('time', '');
  }

  void _getPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _data = _prefs!.getString('time')!;
      final split = _data.split('/');

      _sessions = {for (int i = 0; i < split.length; i++) i: split[i]};
      for (int i = 1; i < _sessions.length; i++) {
        _dates.add(_sessions[i]!.split(' ')[2]);
      }
      for (int i = 1; i < _sessions.length; i++) {
        _sesh.add(_sessions[i]!.split(' ')[1]);
        _totalMin += int.parse(_sessions[i]!.split(' ')[1]);
        _seshNum++;
        if (int.parse(_sessions[i]!.split(' ')[1]) > _longestSesh) {
          _longestSesh = int.parse(_sessions[i]!.split(' ')[1]);
        }
      }
      _avgSesh = _totalMin / _seshNum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        // padding: const EdgeInsets.all(20.0),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            backgroundColor: Colors.black,
            title: const Text.rich(
              TextSpan(
                text: '기록', // text for title
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.greenAccent,
                  fontFamily: 'Arial',
                ),
              ),
            )),
        body: Container(
            width: 600,
            height: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: GridView(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 0,
                    ),
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.black,
                        shadowColor: Colors.greenAccent,
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.access_time_filled_outlined,
                                color: Colors.greenAccent,
                                size: 50,
                              ),
                              Text(_totalMin.toString(),
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Arial')),
                              Text('집중한 시간',
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 12,
                                      fontFamily: 'Arial',
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.black,
                        shadowColor: Colors.greenAccent,
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: Colors.greenAccent,
                                size: 50,
                              ),
                              Text(_longestSesh.toString(),
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Arial')),
                              Text('가장 긴 집중시간',
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 12,
                                      fontFamily: 'Arial',
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.black,
                        shadowColor: Colors.greenAccent,
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.greenAccent,
                                size: 50,
                              ),
                              Text(_seshNum.toString(),
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Arial')),
                              Text('집중한 횟수',
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 12,
                                      fontFamily: 'Arial',
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.black,
                        shadowColor: Colors.greenAccent,
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.bar_chart_rounded,
                                color: Colors.greenAccent,
                                size: 50,
                              ),
                              Text(
                                  double.parse((_avgSesh).toStringAsFixed(2))
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Arial')),
                              Text('평균 집중 시간',
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 12,
                                      fontFamily: 'Arial',
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
