import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/view/entities/midtrans_param_entity.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransPay extends StatefulWidget {
  const MidtransPay({super.key});

  @override
  State<MidtransPay> createState() => _MidtransPayState();
}

class _MidtransPayState extends State<MidtransPay> {
  MidtransParam param = Get.arguments;
  late WebViewController controller;

  String _getHtmlString() {
    String htmlString = '''
		<html>
	    <head>
	      <meta name="viewport" content="width=device-width, initial-scale=1">
	      <script 
	        type="text/javascript"
	        src="${midtransConfig['url']}"
	        data-client-key="${midtransConfig['clientKey']}"
	      ></script>
	    </head>
	    <body onload="setTimeout(function(){pay()}, 1000)">
	      <script type="text/javascript">
	          function pay() {
	            snap.pay('${param.token}', {
	              onSuccess: function(result) {
	                Android.postMessage('ok');
	              },
	              onPending: function(result) {
	                Android.postMessage('pending');
	              },
	              onError: function(result) {
	                Android.postMessage('error');
	              },
	              onClose: function() {
	                Android.postMessage('close');
	              }
	            });
	          }
	      </script>
	    </body>
	  </html>
		''';

    return htmlString;
  }

  void _initController() {
    setState(() {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel('Android', onMessageReceived: androidMessage)
        ..setNavigationDelegate(NavigationDelegate(onNavigationRequest: (request) async {
          if (request.url.substring(0, 6) == 'intent') {
            if (request.url.contains('gopay')) {
              String url = request.url.replaceAll('intent://', 'gojek://');
              // await launchUrl(Uri.parse(url));
            }
            return NavigationDecision.prevent;
          } else {
            return NavigationDecision.navigate;
          }
        }))
        ..loadRequest(Uri.dataFromString(_getHtmlString(), mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
    });
  }

  void androidMessage(JavaScriptMessage receiver) {
    if (receiver.message != 'undefined') {
      if (receiver.message == 'close' || receiver.message == 'error') {
        Navigator.pop(context);
      } else {
        Get.back();
        Get.snackbar('Berhasil', 'Pembayaran berhasil');
      }
    }
  }

  @override
  void initState() {
    _initController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
      ),
      body: WebViewWidget(controller: controller!),
    );
  }
}
