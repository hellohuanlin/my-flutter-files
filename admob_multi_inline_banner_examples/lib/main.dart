import 'package:admob_multi_inline_banner_examples/AdaptiveSizeNoRecyclePage.dart';
import 'package:admob_multi_inline_banner_examples/AdaptiveSizeRecyclePage.dart';
import 'package:admob_multi_inline_banner_examples/FixedSizeNoRecyclePage.dart';
import 'package:admob_multi_inline_banner_examples/FixedSizeRecyclePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Multiple inline banners'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title)
      ),
      body: Center(
        child: ListView(
          children: [
            TextButton(child: Text("Fixed Size, No Recycle"), onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FixedSizeNoRecyclePage()));
            }),
            TextButton(child: Text("Fixed Size, Recycle"), onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FixedSizeRecyclePage()));
            }),
            TextButton(child: Text("Adaptive Size, No Recycle"), onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdaptiveSizeNoRecyclePage()));
            }),
            TextButton(child: Text("Adaptive Size, Recycle"), onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdaptiveSizeRecyclePage()));
            }),
          ],
        ),
      ),
    );
  }
}
