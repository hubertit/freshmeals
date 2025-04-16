import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/views/appointment/widgets/empty_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/_assets.dart';
import '../../theme/colors.dart';
import '../homepage/widgets/choices_dialogue.dart';
import '../homepage/widgets/cover_container.dart';
import 'widgets/datetime_piker.dart';

class MyAppointmentsScreen extends ConsumerStatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  ConsumerState<MyAppointmentsScreen> createState() => _RiderScreenState();
}

class _RiderScreenState extends ConsumerState<MyAppointmentsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(myAppointmentsProvider.notifier)
          .fetchAppointments(context, ref.watch(userProvider)!.user!.token);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appointments = ref.watch(myAppointmentsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Appointments"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (context) => ChoiceDialog(),
                );
              },
              icon: const Icon(Icons.add_circle_outline))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appointments!.isLoading
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                : appointments.appointments.isEmpty
                    ? const Column(
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          CustomEmptyWidget(
                              message: "You have no appointments.")
                        ],
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 8.0),
                        itemCount: appointments.appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments.appointments[index];
                          return CoverContainer(
                            children: [
                              address("Appointment Date",
                                  appointment.date),
                              address("Appointment Type",
                                  appointment.appointmentType),
                              address("Time Slot", appointment.startTime),
                              address("Duration", appointment.duration),
                              address("Nutritionist", appointment.nutritionist),
                              address("Status", appointment.status),

                              // Join Button if Online & Confirmed
                              if (appointment.meetingLink != null)
                                Row(
                                  children: [
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          final url =
                                              Uri.parse(appointment.meetingLink!);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url,
                                                mode: LaunchMode
                                                    .externalApplication);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Could not launch link")),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.video_call,size: 18,),
                                        label: const Text("Join", style: TextStyle(fontSize: 14),),
                                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0).copyWith(left:10, right: 10 ),
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}

Widget address(String attr, String vle) {
  return Row(
    children: [
      SizedBox(
        width: 150,
        child: Text(
          "${attr}:",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
      Flexible(
        child: Text(
          vle,
          style: TextStyle(
            fontSize: 11,
            color: vle == "Pending"
                ? Colors.orange
                : vle == "Approved"
                ? primarySwatch
                : vle == "Cancelled"
                ? Colors.red
                : Colors.black, // fallback color
          ),
        ),

      ),
    ],
  );
}

int calculateDuration(String startTime, String endTime) {
  // Parse the start and end times into DateTime objects
  final start = DateFormat("HH:mm:ss").parse(startTime);
  final end = DateFormat("HH:mm:ss").parse(endTime);

  // Calculate the difference in minutes
  final duration = end.difference(start).inMinutes;

  return duration;
}
