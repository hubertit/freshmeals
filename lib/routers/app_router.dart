import 'package:freshmeals/views/welcome/ages_screen.dart';
import 'package:freshmeals/views/welcome/gender_screen.dart';
import 'package:freshmeals/views/welcome/goal_screen.dart';
import 'package:freshmeals/views/welcome/height_input.dart';
import 'package:freshmeals/views/welcome/preferances_screen.dart';
import 'package:freshmeals/views/welcome/subscription.dart';
import 'package:freshmeals/views/welcome/welcome.dart';
import 'package:go_router/go_router.dart';
import '../views/auth/forgot_password.dart';
import '../views/auth/login.dart';
import '../views/auth/new_password.dart';
import '../views/auth/register.dart';
import '../views/auth/reset_password.dart';
import '../views/splash/splash.dart';
import '../views/welcome/weight_input.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
  GoRoute(
    path: '/login',
    builder: (context, state) => const SigninScreen(),
  ),
  GoRoute(
    path: '/newUser',
    builder: (context, state) => RegisterScreen(),
  ),
  GoRoute(
    path: '/forgetPassword',
    builder: (context, state) => const ForgotPassword(),
  ),
  GoRoute(
    path: '/resetPassword',
    builder: (context, state) => const ResetPasswordScreen(),
  ),
  GoRoute(
    path: '/newPassword',
    builder: (context, state) => const NewPasswordScreen(),
  ),
  GoRoute(
    path: '/age',
    builder: (context, state) => const AgeScreen(),
  ),
  GoRoute(
    path: '/goal',
    builder: (context, state) => const HealthGoalScreen(),
  ),
  GoRoute(
    path: '/gender',
    builder: (context, state) => const GenderScreen(),
  ),
  GoRoute(
    path: '/height',
    builder: (context, state) =>  HeightInputScreen(),
  ),
  GoRoute(
    path: '/weight',
    builder: (context, state) =>  WeightInputScreen(),
  ),
  GoRoute(
    path: '/welcome',
    builder: (context, state) =>  const WelcomeScreen(),
  ),
  GoRoute(
    path: '/subscription',
    builder: (context, state) =>  const SubscriptionScreen(),
  ),
  GoRoute(
    path: '/preferences',
    builder: (context, state) =>  const PreferencesScreen(),
  ),
]);
