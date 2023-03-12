abstract class PhoneAuthStates {}

class InitialAuthState extends PhoneAuthStates{}

class LoadingAuthState extends PhoneAuthStates{}

class ErrorOccurred extends PhoneAuthStates {
  final String error;
  ErrorOccurred(this.error);
}

class PhoneSubmittedAuthState extends PhoneAuthStates{}

class PhoneOtpVerifiedAuthState extends PhoneAuthStates{}

class ErrorPhoneOtpVerifiedAuthState extends PhoneAuthStates{
  final String error;
  ErrorPhoneOtpVerifiedAuthState(this.error);
}

