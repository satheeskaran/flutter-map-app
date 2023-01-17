import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  final _longitude = TextEditingController();
  final _latitude = TextEditingController();

  @override
  void dispose() {
    _longitude.dispose();
    _latitude.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(fit: StackFit.loose, alignment: Alignment.center, children: [
        Expanded(
            child: InAppWebView(
          key: webViewKey,
          initialUrlRequest:
              URLRequest(url: Uri.parse("http://10.22.79.199:3000/")),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
              this.url = url.toString();
              urlController.text = this.url;
            });
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        )),
        Positioned(
            top: 40,
            child: SizedBox(
              width: size.width - 20,
              child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(241, 241, 241, 1),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: _longitude,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Longitude',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                      //password textbox
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(241, 241, 241, 1),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: _latitude,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Latitude'),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(35, 44, 104, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: handleSearch,
                            child: Center(
                              child: Text(
                                'Search',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            )),
        Positioned(
            bottom: 20,
            child: SizedBox(
              width: size.width - 20,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ))
      ]),
    );
  }

  Future handleSearch() async {
    var url = Uri.parse("http://10.22.79.199:3000/?croods=" +
        _longitude.text +
        "," +
        _latitude.text);
    webViewController?.loadUrl(urlRequest: URLRequest(url: url));
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
