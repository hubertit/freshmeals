import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/_assets.dart';
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
    _initialize();

    super.initState();

  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    await _loadUser();
  }

  Future<void> _loadUser() async {
    // final prefs = await SharedPreferences.getInstance();
    // final userData = prefs.getString('user');
    // if (userData != null) {
    //   final userMap = jsonDecode(userData) as Map<String, dynamic>;
    //   final user = UserModel.fromJson(userMap);
    //   ref.read(userProvider.notifier).state =
    //       UserState(isLoading: false, user: user);
    //   context.go('/home');
    // } else {
      context.go('/login');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AssetsUtils.logo,height: 200,),
        ],
      ),
    ));
  }
}
