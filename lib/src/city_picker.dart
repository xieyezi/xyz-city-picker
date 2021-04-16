import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:xyz_city_picker/meta/city.dart';
import 'package:xyz_city_picker/meta/meta.dart';
import 'package:xyz_city_picker/meta/province.dart';
import 'package:xyz_city_picker/meta/town.dart';

/// 省市区选择器(使用示例见address_manage)
class CityPicker extends StatefulWidget {
  /// 省
  final Map province;

  /// 市
  final Map city;

  /// 区
  final Map district;

  // 街道
  final Map street;

  /// 选择事件
  final Function(int, Map) onChanged; // 参数分别为下标、id、name
  CityPicker({
    Key key,
    @required this.onChanged,
    @required this.province,
    @required this.city,
    @required this.district,
    @required this.street,
  }) : super(key: key);

  @override
  CityPickerState createState() => CityPickerState();
}

class CityPickerState extends State<CityPicker> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final ScrollController _controller = ScrollController();
  int _index = 0; // 当前下标
  var _positions = [0, 0, 0, 0]; // 三级联动选择的position
  List<Tab> _myTabs = <Tab>[Tab(text: '请选择'), Tab(text: ''), Tab(text: ''), Tab(text: '')]; // TabBar初始化3个，其中两个文字置空
  List _provinceList = []; // 省列表
  List _cityList = []; // 市列表
  List _districtList = []; // 区列表
  List _streetList = []; // 街道列表
  List _mList = []; // 当前列表数据

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _myTabs[0] =
          Tab(text: (widget.province == null || widget.province['name'] == '') ? '请选择' : widget.province['name']);
      _myTabs[1] = Tab(text: widget.city['name'] ?? '');
      _myTabs[2] = Tab(text: widget.district['name'] ?? '');
      _myTabs[3] = Tab(text: widget.street['name'] ?? '');
      _provinceList = provincesData ?? [];
      _mList = provincesData ?? [];
      _cityList = widget.city['name'] != '' ? findCityByProvinceName(widget.province['id']) : [];
      _districtList = widget.district['name'] != '' ? findCountyByCity(widget.city['id']) : [];
      _streetList = widget.street['name'] != '' ? findStreetByCounty(widget.district['id']) : [];
      _tabController.animateTo(_index, duration: Duration(microseconds: 0));
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setIndex(int index) {
    this.setState(() {
      _index = index;
    });
  }

  void setList(int index) {
    switch (index) {
      case 0:
        this.setState(() {
          _mList = _provinceList;
        });
        break;
      case 1:
        this.setState(() {
          _mList = _cityList;
        });

        break;
      case 2:
        this.setState(() {
          _mList = _districtList;
        });
        break;
      case 3:
        this.setState(() {
          _mList = _streetList;
        });
        break;
    }
  }

  void setListAndChangeTab(index) {
    switch (_index) {
      case 1:
        _mList = findCityByProvinceName(_mList[index]['id']);
        _cityList = _mList;
        _myTabs[1] = Tab(text: '请选择');
        _myTabs[2] = Tab(text: '');
        _myTabs[3] = Tab(text: '');
        setState(() {});
        break;
      case 2:
        _mList = findCountyByCity(_mList[index]['id']);
        _districtList = _mList;
        _myTabs[2] = Tab(text: '请选择');
        _myTabs[3] = Tab(text: '');
        setState(() {});
        break;
      case 3:
        _mList = findStreetByCounty(_mList[index]['id']);
        _districtList = _mList;
        _myTabs[3] = Tab(text: '请选择');
        setState(() {});
        break;
      case 4:
        _mList = _streetList;
        setState(() {});
        break;
    }
  }

  // 选中某个tab
  void checkedTab(int index) {
    // 将选中的返回到父组件
    widget.onChanged(_index, _mList[index]);
    this.setState(() {
      _myTabs[_index] = Tab(text: _mList[index]['name']);
      _positions[_index] = index;
      _index = _index + 1;
    });
    setListAndChangeTab(index);
    if (_index > 3) {
      setIndex(3);
      Navigator.pop(context);
    }
    _controller.animateTo(0.0, duration: Duration(milliseconds: 100), curve: Curves.ease);
    _tabController.animateTo(_index);
  }

  // 根据province寻找city
  List findCityByProvinceName(String provinceId) {
    List cityList = citiesData[provinceId] ?? [];
    return cityList;
  }

  // 根据city寻找county
  List findCountyByCity(String cityId) {
    List countyList = countiesData[cityId] ?? [];
    return countyList;
  }

// 根据county寻找street
  List findStreetByCounty(String countyId) {
    List streetList = townsData[countyId] ?? [];
    return streetList;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 11.0 / 16.0,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    '选择地址',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Positioned(
                  child: InkWell(
                    onTap: () => {Navigator.pop(context)},
                    child: SizedBox(
                      height: 16.0,
                      width: 16.0,
                      child: Icon(
                        Icons.close,
                        color: Color(0xFF000000),
                        size: 24.0,
                      ),
                    ),
                  ),
                  right: 16.0,
                  top: 16.0,
                  bottom: 16.0,
                )
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(),
                  Container(
                    // 隐藏点击效果
                    color: Colors.white,
                    child: TabBar(
                      tabs: _myTabs,
                      controller: _tabController,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Color(0xFFB80821),
                      unselectedLabelColor: Color(0xFF4A4A4A),
                      labelColor: Color(0xFFB80821),
                      labelPadding: EdgeInsets.symmetric(horizontal: 10),
                      onTap: (index) {
                        if (_myTabs[index].text.isEmpty) {
                          // 拦截点击事件
                          _tabController.animateTo(_index);
                          return;
                        }
                        setList(index);
                        setIndex(index);
                        _controller.animateTo(_positions[_index] * 48.0,
                            duration: Duration(milliseconds: 10), curve: Curves.ease);
                      },
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemExtent: 48.0,
                      itemBuilder: (_, index) {
                        bool flag = _mList[index]['name'] == _myTabs[_index].text;
                        return InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Text(_mList[index]['name'],
                                    style: flag
                                        ? TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFB80821),
                                          )
                                        : null),
                                SizedBox(height: 8),
                                Visibility(
                                  visible: flag,
                                  child: Icon(
                                    Icons.done,
                                    color: Color(0xFFB80821),
                                    size: 18.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () => checkedTab(index),
                        );
                      },
                      itemCount: _mList.length,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
