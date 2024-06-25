import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:otp/otp.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:time_machine/time_machine.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:base32/base32.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String secret;

  late TextEditingController totpController;

  @override
  void initState() {
    super.initState();
    secret = generateRandomSecret();
    print(secret);
    totpController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter 2FA with TOTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
                data: 'otpauth://totp/YourApp?secret=$secret&issuer=YourApp',
                version: QrVersions.auto,
                size: 200.0),
            SizedBox(height: 20.0),
            TextField(
              controller: totpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter TOTP Code'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String enteredCode = totpController.text.trim();
                if (verifyTOTP(enteredCode, secret)) {
                  // El código TOTP ingresado es válido
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('TOTP Code is valid!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // El código TOTP ingresado no es válido
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Invalid TOTP Code. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Verify TOTP'),
            ),
          ],
        ),
      ),
    );
  }

  String generateRandomSecret() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final random = Random.secure();
    final result = List<int>.generate(
        20, (index) => chars.codeUnitAt(random.nextInt(chars.length)));
    return String.fromCharCodes(result);
  }

  String generateTOTP(String secret) {
    final code = OTP.generateTOTPCodeString(
        secret, DateTime.now().millisecondsSinceEpoch,
        algorithm: Algorithm.SHA1, isGoogle: true);
    return code;
  }

  bool verifyTOTP(String enteredCode, String secret) {
    String generatedCode = generateTOTP(secret);
    print(generatedCode);
    print(enteredCode);
    return generatedCode == enteredCode;
  }
}
