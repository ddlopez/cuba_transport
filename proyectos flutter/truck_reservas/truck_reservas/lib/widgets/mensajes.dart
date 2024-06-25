import 'package:flutter/material.dart';

class Message {
  // static showSMS(String sms) {
  //   // Fluttertoast.showToast(
  //   //     msg: sms,
  //   //     toastLength: Toast.LENGTH_SHORT,
  //   //     gravity: ToastGravity.BOTTOM,
  //   //     timeInSecForIosWeb: 1,
  //   //     backgroundColor: Colors.black87,
  //   //     textColor: Colors.white,
  //   //     fontSize: 16.0);
  // }
  static showSnackBarCustom(
      {BuildContext? context, String? sms, int? duration, bool? error}) {
    return Future.microtask(() {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                color: error == true
                    ? const Color.fromRGBO(254, 238, 239, 1)
                    : const Color.fromRGBO(230, 247, 246, 1),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  height: double.infinity,
                  width: 7,
                  decoration: BoxDecoration(
                      color: error == true
                          ? const Color.fromRGBO(255, 89, 98, 1)
                          : const Color.fromRGBO(0, 176, 166, 1),
                      borderRadius: BorderRadius.circular(6)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.check_circle,
                  color: error == true
                      ? const Color.fromRGBO(255, 89, 98, 1)
                      : const Color.fromRGBO(0, 176, 166, 1),
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    sms ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: error == true
                          ? const Color.fromRGBO(255, 89, 98, 1)
                          : const Color.fromRGBO(0, 176, 166, 1),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        duration: Duration(seconds: duration ?? 2),
      ));
    });
  }
}
