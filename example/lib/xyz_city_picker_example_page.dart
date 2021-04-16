import 'package:flutter/material.dart';
import 'package:xyz_city_picker/xyz_city_picker.dart';

class XYZCityPickerExamplePage extends StatelessWidget {
  const XYZCityPickerExamplePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return XYZCityPickerExamplePageContainer();
  }
}

class XYZCityPickerExamplePageContainer extends StatefulWidget {
  const XYZCityPickerExamplePageContainer({Key key}) : super(key: key);

  @override
  _XYZCityPickerExamplePageContainerState createState() => _XYZCityPickerExamplePageContainerState();
}

class _XYZCityPickerExamplePageContainerState extends State<XYZCityPickerExamplePageContainer> {
  Map province = {
    'name': '',
    'id': '',
  };
  Map city = {
    'name': '',
    'id': '',
  };
  Map district = {
    'name': '',
    'id': '',
  };
  Map street = {
    'name': '',
    'id': '',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(
      color: Color(0xFF4A4A4A),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('地址选择器'),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            color: Color(0xFFF7F7F7),
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - 60,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => XYZCityPicker.showPicker(
                      province: province,
                      city: city,
                      district: district,
                      street: street,
                      context: context,
                      onChange: (int index, Map checkedItem) {
                        switch (index) {
                          case 0:
                            this.setState(() {
                              province = checkedItem;
                            });
                            break;
                          case 1:
                            this.setState(() {
                              city = checkedItem;
                            });
                            break;
                          case 2:
                            this.setState(() {
                              district = checkedItem;
                            });
                            break;
                          case 3:
                            this.setState(() {
                              street = checkedItem;
                            });
                            break;
                        }
                      }),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(width: 70, child: Text('收货地址：', style: labelStyle)),
                            SizedBox(width: 30),
                            Container(
                              width: 200,
                              child: Text(
                                province['name'] == ''
                                    ? '选择所在地区'
                                    : province['name'] + city['name'] + district['name'] + street['name'],
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: 50,
                          child: Center(
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF000000),
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
