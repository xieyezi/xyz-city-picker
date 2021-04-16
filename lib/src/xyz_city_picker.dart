import 'package:flutter/material.dart';
import './city_picker.dart';

typedef OnChange = Function(int index, Map checkedItem);

class XYZCityPicker {
  static void showPicker({
    Map province,
    Map city,
    Map district,
    Map street,
    BuildContext context,
    OnChange onChange,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CityPicker(
          province: province,
          city: city,
          district: district,
          street: street,
          onChanged: onChange,
        );
      },
    );
  }
}
