import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/global/global_var.dart';
import 'package:users_app/pages/home_page.dart';

class RateDriverScreen extends StatefulWidget {
  String assignedDriverId;

  RateDriverScreen({required this.assignedDriverId});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.white,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 22.0,
              ),
              const Text(
                "Đánh giá tài xế",
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 22.0,
              ),
              const Divider(
                height: 4.0,
                thickness: 4.0,
              ),
              const SizedBox(
                height: 22.0,
              ),
              SmoothStarRating(
                rating: countRatingStars,
                allowHalfRating: false,
                starCount: 5,
                color: Colors.yellow,
                borderColor: Colors.yellow,
                size: 46,
                onRatingChanged: (valueOfStarsChoosed) {
                  countRatingStars = valueOfStarsChoosed;

                  if (countRatingStars == 1) {
                    setState(() {
                      titleStarsRating = "Tồi tệ";
                    });
                  }
                  if (countRatingStars == 2) {
                    setState(() {
                      titleStarsRating = "Không tốt";
                    });
                  }
                  if (countRatingStars == 3) {
                    setState(() {
                      titleStarsRating = "Tốt";
                    });
                  }
                  if (countRatingStars == 4) {
                    setState(() {
                      titleStarsRating = "Rất tốt";
                    });
                  }
                  if (countRatingStars == 5) {
                    setState(() {
                      titleStarsRating = "Xuất sắc";
                    });
                  }
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                titleStarsRating,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    DatabaseReference rateDriverRef = FirebaseDatabase.instance
                        .ref()
                        .child("drivers")
                        .child(widget.assignedDriverId!)
                        .child("ratings");

                    Navigator.pop(context);
                    rateDriverRef.once().then((snap) {
                      if (snap.snapshot.value == null) {
                        rateDriverRef.set(countRatingStars.toString());

                        SystemNavigator.pop();
                      } else {
                        double pastRatings =
                            double.parse(snap.snapshot.value.toString());
                        double newAverageRatings =
                            (pastRatings + countRatingStars) / 2;
                        rateDriverRef.set(newAverageRatings.toString());

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }

                      //   ToastContext().init(context);
                      //   Toast.show("Vui lòng khởi động lại App",
                      //       duration: Toast.lengthShort, gravity: Toast.bottom);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 74),
                  ),
                  child: const Text(
                    "Gửi lời đánh giá",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
