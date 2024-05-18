import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:irlandes_app/ui/page/options_menu.dart';
import 'package:irlandes_app/ui/widgets/app_bar_custom.dart';

const backgroundColor = Color(0xFFE3E9F4);

class MenuDashboardPage extends StatefulWidget {
  const MenuDashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  late double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final caffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      key: caffoldKey,
      backgroundColor: const Color(0xFFE3E9F4),
      appBar: const AppBarCustom(title: 'Estado económico'), //ahora podemos replicar
      drawer: const OptionsMenu(),
      body: Stack(
        children: <Widget>[
          dashboard(context),
        ],
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          elevation: 8,
          color: backgroundColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40, top: 5),
                      child: Text(
                        'Deuda:',
                        style: GoogleFonts.barlow(
                            textStyle: const TextStyle(
                                color: Color(0xFF3D5269),
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  //Desplegable Card categorias de deuda y total
                  SizedBox(
                    height: 200,
                    child: PageView(
                      controller: PageController(viewportFraction: 0.8),
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                        const Row(
                                          children: [
                                            CustomText(
                                                text: 'Estudiante:',
                                                color: Color(0xFF044086)),
                                            CustomText(
                                                text: 'Categoría:',
                                                color: Color(0xFF044086)),
                                            CustomText(
                                                text: 'Monto:',
                                                color: Color(0xFF044086))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 62,
                                          child: Card(
                                              color: const Color(0xFF044086),
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: const Padding(
                                                padding:
                                                     EdgeInsets.all(3),
                                                child: Row(
                                                  children: [
                                                    CustomText(
                                                      text: 'Pedro Juarez',
                                                      color: Colors.white,
                                                    ),
                                                    CustomText(
                                                      text: 'Matrícula',
                                                      color: Colors.white,
                                                    ),
                                                    CustomText(
                                                      text: 'Bs.-200',
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 62,
                                          child: Card(
                                              color: const Color(0xFF044086),
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: const Padding(
                                                padding:
                                                     EdgeInsets.all(3),
                                                child: Row(
                                                  children: [
                                                    CustomText(
                                                      text: 'Jose Pan',
                                                      color: Colors.white,
                                                    ),
                                                    CustomText(
                                                      text: 'Mensualidad',
                                                      color: Colors.white,
                                                    ),
                                                    CustomText(
                                                      text: 'Bs.-200',
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            CustomText(
                                                text: 'Total:',
                                                color: Color(0xFF044086)),
                                            CustomText(
                                                text: 'Bs.-400',
                                                color: Color(0xFF044086))
                                          ],
                                        )
                                      ]),
                                      
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      );
                                });
                          },

                          //Card deuda
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF044086),
                                borderRadius: BorderRadius.circular(30)),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Image(
                                    image: AssetImage(
                                        'assets/ui/Credit_card_white.png'),
                                    width: 40,
                                    height: 35),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Bs. 400.00',
                                      style: GoogleFonts.barlow(
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),

                  //SizedBox(height: 20),
                  //Registro de movimientos
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 10, left: 10, right: 10),
                    child: Text(
                      "Movimientos:",
                      style: TextStyle(color: Color(0xFF3D5269), fontSize: 20),
                    ),
                  ),

                  ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Center(
                          child: InkWell(//
                          onTap: () {
                            showDialog(
                              context: context,
                            
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                         Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                 text: 'Concepto',
                                                 color: Color(0xFF3D5269)
                                                ),
                                                CustomText(
                                                 text: 'Emitido por:',
                                                 color: Color(0xFF3D5269)
                                                ),
                                                CustomText(
                                                 text: 'Destinatario:',
                                                 color: Color(0xFF3D5269)
                                                ),
                                                CustomText(
                                                 text: 'Monto:',
                                                 color: Color(0xFF3D5269)
                                                ),
                                                CustomText(
                                                 text: 'Fecha',
                                                 color: Color(0xFF3D5269)
                                                )
                                                ],
                                                
                                              ),
                                            ),
                                            // Container(
                                            //   width: 1,
                                            //   height: double.infinity,
                                            //   color: Color(0xFF3D5269),
                                            // ),
                                            Expanded(//ajuste el colum
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text: 'Matrícula',
                                                    color: Color(0xFF3D5269)
                                                ),
                                                CustomText(
                                                    text: 'Pedro Juarez',
                                                    color: Color(0xFF3D5269)
                                                ),
                                                CustomText(
                                                    text: 'Col - Irlandés',
                                                    color: Color(0xFF3D5269)
                                                ),
                                                CustomText(
                                                    text: '800.50',
                                                    color: Color(0xFF3D5269)
                                                ),
                                                CustomText(
                                                    text: '25 / 08 /23  14:15',
                                                    color: Color(0xFF3D5269)
                                                )
                                                ],
                                              ),
                                            )
                                          ]
                                        ),
                                          ]
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  );
                          },
                            );
                            },
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF044086),
                                  borderRadius: BorderRadius.circular(6)
                                  ),
                               
                              child: const Padding(
                                
                                padding: EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                    "Pedro Juan Gonzales",
                                    style: TextStyle(color: Color(0xFFFFFFFF)),
                                  ),
                                  //subtitle: Text("Mensualidad"),
                                  trailing: Text(
                                    "Bs.-2900",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(height: 16);
                      },
                      itemCount: 5)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign? alignment;
  const CustomText({super.key, required this.text, required this.color, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: Text(text, style: GoogleFonts.lato(textStyle: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.bold)), textAlign: alignment,),
    
    );
  }
}
