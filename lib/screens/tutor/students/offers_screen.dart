import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/models/tutorship_offer_model.dart';
import 'package:tutor_app/providers/tutorship_provider.dart';
import 'package:tutor_app/widgets/students/student_card.dart';
import 'package:tutor_app/widgets/students/tutorship_offer_tile.dart';

import '../../../constants/colors.dart';
import '../../../widgets/common/custom_appbar.dart';
import '../../../widgets/students/offer_card.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(
            title: 'Tutorship Offers',
            backgroundColor: Colors.transparent,
            canPop: true,
            centerTitle: true,
          ),
          true
              ? Expanded(
                  child: StreamBuilder<List<TutorshipOffer>>(
                    stream: Provider.of<TutorshipProvider>(context, listen: false).offerStream(context),
                    builder: (context, snapshot) {


                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator(),);
                      }
                      if(snapshot.data==null||snapshot.data!.isEmpty){
                        return Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(children: [
                          Text(
                            "You haven't received any offers for now.",
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
                        itemBuilder: (context, index) => OfferCard(offer: snapshot.data![index],),
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
