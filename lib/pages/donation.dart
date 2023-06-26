import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giveback/components/charity-card.dart';

class Donation extends StatefulWidget {
  const Donation({super.key});

  @override
  State<Donation> createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future getCharities() async {
    List charities = [];
    await db.collection('charities').get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        charities.add({...data, 'id': doc.id});
      }
    });
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
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      const Text(
                        'Available\nCharities',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Image.asset(
                        'images/undraw/photographer.png',
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ],
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
                    if (snapshot.hasData && snapshot.data.length > 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "List of Charities",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${snapshot.data!.length} Charities",
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
                                CharityCard(index: index, snapshot: snapshot),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    } else if (snapshot.hasData && snapshot.data.length == 0) {
                      return const Center(
                        child: Text(
                          "No Charities Available",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
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
