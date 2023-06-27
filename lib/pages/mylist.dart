import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giveback/components/charity-card.dart';

class MyList extends StatefulWidget {
  const MyList({super.key});

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List> getDonations() async {
    List donations = [];
    await db
        .collection('donations')
        .where('user_id', isEqualTo: auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        donations.add({...data, 'id': doc.id});
      }
    });
    return donations;
  }

  Future<List> getCharities() async {
    List donations = await getDonations();
    List charities = [];

    for (var donation in donations) {
      await db
          .collection('charities')
          .doc(donation['charity_id'])
          .get()
          .then((DocumentSnapshot snapshot) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        charities
            .add({...data, 'id': snapshot.id, 'amount': donation['amount']});
      }).catchError((error) => null);
    }
    return charities;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -35,
                right: 0,
                bottom: 0,
                left: 0,
                child: Image.asset(
                  'images/illustrations/charity.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Image.asset(
                'images/illustrations/charity.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              const Positioned(
                top: -20,
                right: 0,
                bottom: 0,
                left: 0,
                child: Center(
                  child: Text(
                    'My Donations',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder(
                  future: getCharities(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "List of Donations",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${snapshot.data!.length} Donations",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) =>
                                CharityCard(data: snapshot.data?[index]),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text(
                            "You haven't donated yet.",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
