class RegisterPhoneController {
  static final RegisterPhoneController instance =
      RegisterPhoneController._internal();

  factory RegisterPhoneController() {
    return instance;
  }

  RegisterPhoneController._internal();

  String _phone;
  String get phone => _phone;

  set phone(String phone) {
    this._phone = phone;
  }

  DateTime _timeOTP;

  String _verificationId;

  String get verificationId => _verificationId;

  set verificationId(String verificationId) {
    this._verificationId = verificationId;
  }
}
