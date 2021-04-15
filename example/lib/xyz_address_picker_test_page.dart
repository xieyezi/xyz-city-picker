import 'package:flutter/material.dart';
import 'package:xyz_address_picker/xyz_address_picker.dart';

class XYZAddressPickerTestPage extends StatelessWidget {
  const XYZAddressPickerTestPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return XYZAddressPickerTestPageContainer();
  }
}

class XYZAddressPickerTestPageContainer extends StatefulWidget {
  const XYZAddressPickerTestPageContainer({Key key}) : super(key: key);

  @override
  _XYZAddressPickerTestPageContainerState createState() => _XYZAddressPickerTestPageContainerState();
}

typedef MyOnChange = Function(int index, String id, String name);

class _XYZAddressPickerTestPageContainerState extends State<XYZAddressPickerTestPageContainer> {
  String province = '';
  String city = '';
  String street = '';

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
                  onTap: () => _showBottomSheet(
                    province: province,
                    city: city,
                    context: context,
                    onChnage: (int index, String id, String name) {
                      print('$index-$id-$name');

                      switch (index) {
                        case 0:
                          this.setState(() {
                            province = name;
                          });
                          break;
                        case 1:
                          this.setState(() {
                            city = name;
                          });
                          break;
                        case 2:
                          this.setState(() {
                            street = name;
                          });
                          break;
                      }
                    },
                  ),
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
                            Text(province == '' ? '选择所在地区' : province + city + street)
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

  /// 省市区选择器
  void _showBottomSheet({
    String province,
    String city,
    String street,
    BuildContext context,
    MyOnChange onChnage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddressPicker(
          province: province,
          city: city,
          district: street,
          onChanged: onChnage,
        );
      },
    );
  }
}
