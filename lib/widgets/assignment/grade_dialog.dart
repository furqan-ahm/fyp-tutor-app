import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/models/assignment_model.dart';
import 'package:tutor_app/providers/assignment_provider.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/utils/utils.dart';
import 'package:tutor_app/widgets/common/custom_button.dart';
import 'package:tutor_app/widgets/common/custom_textfield.dart';

class GradeDialog extends StatefulWidget {
  const GradeDialog({Key? key, required this.assignment}) : super(key: key);

  final Assignment assignment;

  @override
  _GradeDialogState createState() => _GradeDialogState();
}

class _GradeDialogState extends State<GradeDialog> {


  TextEditingController points=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Grade Assignment",
                style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: primaryColor),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: primaryColor),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          widget.assignment.student.getProfilePictureURL,
                        ))),
              ),
              Text(
                widget.assignment.student.name,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    'Title: ',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  Text(
                    widget.assignment.name,
                    style:
                        theme.textTheme.headlineMedium?.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Total Points: ',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  Text(
                    widget.assignment.points.toString(),
                    style:
                        theme.textTheme.headlineMedium?.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Obtained Points: ',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  Expanded(
                    child: CustomFormField(
                      controller: points,
                      labelText: '',
                      textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                buttonText: 'Submit',
                fullWidth: true,
                onPressed: ()async{
                  try {
                    var ObtPoints=double.parse(points.text);


                    if(await AssignmentProvider.of(context).gradeAndCloseAssignment(widget.assignment, ObtPoints)){
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    print(e);
                    Utils.showSnackbar('Add proper points', context);
                    return false; 
                  }
                },
              ),
              CustomButton(
                buttonText: 'Cancel',
                onPressed: ()async{
                  Navigator.pop(context, false);
                },
                fullWidth: true,
                backgroundColor: Colors.transparent,
                foregroundColor: primaryColor,
                elevation: 0,
              ),
            ],
          ),
        ));
  }
}
