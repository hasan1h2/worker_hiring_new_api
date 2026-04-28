class ApiEndpoints {
  static const String baseUrl = 'https://samimdev.pythonanywhere.com/api/v1';

  // Signup Flow
  static const String signup = '/auth/signup/';
  static const String signupOtpVerify = '/auth/signup/verify/';
  static const String signupOtpResend = '/auth/signup/resend/';

  // Login Flow
  static const String loginWithPassword = '/token/auth/';
  static const String requestLoginOtp = '/token/otp/request/';
  static const String verifyLoginOtp = '/token/otp/verify/';
  static const String googleLogin = '/auth/token/google/';

  // Password Reset
  static const String passwordReset = '/auth/password/reset/';
  static const String passwordResetConfirm = '/auth/password/reset-confirm/';

  // Token Management
  static const String tokenVerify = '/token/verify/';
  static const String tokenRefresh = '/token/refresh/';

  // Provider Verification
  static const String providerVerification = '/provider-verification/';
}
