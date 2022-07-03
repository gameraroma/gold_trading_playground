import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var counterProvider = StateProvider((_) => 0);

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer(
              builder: (context, ref, child) {
                final counter = ref.watch(counterProvider);
                return Text(
                  '$counter',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline4,
                ); // Hello world
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            onPressed: () => {
              ref.read(counterProvider.notifier).state++
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}