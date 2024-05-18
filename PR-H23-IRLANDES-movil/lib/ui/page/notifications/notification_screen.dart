import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:irlandes_app/data/model/notification_model.dart';
import 'package:irlandes_app/data/remote/notifications_remote_datasource.dart';
import 'package:irlandes_app/ui/widgets/app_bar_custom.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationRemoteDataSource notificationRemoteDataSource =
      NotificationRemoteDataSourceImpl();
  List<NotificationModel> allNotifications = [];
  String token = '';

  @override
  void initState() {
    super.initState();
    getToken();
  }

void actualizarEstadoNotificacion(String notificationId) async {
  try {
    await FirebaseFirestore.instance
      .collection('Notifications')
      .doc(notificationId)
      .update({
        'status': 0, // Cambiar el estado a 0 para ocultar la notificación
      });
    print('Notificación actualizada exitosamente');
  } catch (error) {
    print('Error al actualizar la notificación: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al ocultar la notificación. Por favor, inténtalo de nuevo.'),
      ),
    );
  }
}

  Future<void> getToken() async {
    token = (await _messaging.getToken())!;
    refreshNotification();
  }

  Future<void> refreshNotification() async {
  final notifications =
      await notificationRemoteDataSource.getNotificationByUserToken(token);

  // Ordenar las notificaciones por la hora de llegada (en orden descendente)
  notifications.sort((a, b) => b.registerDate.compareTo(a.registerDate));

  // Filtrar notificaciones con un estado 'status' igual a 0
  final filteredNotifications = notifications.where((notification) => notification.status != 0).toList();

  // Filtrar notificaciones con más de dos meses de antigüedad
  final now = DateTime.now();
  final filteredByAgeNotifications = filteredNotifications.where((notification) {
    final diffInDays = now.difference(notification.registerDate).inDays;
    return diffInDays <= 60; // Only show notifications less than or equal to 60 days old
  }).toList();

  setState(() {
    allNotifications = filteredByAgeNotifications;
  });
}
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: const AppBarCustom(title: 'Notificaciones'),
    backgroundColor: const Color(0XFFE3E9F4),
    body: Center(
      child: FutureBuilder(
        future: refreshNotification(),
        builder: (context, snapshot) {
          if (allNotifications.isEmpty) {
            return const CircularProgressIndicator();
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: allNotifications.length,
              itemBuilder: (BuildContext context, int index) {
                return notificationCard(
                  allNotifications[index],
                  index,
                  () {
                    // Eliminar la notificación de la lista y actualizar el estado
                    setState(() {
                      allNotifications.removeAt(index);
                    });

                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
          }
        },
      ),
    ),
  );
}

  Widget notificationCard(NotificationModel notification, int index, VoidCallback onDismissed) {
    return Dismissible(
      key: Key(notification.id.toString()),
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Eliminar notificación'),
              content: const Text('¿Está seguro de que desea eliminar esta notificación?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    // Actualizar el estado de la notificación a 0 para ocultarla
                    actualizarEstadoNotificacion(notification.id.toString());
                  },
                  child: const Text('Eliminar'),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        child: ListTile(
          title: Text(notification.title +
              '  Fecha: ' +
              notification.registerDate.day.toString() +
              '/' +
              notification.registerDate.month.toString() +
              '/' +
              notification.registerDate.year.toString()),
          subtitle: Text(notification.content),
        ),
      ),
    );
  }
}
