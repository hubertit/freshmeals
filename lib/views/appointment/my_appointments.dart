import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/views/appointment/widgets/empty_widget.dart';
import 'package:go_router/go_router.dart';
import '../../constants/_assets.dart';
import '../../theme/colors.dart';
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
        // actions: [
        //   IconButton(onPressed: ()=>context.push("/booking"), icon: Icon(Icons.add_circle_outline))
        // ],
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
                              message: "You have  no appointments.")
                        ],
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 8.0),
                        itemCount: appointments.appointments.length,
                        itemBuilder: (context, index) {
                          final appontment = appointments.appointments[index];
                          return InkWell(
                            onTap: () {},
                            child: CoverContainer(
                              children: [
                                address("Appointment Date",
                                    appontment.appointmentDate),
                                address("Time slot", appontment.timeSlot),
                                address("Duration", appontment.duration),
                                address(
                                    "Nutritionist", appontment.nutritionist),
                              ],
                            ),
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
          style: const TextStyle(fontSize: 11),
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
