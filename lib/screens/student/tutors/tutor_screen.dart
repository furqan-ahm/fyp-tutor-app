import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/models/tutorship_model.dart';
import 'package:tutor_app/providers/tutorship_provider.dart';
import 'package:tutor_app/widgets/students/student_card.dart';
import 'package:tutor_app/widgets/students/tutorship_offer_tile.dart';

import '../../../constants/colors.dart';
import '../../../widgets/common/custom_appbar.dart';
import '../../../widgets/tutors/tutor_card.dart';

class TutorsScreen extends StatefulWidget {
  const TutorsScreen({Key? key}) : super(key: key);

  @override
  _TutorsScreenState createState() => _TutorsScreenState();
}

class _TutorsScreenState extends State<TutorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const CustomAppBar(
            title: 'Tutors',
            backgroundColor: Colors.transparent,
            canPop: false,
            centerTitle: true,
          ),
          const SizedBox(height: 5),
          true
              ? Expanded(
                  child: StreamBuilder<List<Tutorship>>(
                    stream: Provider.of<TutorshipProvider>(context, listen: false).tutorshipStreams(context),
                    builder: (context, snapshot) {

                      
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator(),);
                      }
                      if(snapshot.data==null||snapshot.data!.isEmpty){
                        return Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(children: [
                          Text(
                            "You dont have any tutors at the moment",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: bodyTextColor.withOpacity(0.5)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          
                        ]),
                      );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => TutorCard(tutorship: snapshot.data![index],),
                      );
                    }
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Image.asset('assets/images/inbox_placeholder.png'),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
