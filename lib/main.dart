import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
  Chapa.configure(privateKey: "CHASECK_TEST-pr0VQLpVWDTe1DKTkrYVevt7vf1AYKBo");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = false;
  var Success_or_fail =false;


  Future<void> verify() async {
    Map<String, dynamic> verificationResult =
        await Chapa.getInstance.verifyPayment(
      txRef: TxRefRandomGenerator.gettxRef,
    );
    if (kDebugMode) {
      print(verificationResult);
    }
  }

  Future<void> pay() async {
    try {
      String txRef = TxRefRandomGenerator.generate(prefix: 'linat');
      String storedTxRef = TxRefRandomGenerator.gettxRef;
      loading = true;
      if (kDebugMode) {
        print('Generated TxRef: $txRef');
        print('Stored TxRef: $storedTxRef');
      }
      await Chapa.getInstance.startPayment(
        enableInAppPayment: true,
        context: context,
        onInAppPaymentSuccess: (successMsg) {
          loading = false;
          payment_notification();
        },
        onInAppPaymentError: (errorMsg) {
          loading = false;
          print(errorMsg);
        },
        amount: '1000',
        currency: 'ETB',
        txRef: storedTxRef,
      );
    } catch (e) {
      if (kDebugMode) {
        loading = false;
        print('this is network exeption');
        print(e);
      }
    }
  }
  
  void payment_notification(){
    Get.snackbar(
            duration:const Duration(seconds: 5),
            backgroundColor: Colors.green[400],
            forwardAnimationCurve: Curves.bounceIn,
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            'payment', 
            'payid Successfuly ',
            titleText:const Text('from Tiket',style: TextStyle(
              color: Colors.white
            ),),
            messageText:const Text('Successful payment',style: TextStyle(
              color: Colors.white
            ),)
        );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("chapa payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'pay to ticket',
            ),
            TextButton(
                onPressed: () async {
                  loading = true;
                  await pay();
                },
                child: const Text("Pay")),
            TextButton(
                onPressed: () async {
                  payment_notification();
                  // await verify();
                  
                },
                child: const Text("Verify")),
            loading?const CircularProgressIndicator():const Text(''),
          ],
        ),
      ),
    );
  }
}