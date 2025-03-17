import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:freshmeals/constants/_assets.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../../riverpod/providers/home.dart';
import 'widgets/choices_dialogue.dart';
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

  void sendEmail() async {
    final Uri emailUri = Uri.parse(
        "https://mail.google.com/mail/u/0/#inbox?compose=new&to=info@freshmeals.rw");

    // final Uri emailUri = Uri(
    //   scheme: 'mailto',
    //   path: 'info@freshmeals.rw',
    // );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint("Could not launch email");
    }
  }

  String webLink = "https://freshmeals.rw/";
  @override
  Widget build(BuildContext context) {
    var userState = ref.watch(userProvider);
    var appointment = ref.watch(appointmentsProvider);
    print(userState!.user!.token);
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
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundImage:
                          NetworkImage("${userState!.user!.profilePicture}"),
                    ),
                  ],
                ),
                Text(
                  userState.user!.name,
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
                title: 'Nutrition consultation',
                iconSize: 18,
                onPressed: () {
                  // context.push('/myAppointments');

                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15.0)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 50),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // if (_meetingType ==
                                //     "Online") {
                                //   context.pop();
                                //   launchUrl(Uri.parse(
                                //       "https://freshmeals.rw/app/questionnaire"));
                                // } else {
                                ref
                                    .read(appointmentsProvider.notifier)
                                    .bookAppointment(
                                    context, userState.user!.token
                                  // "$_eventDate",
                                  // appontment
                                  //     .startTime,
                                  // "${calculateDuration(appontment.startTime, appontment.endTime)}",
                                  // ref,_meetingType
                                );
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                primarySwatch, // Use your app's theme color
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: appointment!.isLoading
                                  ? const Center(
                                child: CircularProgressIndicator(),
                              )
                                  : const Text(
                                "Request For Nutritionist Appointment",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    );


                  // showDialog<String>(
                  //   context: context,
                  //   builder: (context) => ChoiceDialog(),
                  // );
                },
                leadingIcon: MaterialCommunityIcons.book_information_variant,
              ),
              ProfileItemIcon(
                title: 'My Payments',
                iconSize: 18,
                onPressed: () {
                  context.push('/payments');
                },
                leadingIcon: MaterialCommunityIcons.contactless_payment,
              ),
              ProfileItemIcon(
                title: 'Calorie Tracker',
                iconSize: 18,
                onPressed: () {
                  context.push('/trackCalories');
                },
                leadingIcon: MaterialCommunityIcons.trackpad,
              ),
              ProfileItemIcon(
                title: 'Delivery Address',
                onPressed: () {
                  context.push('/changeAddress');
                },
                leadingIcon: MaterialCommunityIcons.map_marker,
                iconSize: 18,
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
                leadingIcon: MaterialCommunityIcons.heart,
                iconSize: 18,
              ),
              ProfileItemIcon(
                title: 'Subscriptions',
                onPressed: () {
                  context.push('/subscribe');
                },
                isLast: true,
                leadingIcon: MaterialCommunityIcons.submarine,
                iconSize: 18,
              ),
            ]),
            CoverContainer(margin: 20, children: [
              ProfileItemIcon(
                title: 'Account Information',
                iconSize: 18,
                onPressed: () {
                  context.push('/accountInfo');
                },
                leadingIcon: Icons.edit,
              ),
              ProfileItemIcon(
                title: 'Help Center',
                iconSize: 18,
                onPressed: () async {
                  const String email = "info@freshmeals.rw";
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: email,
                    queryParameters: {
                      'subject': 'Support Request', // Optional subject
                    },
                  );

                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                  } else {
                    // Handle error (optional)
                    print("Could not launch email client");
                  }
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
                  launchUrl(Uri.parse(webLink));
                },
                isLast: false,
                leadingIcon: Icons.info_outline,
                iconSize: 18,
              ),
              ProfileItemIcon(
                title: 'Share App',
                onPressed: () {
                  Share.share(webLink);

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
                  iconColor: Colors.red,
                  avatarColor: const Color(0xfffcefef)),
              ProfileItemIcon(
                title: "Delete account",
                titleColor: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Delete Account',
                          // style: TextStyle(color: Colors.red),
                        ),
                        content: const Text(
                            'Do you want to delete your Freshmeals account?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              context.pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Alert!!',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: const Text(
                                        'Deleting your account is permanent and irreversible. Are you sure you want to proceed?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          await ref
                                              .read(userProvider.notifier)
                                              .deleteAccount(context,
                                                  userState.user!.token, ref);
                                          //  context.go('/');
                                        },
                                        child: const Text(
                                          'Delete',
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
                            child: const Text(
                              'Delete',
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
                leadingIcon: Icons.delete,
                iconColor: Colors.red,
                avatarColor: const Color(0xfffcefef),
                arrowColor: Colors.red,
                isLast: true,
              ),
            ]),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
