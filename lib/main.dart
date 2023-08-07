import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayUmoney CheckoutPro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyWebView(),
    );
  }
}

class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final String url = 'https://secure.payu.in/_payment';

  String key = 'Rd3iUs';
  String txnid = 'PQI6eeMquYrjEefU';
  String amount = '10.00';
  String productinfo = 'iPhone';
  String firstname = 'PayU User';
  String email = 'test@gmail.com';
  String udf1 = '';
  String udf2 = '';
  String udf3 = '';
  String udf4 = '';
  String udf5 = '';
  String salt = 'IKtjXMKG';

  late final Map<String, String> postData = {
    'key': key,
    'txnid': txnid,
    'amount': amount,
    'firstname': firstname,
    'email': email,
    'phone': '9876543210',
    'productinfo': productinfo,
    'surl': 'https://apiplayground-response.herokuapp.com/',
    'furl': 'https://apiplayground-response.herokuapp.com/',
  };

  @override
  void initState() {
    super.initState();
    addHashToPostData();
    Timer(const Duration(seconds: 2), () => postUrl());
  }

  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {

        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    );




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayU Payment'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }

  void postUrl() async {
    // Convert the POST data to a string
    String postDataString = '';
    postData.forEach((key, value) {
      postDataString += '$key=$value&';
    });

    // Remove the trailing '&' character
    postDataString = postDataString.substring(0, postDataString.length - 1);

    var code = '''
     var form = document.createElement('form');
form.method = 'POST';
form.action = '$url';
var postDataString = '$postDataString';
postDataString.split('&').forEach(function(param) {
  var input = document.createElement('input');
  input.type = 'hidden';
  input.name = param.split('=')[0];
  input.value = param.split('=')[1];
  form.appendChild(input);
});
document.body.appendChild(form);
form.submit();
    ''';

    print(code);

    // Execute the JavaScript code to submit the POST request
    _controller.runJavaScript(code);
  }

  void addHashToPostData() {
    // Concatenate the parameters with the pipe character
    String hashString = [key, txnid, amount, productinfo, firstname, email, udf1, udf2, udf3, udf4, udf5, '', '', '', '', '', salt].join('|');

    print(hashString);


    // Generate the SHA-512 hash
    var bytes = utf8.encode(hashString);
    var digest = sha512.convert(bytes);
    String hash = digest.toString();

    // Add the hash to the POST data
    postData['hash'] = hash;
  }
}