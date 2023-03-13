import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_app/business_logic/cubit/auth_cubit/phone_auth_cubit.dart';
import 'package:location_app/business_logic/cubit/auth_cubit/phone_auth_states.dart';
import 'package:location_app/constance/my_color.dart';
import 'package:location_app/constance/strings.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  late String phoneNumber;
GlobalKey<FormState> _globalKey = GlobalKey();
  Widget _buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your phone number ?',
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
          child: const Text(
            'Please enter your phone number to verify your account ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneFormField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: MyColor.lightGrey),
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Text(
              '${generateCountryFlag()} +20',
              style: const TextStyle(fontSize: 18, letterSpacing: 2.0),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: MyColor.blue),
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 2.0,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'please enter your phone number';
                } else if (value.length > 11) {
                  return 'Too short for a phone number';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                phoneNumber = value!;
              },
            ),
          ),
        ),
      ],
    );
  }

  String generateCountryFlag() {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
        );
    return flag;
  }


  Future<void> _register (BuildContext context) async
  {
      if (!_globalKey.currentState!.validate())
      {
        Navigator.pop(context);
        return;
      }else
      {
        Navigator.pop(context);
        _globalKey.currentState!.save();
        BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNUmber(phoneNumber);
      }
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);
          _register(context);
        },
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(110, 50),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )),
        child: const Text(
          'Next',
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


  Widget _buildPhoneNUmberSubmitedBloc()
  {
    return BlocListener <PhoneAuthCubit,PhoneAuthStates> (
      listenWhen: (previous,current)
      {
        return previous!=current;
      },
      listener:(context,state) {
        if (state is LoadingAuthState)
        {
          return showProgressIndicator (context);
        }if(state is PhoneSubmittedAuthState)
        {
          Navigator.pop(context);
          Navigator.pushNamed(context, otpScreen,arguments: phoneNumber);
        }if (state is ErrorOccurred)
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
        backgroundColor: Colors.white,
        body: Form(
          key: _globalKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 88),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIntroText(),
                const SizedBox(
                  height: 110,
                ),
                _buildPhoneFormField(),
                const SizedBox(height: 70,),
                _buildNextButton(context),
                _buildPhoneNUmberSubmitedBloc(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
