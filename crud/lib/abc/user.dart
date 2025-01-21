import 'package:crud/utils/string_constant.dart';

class User{
  List<Map<String, dynamic>> userList = [];

  void addUserInList({required name, required age, required email}) {
    Map<String, dynamic> map = {};
    map[NAME] = name;
    map[AGE] = age;
    map[EMAIL] = email;
    userList.add(map);
  }

  List<Map<String, dynamic>> getUserList() {
    return userList;
  }

  void updateUser(
      {required name, city, phoneNumber, required email, required id}) {
    Map<String, dynamic> map = {};
    map[NAME] = name;
    map[CITY] = city;
    map[EMAIL] = email;
    map[PHONE] = phoneNumber;
    userList[id] = map;

  }

  void deleteUser(id) {
    userList.removeAt(id);
  }

  void searchDetail({required searchData}) {
    for (var element in userList) {
      if (element[NAME]
          .toString()
          .toLowerCase()
          .contains(searchData.toString().toLowerCase()) ||
          element[CITY]
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase()) ||
          element[EMAIL]
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase())) {
        printResultText(
            '${element[NAME]} . ${element[AGE]} . ${element[EMAIL]}');
      }
    }
  }
}