import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:freshmeals/constants/_assets.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';
import '../../riverpod/providers/auth_providers.dart';
import 'widgets/cover_container.dart';
import 'widgets/profile_item.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userState = ref.watch(userProvider);
    print(userState!.user!.token);
    // if(userState!.user!=null){
    return Scaffold(
      backgroundColor: scaffold,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          automaticallyImplyLeading:
              false, // Hide default back button if needed
          flexibleSpace: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white, // AppBar background color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Stack(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundImage: AssetImage(AssetsUtils.profile),
                    ),
                  ],
                ),
                Text(
                  userState!.user!.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(userState.user!.email),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CoverContainer(margin: 20, children: [
              ProfileItemIcon(
                title: 'My orders',
                iconSize: 18,
                onPressed: () {
                  context.push('/myOrder');
                },
                leadingIcon: MaterialCommunityIcons.shopping,
              ),
              ProfileItemIcon(
                title: 'My Appointments',
                iconSize: 18,
                onPressed: () {
                  context.push('/myAppointments');
                },
                leadingIcon: MaterialCommunityIcons.book_information_variant,
              ),
              ProfileItemIcon(
                title: 'Delivery Address',
                onPressed: () {
                  context.push('/changeAddress');
                },
                leadingIcon: MaterialCommunityIcons.map_marker,
                iconSize: 18,
              ),
              ProfileItemIcon(
                title: 'Account Information',
                iconSize: 18,
                onPressed: () {
                  context.push('/accountInfo');
                },
                leadingIcon: Icons.search,
              ),

              // ProfileItemIcon(
              //   title: 'Payment Methods',
              //   onPressed: () {
              //     context.push('/paymentMethod');
              //   },
              //   isLast: false,
              //   leadingIcon: Icons.payment,
              //   iconSize: 18,
              // ),

              ProfileItemIcon(
                title: 'Favorites',
                onPressed: () {
                  context.push('/favorites');
                },
                isLast: true,
                leadingIcon: MaterialCommunityIcons.heart,
                iconSize: 18,
              ),
            ]),
            CoverContainer(margin: 20, children: [
              ProfileItemIcon(
                title: 'Settings',
                iconSize: 18,
                onPressed: () {
                  // context.push('/stores');
                },
                leadingIcon: Icons.settings,
              ),
              ProfileItemIcon(
                title: 'Help Center',
                iconSize: 18,
                onPressed: () {
                  // context.push('/myOrders');
                },
                leadingIcon: MaterialCommunityIcons.help,
              ),
              // ProfileItemIcon(
              //     title: 'Rider Track',
              //     iconSize: 18,
              //     onPressed: () {
              //       context.push('/map');
              //     },
              //     leadingIcon: MaterialCommunityIcons.shopping,
              //     avatarColor: const Color(0xffeff4f8)),
              ProfileItemIcon(
                title: 'About Us',
                onPressed: () {
                  // context.push('/cart');
                },
                isLast: false,
                leadingIcon: Icons.info_outline,
                iconSize: 18,
              ),
              ProfileItemIcon(
                title: 'Share App',
                onPressed: () {
                  // context.push('/cart');
                },
                isLast: true,
                leadingIcon: MaterialCommunityIcons.share,
                iconSize: 18,
              ),
            ]),
            CoverContainer(margin: 20, children: [
              // ProfileItemIcon(
              //   title: "Edit profile",
              //   // titleColor: Colors.red,
              //   onPressed: () {
              //     // context.push("/newUser", extra: userState.user);
              //   },
              //   leadingIcon: Icons.edit,
              //   avatarColor: const Color(0xffeff4f8),
              //   // arrowColor: Colors.red,
              // ),
              ProfileItemIcon(
                  title: "Logout",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'LOGOUT',
                            // style: TextStyle(color: Colors.red),
                          ),
                          content: const Text(
                              'Do you want to logout from your account?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                await ref
                                    .read(userProvider.notifier)
                                    .logout(ref, context);
                                //  context.go('/');
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  leadingIcon: Icons.logout,
                  isLast: true,
                  iconColor: Colors.red,
                  avatarColor: const Color(0xfffcefef)),
              // ProfileItemIcon(
              //   title: "Delete account",
              //   titleColor: Colors.red,
              //   onPressed: () {},
              //   leadingIcon: Icons.delete,
              //   iconColor: Colors.red,
              //   avatarColor: const Color(0xfffcefef),
              //   arrowColor: Colors.red,
              //   isLast: true,
              // ),
            ]),
          ],
        ),
      ),
    );
  }
}
