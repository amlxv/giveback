import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giveback/main.dart';
import 'package:giveback/utils/misc.dart';
import 'package:giveback/utils/validation.dart';
import 'package:shimmer/shimmer.dart';

class SingleCharity extends StatefulWidget {
  final dynamic data;
  const SingleCharity({super.key, required this.data});

  @override
  State<SingleCharity> createState() => _SingleCharityState();
}

class _SingleCharityState extends State<SingleCharity> {
  String defaultImage = 'https://source.unsplash.com/random/?charity';
  String buttonText = "Donate";
  TextEditingController? amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future handleDonation() async {
    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;
    final uid = auth.currentUser!.uid;
    final amount = int.parse(amountController!.text);
    final charityId = widget.data['id'];

    await db.collection('donations').add({
      'amount': amount,
      'charity_id': charityId,
      'user_id': uid,
    }).then((value) {
      db.collection('charities').doc(charityId).update({
        'current': widget.data['current'] + amount,
      }).then((value) {
        setState(() {
          buttonText = "Donate";
        });
        pushMessage("Thank you for your donation!");
        push(context, const MyApp(currentIndex: 2));
      }).catchError((error) {
        pushMessage(error.toString());
      });
    }).catchError((error) {
      pushMessage(error.toString());
    });
  }

  handleButtonClick() async {
    if (buttonText == "Donate") {
      setState(() {
        buttonText = "Pay";
      });
    } else {
      validateInput("Amount", amountController!);

      if (amountController!.text.isNotEmpty) {
        await handleDonation();
      }
    }
  }

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
                      "$defaultImage-${widget.data['id']}",
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
            onPressed: handleButtonClick,
            height: 70,
          ),
        ),
      ),
    );
  }
}
