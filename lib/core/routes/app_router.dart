import 'package:go_router/go_router.dart';
import 'package:sanad/features/auth/presentation/screens/finish_otp_screen.dart';
import 'package:sanad/features/auth/presentation/screens/forget_password.dart';
import 'package:sanad/features/auth/presentation/screens/home_provider.dart';
import 'package:sanad/features/auth/presentation/screens/login_User_screen.dart';
import 'package:sanad/features/auth/presentation/screens/new_Password.dart';
import 'package:sanad/features/auth/presentation/screens/otp_screen.dart';
import 'package:sanad/features/auth/presentation/screens/signUp_Screen.dart';
import 'package:sanad/features/client/client_home/presentation/screens/client_home_screen.dart';
import 'package:sanad/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:sanad/features/splash/presentation/screens/splash_Screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/homeProvider', builder: (context, state) => HomeProvider()),


    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/signUp', builder: (context, state) => SignupScreen()),
    GoRoute(
      path: '/otpScreen',
      builder: (context, state) =>
          OtpScreen(email: (state.extra as String?) ?? ''),
    ),
    GoRoute(path: '/newPassword', builder: (context, state) => NewPassword()),
    GoRoute(path: '/loginUser', builder: (context, state) => LoginUserScreen()),
    GoRoute(
      path: '/forgetPassword',
      builder: (context, state) => ForgetPassword(),
    ),
    GoRoute(path: '/finishOtp', builder: (context, state) => FinishOtpScreen()),
    GoRoute(path: '/onboarding', builder: (context, state) => OnboardingScreen()),
    GoRoute(path: '/clientHome', builder: (context, state) => ClientHomeScreen()),
  ],
);
