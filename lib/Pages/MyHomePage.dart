import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Data/Result.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String code = '';
  String textLog = '';

  Future<Result> _getResult(String code) async {
    Result result;
    String url =
        'https://i.mi.com/support/anonymous/status?ts=1650962688843&id=$code';
    var dio = await Dio().get(url);
    print(dio);
    var data = jsonDecode(dio.toString());
    result = Result.fromJson(data);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final Color appColors = Color(0xff242A37);
    final _textController = TextEditingController();
    final TextStyle appStyle = TextStyle(color: Colors.white, fontSize: 20);
    const TextStyle checkStyleOn =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.red);
    const TextStyle checkStyleOff =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.green);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors,
        title: Text('Check'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: appColors,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 400,
            width: 300,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black26,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                      hintText: 'Code check',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      code = _textController.text.trim();
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff122325FF))),
                  child: const Text(
                    'Check',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: 200,
                    color: Colors.black,
                    child: code != ''
                        ? FutureBuilder(
                            future: _getResult(code),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.data.locked == false) {
                                  textLog =
                                      "IMEI/lock code: $code\nFind device: OFF";
                                  return Center(
                                      child: RichText(
                                    text: TextSpan(
                                        text: 'IMEI/lock code: ',
                                        children: [
                                          TextSpan(
                                              text: '$code\n\n',
                                              style: checkStyleOff),
                                          const TextSpan(
                                              text: 'Find device: ',
                                              children: [
                                                TextSpan(
                                                    text: 'OFF\n\n',
                                                    style: checkStyleOff)
                                              ]),
                                          const TextSpan(
                                              text: 'Copy log here',
                                              style: TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic)),
                                        ]),
                                  ));
                                } else {
                                  textLog = "IMEI/lock code: $code\n"
                                      "Find device: ON\n"
                                      "Lock phone: ${snapshot.data.data.phone}\n"
                                      "Lock email: ${snapshot.data.data.email}";
                                  return Center(
                                      child: RichText(
                                    text: TextSpan(
                                        text: 'IMEI/lock code: ',
                                        children: [
                                          TextSpan(
                                              text: '$code\n\n',
                                              style: checkStyleOn),
                                          const TextSpan(text: 'Find device: '),
                                          const TextSpan(
                                              text: 'ON\n\n',
                                              style: checkStyleOn),
                                          const TextSpan(text: 'Lock phone: '),
                                          TextSpan(
                                              text:
                                                  '${snapshot.data.data.phone}\n\n',
                                              style: checkStyleOn),
                                          const TextSpan(text: 'Lock email: '),
                                          TextSpan(
                                              text:
                                                  '${snapshot.data.data.email}',
                                              style: checkStyleOn),
                                        ]),
                                  ));
                                }
                              } else {
                                return const Center(
                                  child: Text('Error'),
                                );
                              }
                            },
                          )
                        : Container(
                            child: Image.asset('assets/icon.jpg'),
                          )),
                TextButton(
                    onPressed: () async{
                      Clipboard.setData(ClipboardData(text: textLog));
                    },
                    child: const Text('Copy log here',
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
