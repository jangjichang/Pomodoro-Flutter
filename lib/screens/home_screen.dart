import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int defaultSeconds = 25 * 60;
  int totalSeconds = defaultSeconds;
  int totalPomodoros = 0;
  bool isRunning = false;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        totalSeconds = defaultSeconds;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onResetPressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
      totalSeconds = defaultSeconds;
    });
  }

  String formatTime(int seconds) {
    String minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    String remainingSeconds = (seconds % 60).toString().padLeft(2, '0');

    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: drawCounterContainerList(
                context,
                formatTime(totalSeconds),
              ),
            ),
          ),
          Flexible(
              flex: 3,
              child: Column(
                children: [
                  Center(
                    child: IconButton(
                      iconSize: 120,
                      color: Theme.of(context).cardColor,
                      icon: Icon(
                        isRunning
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                      ),
                      onPressed: isRunning ? onPausePressed : onStartPressed,
                    ),
                  ),
                  Center(
                    child: IconButton(
                      iconSize: 40,
                      color: Theme.of(context).cardColor,
                      icon: const Icon(Icons.restore_rounded),
                      onPressed: onResetPressed,
                    ),
                  )
                ],
              )),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Container> drawCounterContainerList(
      BuildContext context, String formatedTime) {
    List<Container> list = [];
    for (int i = 0; i < formatedTime.length; i++) {
      list.add(drawCounterContainer(context, formatedTime[i]));
    }
    return list;
  }

  Container drawCounterContainer(BuildContext context, String formatedTime) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: 65,
      child: Text(
        formatedTime,
        style: TextStyle(
          color: Theme.of(context).cardColor,
          fontSize: 89,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
