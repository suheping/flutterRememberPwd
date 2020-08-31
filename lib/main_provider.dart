import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider with ChangeNotifier {
  bool _isClickName = false;
  Map _loginInfoMap = {};
  bool _rememberInfo = false;
  Offset _offset = new Offset(50, 300);

  clickName(bool b) async {
    _isClickName = b;
    if (b) {
      // 持久化
      SharedPreferences sf = await SharedPreferences.getInstance();
      // 首先获取
      String loginInfo = sf.getString('loginInfo');
      Map loginJson = {};
      if (loginInfo == null) {
        loginJson = {};
      } else {
        loginJson = json.decode(loginInfo);
      }
      _loginInfoMap = loginJson;
    }
    notifyListeners();
  }

  // 保存用户名密码到sharedPreferences
  saveLoginInfo(String loginName, String loginPwd) async {
    // 持久化
    SharedPreferences sf = await SharedPreferences.getInstance();
    // 首先获取
    String loginInfo = sf.getString('loginInfo');
    Map loginJson = {};
    if (loginInfo == null) {
      loginJson = {};
    } else {
      loginJson = json.decode(loginInfo);
    }
    // 将用户信息加入到loginJson
    loginJson[loginName] = loginPwd;
    // 写入持久化
    await sf.setString('loginInfo', json.encode(loginJson));
    _loginInfoMap = loginJson;
    notifyListeners();
  }

  // 输入用户名时，对用户名列表进行筛选
  filterLoginMap(String value) async {
    await clickName(true);
    var _keys = _loginInfoMap.keys;
    Map _newMap = {};
    for (String item in _keys) {
      if (item.indexOf(value) == -1) {
        // 未匹配到
      } else {
        // 匹配到了
        _newMap[item] = _loginInfoMap[item];
      }
    }
    _loginInfoMap = _newMap;
    notifyListeners();
  }

  removeOneKey() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.remove('loginInfo');
  }

  setRemember(bool remember) {
    _rememberInfo = remember;
    notifyListeners();
  }

  getPosition(GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    // _offset = renderBox.localToGlobal(Offset(0.0, renderBox.size.height));
    _offset = renderBox.localToGlobal(Offset.zero);
    print(_offset.dx);
    print(_offset.dy);
    notifyListeners();
  }

  bool get isClickName => _isClickName;
  Map get loginInfoMap => _loginInfoMap;
  bool get rememberInfo => _rememberInfo;
  Offset get offSet => _offset;
}
