import 'package:get/state_manager.dart';
class BottomNavBarController extends GetxController {
  var SelectedIndex = 0.obs;
  var textValue = 0.obs;

  void ChangedIndex(int Index) {
    SelectedIndex.value=Index;
  }

  void IncreaseValue(){
    textValue.value++;
  }
}
