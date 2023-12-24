import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'categories_screen.dart'; // Assuming you have a CategoriesScreen
import 'profile_screen.dart'; // Assuming you have a ProfileScreen
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends ConsumerStatefulWidget {
  MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  String temperature = "Loading...";
  final Uri url1 = Uri.parse('https://www.yonsei.ac.kr/sc/');
  final Uri url2 = Uri.parse('https://devcms.yonsei.ac.kr/gld_new/index.do');
  final Uri url3 = Uri.parse('https://portal.yonsei.ac.kr/');
  final Uri url4 = Uri.parse('https://ys.learnus.org/');
  final Uri url5 = Uri.parse('https://library.yonsei.ac.kr/');
  final Uri url6 = Uri.parse('https://aie.yonsei.ac.kr/aie/');

  @override
  void initState() {
    super.initState();
    fetchTemperature();
  }

  Future<void> fetchTemperature() async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=Seoul&appid=b5b354e426ce56f552178be3597ac5eb'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      double tempInKelvin = data['main']['temp'];
      double tempInCelsius = tempInKelvin - 273.15; // Kelvin to Celsius conversion
      setState(() {
        temperature = "${tempInCelsius.toStringAsFixed(2)} °C";
      });
    } else {
      setState(() {
        temperature = "Error fetching weather";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('패트와매트 OUTSIDE'),
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/main');
              break;
            case 1:
              Navigator.pushNamed(context, '/post');
              break;
            case 2:
              Navigator.pushNamed(context, '/account');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '계정',
          ),
        ],
        currentIndex: 0,
        elevation: 0,
        iconSize: 25,
        selectedItemColor: const Color(0xff3a57e8),
        unselectedItemColor: const Color(0xff9e9e9e),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: const Text('게시판 목록'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriesScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('계정'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            // Add more list tiles if needed
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '서울의 오늘 날씨: $temperature',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        child: Text(
                          "학교 웹사이트 모음",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {launchUrl(url1);},
                              icon: Icon(
                                Icons.account_balance,
                                color: Color(0xff212435),
                                size: 24,
                              ),
                              label: Text("연대 홈"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {launchUrl(url2);},
                              icon: Icon(
                                Icons.school,
                                color: Color(0xff212435),
                                size: 24,
                              ),
                              label: Text("글인 홈"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {launchUrl(url2);},
                              icon: Icon(
                                Icons.web,
                                color: Color(0xff212435),
                                size: 24,
                              ),
                              label: Text("학사 포털"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {launchUrl(url3);},
                              icon: Icon(
                                Icons.folder,
                                color: Color(0xff212435),
                                size: 24,
                              ),
                              label: Text("런어스"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {launchUrl(url5);},
                              icon: Icon(
                                Icons.book,
                                color: Color(0xff212435),
                                size: 24,
                              ),
                              label: Text("도서관"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {launchUrl(url6);},
                              icon: Icon(
                                Icons.science,
                                color: Color(0xff212435),
                                size: 24,
                              ),
                              label: Text("응정 홈"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "켈린더",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                      ),
                      CalendarDatePicker(
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(2050),
                        onDateChanged: (date) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
