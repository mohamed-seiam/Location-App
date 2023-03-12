import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_app/business_logic/cubit/auth_cubit/phone_auth_states.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthStates> {
  late String verificationId;

  PhoneAuthCubit() : super(InitialAuthState());

  Future<void> submitPhoneNUmber(String phoneNumber) async {
    emit(LoadingAuthState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(
        seconds: 14,
      ),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    print('verificationcompleted');
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException error) {
    print('Error is ${error.toString()}');
    emit(ErrorOccurred(error.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {
    print('codeSent');
    this.verificationId = verificationId;
    emit(PhoneSubmittedAuthState());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print('codeVerificationTimedOut');
  }

  Future<void> submitOtp(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );

    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOtpVerifiedAuthState());
    } catch (error) {
      emit(ErrorPhoneOtpVerifiedAuthState(error.toString()));
    }
  }
  Future<void> logOut () async
  {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser ()
  {
    User fireBaseUser = FirebaseAuth.instance.currentUser!;
    return fireBaseUser ;
  }

}
