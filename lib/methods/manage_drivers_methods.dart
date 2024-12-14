import 'package:users_app/models/online_nearby_drivers.dart';

class ManageDriversMethods {
  static List<OnlineNearbyDrivers> nearbyOnlineDriversList = [];
//Loại bỏ một tài xế khỏi danh sách tài xế trực tuyến gần đó.
  static void removeDriverFromList(String driverID) {
    int index = nearbyOnlineDriversList
        .indexWhere((driver) => driver.uidDriver == driverID);

    if (nearbyOnlineDriversList.length > 0) {
      nearbyOnlineDriversList.removeAt(index);
    }
  }

//Cập nhật thông tin vị trí (toạ độ) của một tài xế trong danh sách.
  static void updateOnlineNearbyDriversLocation(
      OnlineNearbyDrivers nearbyOnlineDriverInformation) {
    int index = nearbyOnlineDriversList.indexWhere((driver) =>
        driver.uidDriver == nearbyOnlineDriverInformation.uidDriver);

    nearbyOnlineDriversList[index].latDriver =
        nearbyOnlineDriverInformation.latDriver;
    nearbyOnlineDriversList[index].lngDriver =
        nearbyOnlineDriverInformation.lngDriver;
  }
}
