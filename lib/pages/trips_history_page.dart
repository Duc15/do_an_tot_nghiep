import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện intl

class TripsHistoryPage extends StatefulWidget {
  const TripsHistoryPage({super.key});

  @override
  State<TripsHistoryPage> createState() => _TripsHistoryPageState();
}

class _TripsHistoryPageState extends State<TripsHistoryPage> {
  final completedTripRequestsOfCurrentUser =
      FirebaseDatabase.instance.ref().child("tripRequests");

  // Tỷ giá USD sang VND (giả sử)
  final double exchangeRate = 24000.0;

  // Hàm lấy paymentStartTime từ Firebase
  Future<String> getPaymentStartTime(String tripID) async {
    final paymentStartTimeRef = FirebaseDatabase.instance
        .ref()
        .child("tripRequests")
        .child(tripID)
        .child("paymentStartTime");

    DataSnapshot snapshot = await paymentStartTimeRef.get();
    if (snapshot.exists) {
      return snapshot.value as String;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Lịch sử chuyến',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: completedTripRequestsOfCurrentUser.onValue,
        builder: (BuildContext context, snapshotData) {
          if (snapshotData.hasError) {
            return const Center(
              child: Text(
                "Có lỗi xảy ra",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (!(snapshotData.hasData)) {
            return const Center(
              child: Text(
                "Không có chuyến đi nào!",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          Map dataTrips = snapshotData.data!.snapshot.value as Map;
          List tripsList = [];
          dataTrips
              .forEach((key, value) => tripsList.add({"key": key, ...value}));

          return ListView.builder(
            shrinkWrap: true,
            itemCount: tripsList.length,
            itemBuilder: ((context, index) {
              if (tripsList[index]["status"] != null &&
                  tripsList[index]["status"] == "ended" &&
                  tripsList[index]["userID"] ==
                      FirebaseAuth.instance.currentUser!.uid) {
                // Chuyển đổi giá trị fareAmount từ USD sang VND
                double fareUSD = double.tryParse(
                        tripsList[index]["fareAmount"].toString()) ??
                    0.0;
                double fareVND = fareUSD * exchangeRate;

                // Định dạng số tiền với dấu phẩy
                String formattedFareVND =
                    NumberFormat("#,##0", "en_US").format(fareVND);

                // Lấy paymentStartTime từ Firebase
                String paymentStartTime = '';
                getPaymentStartTime(tripsList[index]["key"]).then((value) {
                  setState(() {
                    paymentStartTime = value;
                  });
                });

                // Chuyển đổi paymentStartTime thành DateTime nếu có giá trị
                DateTime? paymentDateTime;
                if (paymentStartTime.isNotEmpty) {
                  paymentDateTime = DateTime.parse(paymentStartTime);
                }

                // Định dạng thời gian cho hiển thị
                String formattedTime = paymentDateTime != null
                    ? DateFormat('dd/MM/yyyy HH:mm').format(paymentDateTime)
                    : 'Chưa thanh toán';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the border radius as needed
                      side: const BorderSide(
                        color: Colors.blue, // Set the border color here
                        width: 2.0, // Set the border width here
                      ),
                    ),
                    color: Colors.white,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pickup and fare amount
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/initial.png',
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Text(
                                  tripsList[index]["pickUpAddress"].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "$formattedFareVND VND",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Dropoff address
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/final.png',
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Text(
                                  tripsList[index]["dropOffAddress"].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Payment start time
                          if (paymentDateTime != null)
                            Text(
                              "Thời gian thanh toán: $formattedTime",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.blue),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }),
          );
        },
      ),
    );
  }
}
