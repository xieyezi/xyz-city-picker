# xyz_address_picker

一个仿京东的flutter 地址选择器

**<u>[点这里查看版本更新记录](https://pub.dev/packages/xyz_address_picker/changelog)</u>**


### 导航
- [Gif效果图](#Gif效果图)
- [如何使用](#如何使用)


### Gif效果图

<a target="_blank" rel="noopener noreferrer" href="https://i.loli.net/2020/07/16/Y5rDLqWZUd2X3yw.gif"><img src="https://i.loli.net/2020/07/16/Y5rDLqWZUd2X3yw.gif" width="400" height="860" align="center" style="max-width:100%;"></a>

### 如何使用
目前已发布到Pub，你可以在Pub官网查看最新的版本和更新说明！[点我去Pub官网查看](https://pub.dev/packages/xyz_address_picker)
#### 1、添加xyz_address_picker package
打开pubspec.yaml文件
添加如下代码
``` dart
  xyz_address_picker : ^1.0.1
```
添加后打开Terminal，执行flutter packages get

#### 2、使用

**强烈建议你先clone下本仓库，查看example目录的内容**

必须传入的参数有:

| 参数         | 含义       |
| ------------ | ---------- |
| province     | 选择的省份 |
| city         | 选择的城市 |
| street       | 选择的街道 |
| provinceList | 省份列表   |
| cityList     | 城市列表   |
| districtList | 街道列表   |

> 注意：xyz_address_picker 因为是弹出框，所以需要配合showModalBottomSheet使用
使用如下：
```dart
  /// 省市区选择器
  void _showBottomSheet({
    String province,
    String city,
    String street,
    List provinceList,
    List cityList,
    List streetList,
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
          provinceList: provinceList,
          cityList: cityList,
          districtList: streetList,
          onChanged: onChnage,
        );
      },
    );
  }
```
在`AddressPicker`的`onChanged`回调函数里面把选择的值带回，`onChanged`的函数签名如下：
```dart
typedef MyOnChange = Function(int index, String id, String name);
```
其中`index` 为`0`、`1`、`2`，分别标识`province`、`city`、`district` ，`id`和`name`则为对应的值。


### 如你想接收更新消息，你可以Watch下，有问题请提到Issues.

### 开源不易😄😄😄，麻烦给个Star⭐️吧！我会根据大家的关注度和个人时间持续更新代码！
