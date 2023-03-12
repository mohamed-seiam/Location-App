import 'package:flutter/material.dart';
import 'package:location_app/constance/my_color.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);
  final String phoneNumber = '';

  Widget _buildIntroText()
  {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your phone number',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: RichText(
              text: TextSpan(
                text: 'Enter your 6 digit code numbers sent to ',
                style:const TextStyle(color: Colors.black,fontSize: 18,height: 1.5),
                children:<TextSpan>[
                  TextSpan(
                    text: phoneNumber,
                    style:const TextStyle(color: Colors.blue)
                  ),
                ]
              ),
          ),
        ),
      ],
    );
  }

 Widget _buildPinCodeField(BuildContext context)
  {
    return Container(
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        obscureText: false,
        autoFocus: true,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          borderWidth: 1,
          activeColor: MyColor.blue,
          activeFillColor: MyColor.lightBlue,
          inactiveColor: MyColor.blue,
          selectedColor: MyColor.blue,
          selectedFillColor: Colors.white,
          inactiveFillColor: Colors.white,
        ),
        animationDuration:const Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        enableActiveFill: true,
        onCompleted: (v) {
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }

  Widget _buildVerifyButton()
  {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(110, 50),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )),
        child: const Text(
          'Verify',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 88),
            child: Column(
              children: [
                _buildIntroText(),
               const SizedBox(height: 88,),
                _buildPinCodeField(context),
               const SizedBox(height: 60,),
                _buildVerifyButton(),
              ],
            ),
          ),
        ),
    );
  }
}
