import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/providers/tutorship_provider.dart';
import 'package:tutor_app/screens/student/tutors/search_result_screen.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/utils/validation_utils.dart';
import 'package:tutor_app/widgets/assignment/pick_datetime_dialog.dart';
import 'package:tutor_app/widgets/common/custom_appbar.dart';
import 'package:tutor_app/widgets/common/custom_button.dart';
import 'package:tutor_app/widgets/common/custom_textfield.dart';
import 'package:tutor_app/widgets/common/max_sized_container.dart';
import 'package:tutor_app/widgets/tutors/searched_tutor_card.dart';

import '../../../constants/colors.dart';
import '../../../widgets/common/min_sized_container.dart';

class FindTutorScreen extends StatefulWidget {
  const FindTutorScreen({Key? key}) : super(key: key);

  @override
  _FindTutorScreenState createState() => _FindTutorScreenState();
}

class _FindTutorScreenState extends State<FindTutorScreen> {



  TextEditingController search=TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<TutorshipProvider>(context, listen: false)
          .loadSuggestedTutors(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: MinSizedContainer(
            safePadding: MediaQuery.of(context).padding,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find a',
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 18),
                      ),
                      Text('Suitable Tutor',
                          style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 19)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    child: Column(
                      children: [
                        CustomFormField(
                          labelText: 'Search Relevant Subject',
                          primaryColor: primaryColor,
                          controller: search,
                          textColor: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          onPressed: () async {
                            if(search.text.isNotEmpty){
                              Navigator.push(context, MaterialPageRoute(builder:(context) => SearchResultScreen(subject: search.text),));
                            }
                          },
                          fullWidth: true,
                          buttonText: 'Search',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Suggested Tutors',
                      style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 19)),
                ),
                Consumer<TutorshipProvider>(
                  builder: (context, tutorProv, child) => tutorProv.loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: tutorProv.suggestedTutors.length,
                          itemBuilder: (context, index)=>SearchedTutorCard(tutor: tutorProv.suggestedTutors[index]),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
