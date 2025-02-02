import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/constants/_assets.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/theme/colors.dart';
import '../homepage/widgets/cover_container.dart';
import 'widgets/datetime_piker.dart';

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
  Widget build(BuildContext context) {
    final slotsState = ref.watch(appointmentsProvider);
    var user = ref.watch(userProvider);
    return Form(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Book Appointment"),
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
                  : (slotsState!.slotsData.isEmpty && _eventDate!=null)
                      ?  Column(
                          children: [
                            const SizedBox(
                              height: 200,
                            ),
                            Center(
                              child: Image.asset(AssetsUtils.emptyLogo,height: 90,),
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
                                ref
                                    .read(appointmentsProvider.notifier)
                                    .bookAppointment(
                                        context,
                                        user!.user!.token,
                                        "$_eventDate",
                                        appontment.startTime,
                                        "${calculateDuration(appontment.startTime, appontment.endTime)}");
                              },
                              child: CoverContainer(
                                children: [
                                  // address("Appointment ID", appontment.name),
                                  address("Start time", appontment.startTime),
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
