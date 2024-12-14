import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thư viện định dạng số
import 'package:users_app/widgets/ratings_dialog.dart';
import '../methods/common_methods.dart';

class PaymentDialog extends StatefulWidget {
  String fareAmount;
  String driverID;

  PaymentDialog({
    super.key,
    required this.fareAmount,
    required this.driverID,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  CommonMethods cMethods = CommonMethods();

  // Tỷ giá USD sang VND (giả sử)
  final double exchangeRate = 24000.0;

  @override
  Widget build(BuildContext context) {
    // Chuyển đổi số tiền từ USD sang VND
    double fareUSD = double.tryParse(widget.fareAmount) ?? 0.0;
    double fareVND = fareUSD * exchangeRate;

    // Định dạng số tiền VND với dấu phẩy
    String formattedFareVND = NumberFormat("#,##0", "en_US").format(fareVND);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.black54,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 21,
            ),
            const Text(
              "Trả tiền",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 21,
            ),
            const Divider(
              height: 1.5,
              color: Colors.white70,
              thickness: 1.0,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "$formattedFareVND VND",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Bạn sẽ trả số tiền là $formattedFareVND VND cho tài xế?",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 31,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, "paid");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RateDriverScreen(
                      assignedDriverId: widget.driverID,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Đã trả",
              ),
            ),
            const SizedBox(
              height: 41,
            )
          ],
        ),
      ),
    );
  }
}
