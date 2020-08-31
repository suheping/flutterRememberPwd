import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fdemo/main_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => MainProvider(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  TextEditingController nameController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
  GlobalKey _key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
          title: 'test',
          theme: ThemeData(primaryColor: Colors.blue),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              title: Text('tst'),
            ),
            body: Stack(
              children: [
                // 登录表单
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        // 用户名输入框
                        TextField(
                          key: _key,
                          controller: nameController,
                          decoration: InputDecoration(hintText: '用户名'),
                          onTap: () async {
                            // 点击用户名输入框，弹出已保存的用户名列表
                            Provider.of<MainProvider>(context, listen: false)
                                .clickName(true);
                            Provider.of<MainProvider>(context, listen: false)
                                .getPosition(_key);
                            // 筛选
                            String value = nameController.text;
                            Provider.of<MainProvider>(context, listen: false)
                                .filterLoginMap(value);
                          },
                          onChanged: (value) {
                            // 输入时，对用户名列表进行筛选
                            Provider.of<MainProvider>(context, listen: false)
                                .filterLoginMap(value);
                          },
                          onEditingComplete: () {
                            Provider.of<MainProvider>(context, listen: false)
                                .clickName(false);
                          },
                          onSubmitted: (value) {
                            Provider.of<MainProvider>(context, listen: false)
                                .clickName(false);
                          },
                        ),
                        // 密码输入框
                        TextField(
                          controller: pwdController,
                          obscureText: true,
                          decoration: InputDecoration(hintText: '密码'),
                          onTap: () {
                            Provider.of<MainProvider>(context, listen: false)
                                .clickName(false);
                          },
                        ),
                        // 记住密码checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: Provider.of<MainProvider>(context)
                                  .rememberInfo,
                              onChanged: (value) {
                                Provider.of<MainProvider>(context,
                                        listen: false)
                                    .setRemember(value);
                              },
                            ),
                            Text('记住密码')
                          ],
                        ),
                        // 登录按钮
                        RaisedButton(
                          onPressed: () async {
                            // 登录，默认成功，忽略实现
                            // login();
                            if (Provider.of<MainProvider>(context,
                                    listen: false)
                                .rememberInfo) {
                              // 如果勾选了记住密码，登录保存用户信息
                              String loginName = nameController.text.trim();
                              String loginPwd = pwdController.text.trim();
                              await Provider.of<MainProvider>(context,
                                      listen: false)
                                  .saveLoginInfo(loginName, loginPwd);
                            }
                            Provider.of<MainProvider>(context, listen: false)
                                .clickName(false);
                          },
                          child: Text('登录'),
                        ),
                        RaisedButton(
                          child: Text('删除用户信息'),
                          onPressed: () async {
                            Provider.of<MainProvider>(context, listen: false)
                                .removeOneKey();
                          },
                        )
                      ],
                    ),
                  ),
                ),
                // 用户名列表
                Positioned(
                    left: Provider.of<MainProvider>(context).offSet.dx,
                    top: Provider.of<MainProvider>(context).offSet.dy,
                    child: Provider.of<MainProvider>(context).isClickName
                        ? loginNameList(
                            context,
                            Provider.of<MainProvider>(context).loginInfoMap,
                            nameController,
                            pwdController)
                        : Container())
              ],
            ),
          )),
    );
  }

  // 用户名列表
  Widget loginNameList(
      BuildContext context,
      Map loginJson,
      TextEditingController nameController,
      TextEditingController pwdController) {
    List _loginNameList = [];
    List _loginPwdList = [];
    for (var item in loginJson.keys) {
      _loginNameList.add(item);
      _loginPwdList.add(loginJson[item]);
    }
    if (_loginNameList.length == 0) {
      return Container();
    } else {
      return Stack(
        children: [
          // 列表
          Container(
            height: 100,
            width: 300,
            decoration: BoxDecoration(color: Colors.blue),
            child: ListView.builder(
              itemCount: _loginNameList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Provider.of<MainProvider>(context, listen: false)
                        .clickName(false);
                    nameController.text = _loginNameList[index];
                    pwdController.text = _loginPwdList[index];
                  },
                  child: Container(
                    height: 30,
                    width: 300,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue, width: 1)),
                    child: Text(
                      _loginNameList[index],
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          // 右上角关闭按钮
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                Provider.of<MainProvider>(context, listen: false)
                    .clickName(false);
              },
              child: Text(
                'X',
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),
            ),
          )
        ],
      );
    }
  }
}
