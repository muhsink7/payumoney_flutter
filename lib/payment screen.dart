import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late PayUCheckoutProFlutter _checkoutPro;

  @override
  void initState() {
    super.initState();
    _checkoutPro = PayUCheckoutProFlutter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Expiry Date'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                initiatePayment();
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initiatePayment() async {
    final String merchantKey = 'YOUR_MERCHANT_KEY';
    final String merchantSalt = 'YOUR_MERCHANT_SALT';
    final String paymentUrl = 'https://test.payu.in/merchant/postservice.php?form=2'; // Use the appropriate URL based on the environment (test or production)

    final Map<String, dynamic> paymentData = {
      'key': merchantKey,
      'txnid': 'YOUR_UNIQUE_TRANSACTION_ID',
      'amount': 'AMOUNT_TO_BE_PAID',
      'productinfo': 'PRODUCT_INFO',
      'firstname': 'CUSTOMER_FIRST_NAME',
      'email': 'CUSTOMER_EMAIL',
      'phone': '+9845644984',
      'surl': 'YOUR_SUCCESS_CALLBACK_URL',
      'furl': 'YOUR_FAILURE_CALLBACK_URL',
    };

    // Calculate and set the hash
    String hashString = generateHashString(paymentData, merchantSalt);
    paymentData['hash'] = hashString;

    final response = await http.post(Uri.parse(paymentUrl), body: paymentData);

    if (response.statusCode == 200) {
      // Handle the payment response
      print('Payment Success!');
    } else {
      // Handle payment failure
      print('Payment Failed!');
    }
  }

  String generateHashString(Map<String, dynamic> paymentData, String merchantSalt) {
    // Implement the logic to calculate the hash string based on the provided parameters and merchant salt.
    // You can find the hash calculation logic in PayUMoney documentation.
    // Example: (Replace this with your actual hash calculation logic)
    String hash = paymentData['key'] +
        '|' +
        paymentData['txnid'] +
        '|' +
        paymentData['amount'] +
        '|' +
        paymentData['productinfo'] +
        '|' +
        paymentData['firstname'] +
        '|' +
        paymentData['email'] +
        '|' +
        'YOUR_MERCHANT_SALT';
    return hash;
  }
}
