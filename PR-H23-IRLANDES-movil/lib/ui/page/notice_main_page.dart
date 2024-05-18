import 'package:flutter/material.dart';
import 'package:irlandes_app/data/model/notice_model.dart';
import 'package:irlandes_app/data/model/person_model.dart';
import 'package:irlandes_app/data/remote/notice_remote_datasource.dart';
import 'package:irlandes_app/data/remote/user_remote_datasource.dart';
import 'package:irlandes_app/ui/widgets/app_bar_custom_notification.dart';
import 'package:irlandes_app/ui/widgets/custom_text_filed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeMainPage extends StatefulWidget {
  const NoticeMainPage({Key? key}) : super(key: key);

  @override
  _NoticeMainPageState createState() => _NoticeMainPageState();
}

class _NoticeMainPageState extends State<NoticeMainPage> {
  final TextEditingController _controller = TextEditingController();
  final NoticeRemoteDataSource noticeRemoteDataSource = NoticeRemoteDataSourceImpl();
  List<NoticeModel> noticeList = [];
  List<NoticeModel> allNotices = [];
  String selectedFilter = 'Todos'; // Valor predeterminado
  List<String> filterOptions = ['Todos', 'Reunion', 'Evento'];
  final PersonaDataSource _usuarioDataSource = PersonaDataSource();

  @override
  void initState() {
    super.initState();
    refreshNotice();
  }

  Future<void> refreshNotice() async {
    final notices = await noticeRemoteDataSource.getNotice();
    print('Número total de anuncios: ${notices.length}');

    setState(() {
      allNotices = notices.where((notice) => notice.status == true).toList();
      allNotices.sort((a, b) => b.registerCreated.compareTo(a.registerCreated)); // Ordenar por timestamp de forma descendente
      print('Número de anuncios con estado true: ${allNotices.length}');

      filterNotices(""); // Inicialmente, muestra todos los avisos
    });
  }

  void filterByTypes(String selectedOption) {
    selectedFilter = selectedOption;
    if (selectedOption == 'Todos') {
      setState(() {
        noticeList = allNotices;
      });
    } else {
      final filtered = allNotices.where((notice) => notice.type == selectedOption).toList();
      setState(() {
        noticeList = filtered;
      });
    }
  }

  void filterNotices(String searchTerm) {
    if (searchTerm.isEmpty) {
      filterByTypes(selectedFilter);
    } else {
      setState(() {
        final filtered = allNotices.where((notice) =>
            notice.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
            notice.description.toLowerCase().contains(searchTerm.toLowerCase())).toList();
        noticeList = filtered;
      });
    }
  }

  late PersonaModel persona;
  String personaId = '';
  void getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    personaId = prefs.getString('personId')!;
  }

  @override
  Widget build(BuildContext context) {
    getId();
    Future.delayed(Duration(seconds: 2), () async {
      persona = await _usuarioDataSource.getPersonFromId(personaId) as PersonaModel;
    });
    final meetingNotices = noticeList.where((notice) => notice.type == 'Reunion').toList();
    final eventNotices = noticeList.where((notice) => notice.type == 'Evento').toList();

    return WillPopScope(
      onWillPop: () async {
        final confirmLogout = await _confirmLogout2(context);
        return !confirmLogout;
      },
      child: Scaffold(
        appBar: const AppBarCustomNotification(
          title: 'Anuncios',
        ),
        backgroundColor: const Color(0XFFE3E9F4),
        body: SingleChildScrollView(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            const Image(
                              image: AssetImage('assets/ui/lupa.png'),
                              width: 35,
                              height: 35,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'Buscar',
                                controller: _controller,
                                onChanged: (p0) {
                                  if (p0 != null) {
                                    filterNotices(p0);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        value: selectedFilter,
                        items: filterOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          filterByTypes(newValue!);
                        },
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: 10,
                              color: const Color(0xFF044086),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Reuniones',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (allNotices.isEmpty)
                        const CircularProgressIndicator()
                      else
                        buildNoticeListView(meetingNotices),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: 10,
                              color: const Color(0xFF044086),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Eventos',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      buildNoticeListView(eventNotices),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNoticeCard(NoticeModel notice) {
    Color cardColor = notice.type == "Evento" ? Color(0xFF720E0F) : const Color(0xFF044086);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: cardColor,
      elevation: 4,
      shadowColor: Colors.blue,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  notice.title,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  notice.description,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNoticeListView(List<NoticeModel> notices) {
    return ListView.builder(
      itemCount: notices.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return buildNoticeCard(notices[index]);
      },
    );
  }

  Future<bool> _confirmLogout2(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Está seguro de que desea cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _logout2(context);
                Navigator.of(context).pop(true);
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _logout2(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('personId');
    Navigator.pushReplacementNamed(context, '/');
  }
}
