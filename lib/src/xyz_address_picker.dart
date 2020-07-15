import 'package:flutter/material.dart';

/// 省市区选择器(使用示例见address_manage)
class AddressPicker extends StatefulWidget {
  /// 省
  final String province;

  /// 市
  final String city;

  /// 区
  final String district;

  /// 省列表
  final List provinceList;

  /// 市列表
  final List cityList;

  /// 区列表
  final List districtList;

  /// 选择事件
  final Function(int, String, String) onChanged; // 参数分别为下标、id、name
  const AddressPicker({
    Key key,
    @required this.onChanged,
    @required this.province,
    @required this.city,
    @required this.district,
    @required this.provinceList,
    @required this.cityList,
    @required this.districtList,
  }) : super(key: key);

  @override
  AddressPickerState createState() => AddressPickerState();
}

class AddressPickerState extends State<AddressPicker> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final ScrollController _controller = ScrollController();
  int _index = 0; // 当前下标
  var _positions = [0, 0, 0]; // 三级联动选择的position
  List<Tab> _myTabs = <Tab>[Tab(text: '请选择'), Tab(text: ''), Tab(text: '')]; // TabBar初始化3个，其中两个文字置空
  List _provinceList = []; // 省列表
  List _cityList = []; // 市列表
  List _districtList = []; // 区列表
  List _mList = []; // 当前列表数据

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initData();
      // 设置默认值
      _myTabs[0] = Tab(text: widget.province == '' || widget.province == null ? '请选择' : widget.province);
      _myTabs[1] = Tab(text: widget.city ?? '');
      _myTabs[2] = Tab(text: widget.district ?? '');
      _provinceList = widget.provinceList ?? [];
      _cityList = widget.cityList ?? [];
      _districtList = widget.districtList ?? [];
      _mList = widget.provinceList ?? [];
      _tabController.animateTo(_index, duration: const Duration(microseconds: 0));
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
    }
  }

  void setListAndChangeTab() {
    switch (_index) {
      case 1:
        this.setState(() {
          _mList = _cityList;
          _myTabs[1] = Tab(text: '请选择');
          _myTabs[2] = Tab(text: '');
        });
        break;
      case 2:
        this.setState(() {
          _mList = _districtList;
          _myTabs[2] = Tab(text: '请选择');
        });
        break;
      case 3:
        this.setState(() {
          _mList = _districtList;
        });
        break;
    }
  }

  // 选中某个tab
  void checkedTab(int index) {
    // 将选中的返回到父组件
    widget.onChanged(_index, _mList[index]['id'], _mList[index]['name']);
    this.setState(() {
      _myTabs[_index] = Tab(text: _mList[index]['name']);
      _positions[_index] = index;
      _index = _index + 1;
    });
    setListAndChangeTab();
    if (_index > 2) {
      setIndex(2);
      // MyNavigator.pop(context: context);
    }
    _controller.animateTo(0.0, duration: Duration(milliseconds: 100), curve: Curves.ease);
    _tabController.animateTo(_index);
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Text(
                    '地址选择',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Positioned(
                  child: InkWell(
                    onTap: () => {},
                    child: const SizedBox(
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
                      controller: _tabController,
                      isScrollable: true,
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
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Color(0xFFB80821),
                      unselectedLabelColor: Color(0xFF4A4A4A),
                      labelColor: Color(0xFFB80821),
                      tabs: _myTabs,
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
