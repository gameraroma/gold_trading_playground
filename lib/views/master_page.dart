import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/providers/providers.dart';
import 'package:gold_trading_playground/views/assets_page.dart';
import 'package:gold_trading_playground/views/my_home_page.dart';

class MasterPage extends ConsumerStatefulWidget {
  const MasterPage({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MasterPage> {
  String _title = 'ราคาทอง';
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    AssetsPage()
  ];

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(changeMasterTabProvider);
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(changeMasterTabProvider);
    if (tabIndex == 0) {
      _title = 'ราคาทอง';
    } else {
      _title = 'ทองของฉัน';
    }
    _selectedIndex = tabIndex;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'ทอง',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[400],
        unselectedItemColor: Colors.white,
        onTap: (index) {
          ref.read(changeMasterTabProvider.state).state = index;
        },
      ),
    );
  }
}