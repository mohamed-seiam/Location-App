import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_app/constance/my_color.dart';
import 'package:location_app/constance/strings.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../business_logic/cubit/auth_cubit/phone_auth_cubit.dart';
import '../../business_logic/cubit/auth_cubit/phone_auth_states.dart';

class OtpScreen extends StatelessWidget {
   OtpScreen({Key? key,required this.phoneNumber }) : super(key: key);
  final String phoneNumber ;

  late String otpCode;

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
          otpCode = v;
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }

  void _logIn(BuildContext context){
    BlocProvider.of<PhoneAuthCubit>(context).submitOtp(otpCode);
  }

  Widget _buildVerifyButton(BuildContext context)
  {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);
          _logIn(context);
        },
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

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color> (Colors.black),
        ),
      ),
    );
    showDialog(
        context: context,
        builder:(context)
        {
          return alertDialog ;
        });
  }

  Widget _buildOtpVerifiedBloc(){
    return BlocListener <PhoneAuthCubit,PhoneAuthStates> (
      listenWhen: (previous,current)
      {
        return previous!=current;
      },
      listener:(context,state) {
        if (state is LoadingAuthState)
        {
          return showProgressIndicator (context);
        }if(state is PhoneOtpVerifiedAuthState)
        {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, mapScreen);
        }if (state is ErrorPhoneOtpVerifiedAuthState)
        {
          Navigator.pop(context);
          String errorMessage = state.error;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.black,
            duration:const Duration(seconds: 3),
          ),);
        }
      },
      child: Container(),
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
                _buildVerifyButton(context),
                _buildOtpVerifiedBloc(),
              ],
            ),
          ),
        ),
    );
  }
}
