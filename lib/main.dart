import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tuya Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tuya Home App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic additionalResult = 0;
  static const methodChannelPlatform = MethodChannel("app.id.com/my_channel_name");

  void _invodeAddNumbers() async{
    dynamic returnValue = await methodChannelPlatform.invokeMethod("addnumbers",<String,dynamic>{
      'n1':50,
      'n2':10
    });

    setState(() {
      print("@@@ received value in flutter"+ returnValue.toString() );
      additionalResult = returnValue;
    });
  }


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
            Text(
              'Additional Res : '+additionalResult.toString()
            ),
            ElevatedButton(onPressed: _invodeAddNumbers, child: Text("Invode Method channel"))
          ],
        ),
      ),
    );
  }
}
