import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/constants/_assets.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import '../homepage/widgets/cover_container.dart';
import 'widgets/datetime_piker.dart';
import 'widgets/empty_widget.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _RiderScreenState();
}

class _RiderScreenState extends ConsumerState<AppointmentsScreen> {
  final StateProvider<bool> pressedState = StateProvider((ref) => false);
  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  DateTime? _eventDate;
  var key = GlobalKey<FormState>();
  String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String formatTime(DateTime dateTime) {
    return "${DateFormat('HH').format(dateTime)}H${DateFormat('mm').format(dateTime)}";
  }

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
    final slotsState = ref.watch(appointmentsProvider);
    var user = ref.watch(userProvider);
    final appointments = ref.watch(myAppointmentsProvider);

    return Form(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nutrition Appointments"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoverContainer(
                horizontalPadding: 15,
                children: [
                  CustomDatePickerField(
                    hint: "Select Date",
                    initialDate: _eventDate,
                    onDateSelected: (DateTime dateTime) {
                      setState(() {
                        _eventDate = dateTime;
                      });

                      ref
                          .read(appointmentsProvider.notifier)
                          .fetchSlots(context, "${dateTime}");
                    },
                  ),
                ],
              ),
              slotsState!.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (slotsState!.slotsData.isEmpty && _eventDate == null)
                      ? appointments!.appointments.isEmpty
                          ? const Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                ),
                                CustomEmptyWidget(
                                    message: "You have  no appointments.")
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0, top: 15),
                                  child: Text(
                                    "Your Appointments",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(top: 0),
                                  itemCount: appointments.appointments.length,
                                  itemBuilder: (context, index) {
                                    final appontment =
                                        appointments.appointments[index];
                                    return CoverContainer(
                                      children: [
                                        address("Appointment Date",
                                            appontment.appointmentDate),
                                        address(
                                            "Time slot", appontment.timeSlot),
                                        address(
                                            "Duration", appontment.duration),
                                        address("Nutritionist",
                                            appontment.nutritionist),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            )
                      : (slotsState.slotsData.isEmpty && _eventDate != null)
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 200,
                                ),
                                Center(
                                  child: Image.asset(
                                    AssetsUtils.emptyLogo,
                                    height: 90,
                                  ),
                                ),
                                const Text(
                                  "There are no appointments available on this date.",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 8.0),
                              itemCount: slotsState.slotsData.length,
                              itemBuilder: (context, index) {
                                final appontment = slotsState.slotsData[index];
                                return InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Confirm Appointment'),
                                          content: Text(
                                            'You are about to book an appointment from ${appontment.startTime} to ${appontment.endTime}. Do you want to proceed?',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                ref
                                                    .read(appointmentsProvider
                                                        .notifier)
                                                    .bookAppointment(
                                                        context,
                                                        user!.user!.token,
                                                        "$_eventDate",
                                                        appontment.startTime,
                                                        "${calculateDuration(appontment.startTime, appontment.endTime)}",
                                                        ref);
                                              },
                                              child: const Text(
                                                'Confirm',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: CoverContainer(
                                    children: [
                                      // address("Appointment ID", appontment.name),
                                      address(
                                          "Start time", appontment.startTime),
                                      address("End time", appontment.endTime),
                                    ],
                                  ),
                                );
                              },
                            ),
            ],
          ),
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
