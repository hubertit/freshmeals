import 'package:freshmeals/models/home/address_model.dart';
import 'package:freshmeals/views/appointment/appointments_booking.dart';
import 'package:freshmeals/views/appointment/booking_screen.dart';
import 'package:freshmeals/views/appointment/my_appointments.dart';
import 'package:freshmeals/views/homepage/account_info.dart';
import 'package:freshmeals/views/homepage/adress_picker.dart';
import 'package:freshmeals/views/homepage/change_address.dart';
import 'package:freshmeals/views/homepage/checkout_screen.dart';
import 'package:freshmeals/views/homepage/favorites_screen.dart';
import 'package:freshmeals/views/homepage/homepage.dart';
import 'package:freshmeals/views/homepage/location_track.dart';
import 'package:freshmeals/views/homepage/luch_screen.dart';
import 'package:freshmeals/views/homepage/meal_details.dart';
import 'package:freshmeals/views/homepage/payment_method.dart';
import 'package:freshmeals/views/homepage/product_details_add_to_cart.dart';
import 'package:freshmeals/views/welcome/ages_screen.dart';
import 'package:freshmeals/views/welcome/gender_screen.dart';
import 'package:freshmeals/views/welcome/goal_screen.dart';
import 'package:freshmeals/views/welcome/height_input.dart';
import 'package:freshmeals/views/welcome/preferances_screen.dart';
import 'package:freshmeals/views/welcome/subscription.dart';
import 'package:freshmeals/views/welcome/welcome.dart';
import 'package:go_router/go_router.dart';
import '../models/user_model.dart';
import '../views/auth/forgot_password.dart';
import '../views/auth/login.dart';
import '../views/auth/new_password.dart';
import '../views/auth/register.dart';
import '../views/auth/reset_password.dart';
import '../views/homepage/my_order.dart';
import '../views/homepage/my_order_details.dart';
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
    builder: (context, state) => const RegisterScreen(),
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
    builder: (context, state) {
      final userModel = state.extra as UserModel;
      return AgeScreen(user: userModel);
    },
  ),
  GoRoute(
    path: '/goal',
    builder: (context, state) {
      final userModel = state.extra as UserModel;
      return HealthGoalScreen(user: userModel);
    },
  ),
  GoRoute(
    path: '/gender',
    builder: (context, state) {
      final userModel = state.extra as UserModel;
      return GenderScreen(user: userModel);
    },
  ),
  GoRoute(
      path: '/height',
      builder: (context, state) {
        final userModel = state.extra as UserModel;
        return HeightInputScreen(user: userModel);
      }),
  GoRoute(
      path: '/weight',
      builder: (context, state) {
        final userModel = state.extra as UserModel;
        return WeightInputScreen(user: userModel);
      }),
  GoRoute(
    path: '/welcome',
    builder: (context, state) => const WelcomeScreen(),
  ),
  GoRoute(
      path: '/subscription',
      builder: (context, state) {
        final userModel = state.extra as UserModel;
        return SubscriptionScreen(user: userModel);
      }),
  GoRoute(
      path: '/preferences',
      builder: (context, state) {
        final userModel = state.extra as UserModel;
        return PreferencesScreen(user: userModel);
      }),
  GoRoute(
    path: '/home',
    builder: (context, state) => const Homepage(),
  ),
  GoRoute(
    path: '/lunch',
    builder: (context, state) => LunchPage(),
  ),
  GoRoute(
    path: '/productDetails',
    builder: (context, state) => ProductDetailPage(),
  ),
  GoRoute(
    path: '/mealDetails/:mealId',
    builder: (context, state) {
      // Retrieve the mealId from the route parameters
      final mealId = state.pathParameters['mealId']!;
      return MealDetailScreen(mealId: mealId);
    },
  ),
  // GoRoute(
  //   path: '/newAddress',
  //   builder: (context, state) => AddressPickerScreen(),
  // ),
  GoRoute(
      path: '/newAddress',
      builder: (context, state) {
        final addressModel = state.extra as Address?;
        return AddressPickerScreen(address: addressModel);
      }),
  GoRoute(
    path: '/checkout',
    builder: (context, state) => const CheckOutScreen(),
  ),
  GoRoute(
    path: '/changeAddress',
    builder: (context, state) => ChangeAddress(),
  ),
  GoRoute(
    path: '/myOrderDetails',
    builder: (context, state) => MyOrderDetailsScreen(),
  ),
  GoRoute(
    path: '/myOrder',
    builder: (context, state) => const MyOrderScreen(),
  ),
  GoRoute(
    path: '/trackLocation',
    builder: (context, state) =>  LocationTrackScreen(),
  ),
  GoRoute(
    path: '/accountInfo',
    builder: (context, state) =>  const AccountInfoScreen(),
  ),
  GoRoute(
    path: '/paymentMethod',
    builder: (context, state) =>  const PaymentMethodScreen(),
  ),
  GoRoute(
    path: '/booking',
    builder: (context, state) =>  const AppointmentsScreen(),
  ),
  GoRoute(
    path: '/myAppointments',
    builder: (context, state) =>  const MyAppointmentsScreen(),
  ),
  GoRoute(
    path: '/favorites',
    builder: (context, state) =>  const FavoritesScreen(),
  ),
]);
