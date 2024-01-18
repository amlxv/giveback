import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giveback/utils/misc.dart';
import 'package:giveback/utils/validation.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SingleCharity extends StatefulWidget {
  final dynamic data;
  const SingleCharity({super.key, required this.data});

  @override
  State<SingleCharity> createState() => _SingleCharityState();
}

class _SingleCharityState extends State<SingleCharity> {
  String defaultImage = 'https://picsum.photos/seed';
  String buttonText = "Donate";
  String paymentLink = "";
  TextEditingController? amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  handleButtonClick(BuildContext context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    /** Get the user phone number. **/
    var phoneNumber =
        await db.collection('users').doc(auth.currentUser?.uid).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.data() == null) return;
        final userRef = documentSnapshot.data() as Map<String, dynamic>;
        if (userRef["phone"] == null) return;
        return userRef["phone"];
      },
      onError: (Object? error) => pushMessage(error.toString()),
    );

    /** Verify the user has a phone number. Requirement from payment gateway. **/
    if (phoneNumber == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Please provide your phone number in the profile section to start donating."),
        ),
      );
      return;
    }

    /** Dynamically change the button behaviour **/
    if (buttonText == "Donate") {
      setState(() {
        buttonText = "Confirm";
      });
    } else if (buttonText == "Confirm") {
      validateInput("Amount", amountController!);

      if (amountController!.text.isNotEmpty) {
        if (!context.mounted) return;
        await handleDonation(context);

        setState(() {
          buttonText = "Pay";
        });
      }
    } else if (buttonText == "Pay") {
      /** Redirect the user to the payment page **/
      final Uri url = Uri.parse(paymentLink);

      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  Future handleDonation(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;
    final uid = auth.currentUser!.uid;
    final amount = int.parse(amountController!.text);
    final charityId = widget.data['id'];

    final userId = uid;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final paymentId = uid.toString() +
        charityId.toString() +
        amount.toString() +
        DateTime.now().millisecondsSinceEpoch.toString();

    try {
      final result = await db.collection('donations').add({
        'email': FirebaseAuth.instance.currentUser?.email,
        'amount': amount,
        'charity_id': charityId,
        'user_id': uid,
        'timestamp': timestamp,
        'payment_id': paymentId,
        'is_paid': false
      });

      if (!context.mounted) return;
      final paymentLinkResult = await getBillLink(context, result.id);

      if (paymentLinkResult is String) {
        paymentLink = paymentLinkResult;
      }
    } on Exception catch (error) {
      pushMessage(error.toString());
    }
  }

  getBillLink(BuildContext context, donationId) async {
    try {
      return await createBill(donationId);
    } on Exception catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString().substring(11))));
    }
  }

  Future<String> createBill(String donationId) async {
    final response = await http.post(
      Uri.parse('http://192.168.154.58'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'donation_id': donationId,
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to create payment link.');
    }
  }

  // void paymentSuccess() {
  //   final auth = FirebaseAuth.instance;
  //   final db = FirebaseFirestore.instance;
  //   final amount = int.parse(amountController!.text);
  //   final charityId = widget.data['id'];
  //
  //   db.collection('charities').doc(charityId).update({
  //     'current': widget.data['current'] + amount,
  //   }).then((value) {
  //     setState(() {
  //       buttonText = "Donate";
  //     });
  //     pushMessage("Thank you for your donation!");
  //     push(context, const MyApp(currentIndex: 2));
  //   }).catchError((error) {
  //     pushMessage(error.toString());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: widget.data['id'],
                child: CachedNetworkImage(
                  imageUrl: widget.data['image'] ??
                      "$defaultImage/${widget.data['id']}/500",
                  width: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                    height: double.infinity,
                    width: 80,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 20,
                        width: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.data['title']}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'By, ',
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                      children: [
                        TextSpan(
                          text: '${widget.data['by']}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "RM ${widget.data['current']}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(
                          text: " raised from ",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        TextSpan(
                          text: "RM ${widget.data['target']}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 10,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: widget.data['current'] / widget.data['target'],
                        color: Colors.deepPurple,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 30),
                  (buttonText == "Donate")
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'About',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${widget.data['desc']}',
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Amount',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: amountController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.attach_money),
                                hintText: "100",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "All donations are in Ringgit Malaysia (RM).",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SubmitButton(
            labelText: buttonText,
            onPressed: () => handleButtonClick(context),
            height: 70,
          ),
        ),
      ),
    );
  }
}
