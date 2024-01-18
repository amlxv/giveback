import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giveback/components/charity-slider-card.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  final Function? updateIndex;
  const Home({super.key, this.updateIndex});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future getCharities() async {
    List<Widget> charities = [];
    await db.collection('charities').get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        if (charities.length > 2) break;
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        charities.add(
            CharitySliderCard(data: {...data, 'id': doc.id}, from: 'home'));
      }
    }).onError((error, stacktrace) => null);
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
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                child: Image.asset(
                  'images/illustrations/home.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Image.asset(
                'images/illustrations/home.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 20,
                right: 0,
                bottom: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://picsum.photos/seed/${FirebaseAuth.instance.currentUser?.displayName ?? 'random'}/50',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => SizedBox(
                                  height: double.infinity,
                                  width: 80,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder(
                                stream: auth.authStateChanges(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      "Hi, ${FirebaseAuth.instance.currentUser?.displayName ?? ''}!",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                  return const Text(
                                    "Hi, there!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Let's give back to the community!",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.only(
                                right: 20,
                                top: 10,
                                bottom: 10,
                                left: 60,
                              ),
                              child: StreamBuilder(
                                stream: db
                                    .collection('donations')
                                    .where('user_id',
                                        isEqualTo: auth.currentUser?.uid)
                                    .where('is_paid',
                                        isEqualTo: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'RM ${snapshot.data!.docs.fold(0, (previousValue, element) => previousValue + element['amount'] as int).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const WidgetSpan(
                                            child: SizedBox(width: 5),
                                          ),
                                          const TextSpan(
                                            text: ' total donation',
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              )),
                          CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade200,
                            radius: 25,
                            child: CircleAvatar(
                              backgroundColor: Colors.deepPurple.shade500,
                              radius: 20,
                              child: const Icon(
                                Icons.attach_money_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Newest',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => widget.updateIndex!(1),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'View all',
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(width: 5),
                            ),
                            WidgetSpan(
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 15,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 230,
                  child: FutureBuilder(
                    future: getCharities(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return CarouselSlider(
                          items: snapshot.data,
                          options: CarouselOptions(
                            height: 230.0,
                            autoPlay: true,
                            viewportFraction: 0.8,
                            aspectRatio: 2.0,
                            clipBehavior: Clip.hardEdge,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.scale,
                            disableCenter: true,
                          ),
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
