import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/appointment.dart';
import '../../models/pregnancy_data.dart';
import '../../state/app_state.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  void _showAddEditAppointmentDialog([Appointment? existing]) {
    final isEditing = existing != null;
    final doctorCtrl =
        TextEditingController(text: existing != null ? existing.doctorName : '');
    final locationCtrl =
        TextEditingController(text: existing != null ? existing.location : '');
    final notesCtrl =
        TextEditingController(text: existing != null ? existing.notes : '');
    DateTime selectedDate =
        existing != null ? existing.dateTime : DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = existing != null
        ? TimeOfDay.fromDateTime(existing.dateTime)
        : const TimeOfDay(hour: 10, minute: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDim,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  isEditing
                      ? 'অ্যাপয়েন্টমেন্ট সম্পাদনা করুন'
                      : 'নতুন অ্যাপয়েন্টমেন্ট যোগ করুন',
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                // Doctor / Provider Name
                TextField(
                  controller: doctorCtrl,
                  decoration: InputDecoration(
                    labelText: 'ডাক্তার / স্বাস্থ্যকেন্দ্রের নাম *',
                    labelStyle:
                        const TextStyle(fontFamily: 'Noto Sans Bengali'),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Date & Time pickers
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setModalState(() => selectedDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius:
                                BorderRadius.circular(AppRadius.md),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.event,
                                  size: 18, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                '${toBanglaDigits(selectedDate.day)}/${toBanglaDigits(selectedDate.month)}/${toBanglaDigits(selectedDate.year)}',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (picked != null) {
                            setModalState(() => selectedTime = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius:
                                BorderRadius.circular(AppRadius.md),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_rounded,
                                  size: 18, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                '${toBanglaDigits(selectedTime.hourOfPeriod == 0 ? 12 : selectedTime.hourOfPeriod)}:${selectedTime.minute.toString().padLeft(2, '0')} ${selectedTime.period == DayPeriod.am ? 'সকাল' : 'বিকাল'}',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Location
                TextField(
                  controller: locationCtrl,
                  decoration: InputDecoration(
                    labelText: 'হাসপাতাল বা চেম্বারের ঠিকানা',
                    labelStyle:
                        const TextStyle(fontFamily: 'Noto Sans Bengali'),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Notes
                TextField(
                  controller: notesCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'বিশেষ নোট বা পরীক্ষার বিবরণ',
                    labelStyle:
                        const TextStyle(fontFamily: 'Noto Sans Bengali'),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    onPressed: () async {
                      if (doctorCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'অনুগ্রহ করে ডাক্তার বা স্বাস্থ্যকেন্দ্রের নাম লিখুন',
                              style: TextStyle(fontFamily: 'Noto Sans Bengali'),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      final fullDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      if (isEditing) {
                        await AppState.instance.editAppointment(
                          existing.copyWith(
                            doctorName: doctorCtrl.text.trim(),
                            dateTime: fullDateTime,
                            location: locationCtrl.text.trim(),
                            notes: notesCtrl.text.trim(),
                          ),
                        );
                      } else {
                        await AppState.instance.addAppointment(
                          Appointment(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            doctorName: doctorCtrl.text.trim(),
                            dateTime: fullDateTime,
                            location: locationCtrl.text.trim(),
                            notes: notesCtrl.text.trim(),
                          ),
                        );
                      }
                      if (mounted) Navigator.pop(context);
                    },
                    child: Text(
                      isEditing ? 'আপডেট করুন' : 'অ্যাপয়েন্টমেন্ট সংরক্ষণ করুন',
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final appointments = AppState.instance.appointments;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surfaceContainerLowest,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: AppColors.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'ডাক্তারের অ্যাপয়েন্টমেন্ট',
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddEditAppointmentDialog(),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'নতুন যোগ করুন',
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: appointments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event_busy_rounded,
                          size: 56, color: AppColors.outline),
                      const SizedBox(height: 12),
                      const Text(
                        'কোনো নির্ধারিত অ্যাপয়েন্টমেন্ট নেই',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'ডাক্তারের চেকআপ ও আল্ট্রাসাউন্ডের শিডিউল যোগ করুন।',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final app = appointments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppShadows.subtleCard,
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.local_hospital_rounded,
                                    color: AppColors.primary, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      app.doctorName,
                                      style: const TextStyle(
                                        fontFamily: 'Noto Sans Bengali',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.event,
                                            size: 14, color: AppColors.primary),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${toBanglaDigits(app.dateTime.day)}/${toBanglaDigits(app.dateTime.month)}/${toBanglaDigits(app.dateTime.year)} • ${toBanglaDigits(app.dateTime.hour > 12 ? app.dateTime.hour - 12 : app.dateTime.hour)}:${app.dateTime.minute.toString().padLeft(2, '0')} ${app.dateTime.hour >= 12 ? 'বিকাল' : 'সকাল'}',
                                          style: const TextStyle(
                                            fontFamily: 'Noto Sans Bengali',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (app.location.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.location_on_outlined,
                                              size: 14,
                                              color:
                                                  AppColors.onSurfaceVariant),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              app.location,
                                              style: const TextStyle(
                                                fontFamily: 'Noto Sans Bengali',
                                                fontSize: 12,
                                                color:
                                                    AppColors.onSurfaceVariant,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (app.notes.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        app.notes,
                                        style: const TextStyle(
                                          fontFamily: 'Noto Sans Bengali',
                                          fontSize: 12,
                                          height: 1.4,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert_rounded,
                                    color: AppColors.outline),
                                onSelected: (val) {
                                  if (val == 'edit') {
                                    _showAddEditAppointmentDialog(app);
                                  } else if (val == 'delete') {
                                    AppState.instance.deleteAppointment(app.id);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('সম্পাদনা',
                                        style: TextStyle(
                                            fontFamily: 'Noto Sans Bengali')),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('মুছে ফেলুন',
                                        style: TextStyle(
                                            fontFamily: 'Noto Sans Bengali',
                                            color: AppColors.error)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
