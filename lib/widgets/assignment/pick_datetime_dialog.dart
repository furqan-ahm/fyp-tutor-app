import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../utils/enums.dart';
import '../common/custom_button.dart';

class PickDatetimeDialog extends StatefulWidget {
  const PickDatetimeDialog({Key? key}) : super(key: key);

  @override
  _PickDatetimeDialogState createState() => _PickDatetimeDialogState();
}

class _PickDatetimeDialogState extends State<PickDatetimeDialog> {
  DateTime? selectedTime;

  int selectedHour=1;
  int selectedMinute=0;

  TimeMode selectedTimeMode=TimeMode.AM;


  @override
  void initState() { 
    selectedTime=DateTime.now();
    super.initState();
  }

  Future onPressed()async{
    if(selectedTime==null)return;
    Navigator.pop(context,DateTime(selectedTime!.year, selectedTime!.month, selectedTime!.day, selectedHour+(selectedTimeMode==TimeMode.PM?12:0), selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(selectableDayPredicate: (day)=>day.isAfter(DateTime.now().subtract(const Duration(days: 1)))),
            value: [selectedTime],
            onValueChanged: (value) => selectedTime = value.first,
          ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90,
                    width: 60,
                    child: CarouselSlider.builder(
                        itemCount: 12,
                        itemBuilder: (context, index, realIndex) => SizedBox(
                            height: 30,
                            child: Center(
                                child: Text(
                              '${index + 1}',
                              style: TextStyle(fontSize: 18, color: selectedHour==index+1?primaryColor:null, fontWeight: selectedHour==index+1?FontWeight.bold:null),
                            ))),
                        options: CarouselOptions(
                            scrollDirection: Axis.vertical,
                            onPageChanged:(index, reason) => setState(() => selectedHour=index+1),
                            viewportFraction: 0.4,
                            enlargeFactor: 0.2,
                            enlargeCenterPage: true)),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(
                        fontSize: 18,
                        color: primaryColor,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 90,
                    width: 60,
                    child: CarouselSlider.builder(
                        itemCount: 60,
                        itemBuilder: (context, index, realIndex) => SizedBox(
                            height: 30,
                            child: Center(
                                child: Text(
                              '$index',
                              style: TextStyle(fontSize: 18, color: selectedMinute==index?primaryColor:null, fontWeight: selectedMinute==index?FontWeight.bold:null,),
                            ))),
                        options: CarouselOptions(
                            onPageChanged:(index, reason) => setState(() => selectedMinute=index),
                            scrollDirection: Axis.vertical,
                            viewportFraction: 0.4,
                            enlargeFactor: 0.2,
                            enlargeCenterPage: true)),
                  ),
                  SizedBox(
                    height: 90,
                    width: 70,
                    child: CarouselSlider.builder(
                        itemCount: TimeMode.values.length,
                        itemBuilder: (context, index, realIndex) => SizedBox(
                            height: 30,
                            child: Center(
                                child: Text(
                              TimeMode.values[index].name,
                              style: TextStyle(fontSize: 18, color: selectedTimeMode==TimeMode.values[index]?primaryColor:null, fontWeight: selectedTimeMode==TimeMode.values[index]?FontWeight.bold:null,),
                            ))),
                        options: CarouselOptions(
                            scrollDirection: Axis.vertical,
                            onPageChanged:(index, reason) => setState(() => selectedTimeMode=TimeMode.values[index]),
                            viewportFraction: 0.4,
                            enableInfiniteScroll: false,
                            enlargeFactor: 0.2,
                            enlargeCenterPage: true)),
                  ),
                ],
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 130,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12)),
                              border: Border.all(
                                  color: primaryColor, width: 1.5)),
                        ),
                        Container(
                          width: 50,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                              border: Border.all(
                                  color: primaryColor, width: 1.5)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: CustomButton(
              fullWidth: true,
              buttonText: 'Continue',
              onPressed: onPressed,
            ),
          ),
          const SizedBox(height: 18,)
        ],
      ),
    );
  }
}
