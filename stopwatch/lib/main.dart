import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void main() => runApp(MyHomePage());
class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _stopWatchTimer.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Stopwatch"),
          centerTitle: true,
          backgroundColor: Colors.white,

        ),
        body: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snapshot) {

                  final value = snapshot.data;
                  final displayTime = StopWatchTimer.getDisplayTime(value, hours: _isHours);
                  return Text(displayTime,
                      style: const TextStyle(
                          fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      )
                  );
                }
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    color: Colors.green,
                    label: "Start",
                    onPress: () {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                    },
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  CustomButton(
                    color: Colors.red,
                    label: "Stop",
                    onPress: () {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    },
                  ),
                ],
              ),
              CustomButton(
                color: Color(0xFFF15C2A),
                label: "Lap",
                onPress: () {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                },
              ),
              CustomButton(
                color: Colors.black,
                label: "Reset",
                onPress: () {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                },
              ),
              Container(
                height: 120,
                margin: const EdgeInsets.all(8),
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: _stopWatchTimer.records,
                  initialData: _stopWatchTimer.records.value,
                  builder: (context, snapshot)  {
                    final value = snapshot.data;
                    if(value.isEmpty){
                      return Container();
                    }
                    Future.delayed(const Duration(milliseconds: 100), (){
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut);
                    });
                    return ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          final data = value[index];
                          return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "${index + 1} - ${data.displayTime}",

                                  style: const TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold
                                  ),
                                ),
                          ),
                              ]);
                        },
                    itemCount: value.length,
                    );
                  },
                )
              )
            ],
          ),
        ),

      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color color;
  final Function onPress;
  final String label;
  CustomButton({this.color, this.onPress, this.label});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
        shape: const StadiumBorder(),
        onPressed: onPress,
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
