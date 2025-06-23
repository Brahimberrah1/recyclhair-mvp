import 'package:flutter/material.dart';
import 'package:jemputah_app_driver/API/FetchData.dart';
import 'package:jemputah_app_driver/components/dl_alert.dart';
import 'package:jemputah_app_driver/constants/color.dart';
import 'package:jemputah_app_driver/constants/icons.dart';
import 'package:jemputah_app_driver/constants/variable.dart';
import 'package:jemputah_app_driver/extensions/time_code_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jemputah_app_driver/screens/base_screen.dart';

class DetailPenjemputanScreen extends StatefulWidget {
  final String idJemput;

  const DetailPenjemputanScreen(this.idJemput, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => InitState(idJemput);
}

class InitState extends State<DetailPenjemputanScreen> {
  var db = FirebaseFirestore.instance;
  String idJemput;

  InitState(this.idJemput);

  dynamic _beratSampahPlastik = 0.0;
  dynamic _beratSampahKarton = 0.0;
  dynamic _beratSampahKaca = 0.0;
  dynamic _beratSampahKaleng = 0.0;

  dynamic _totalPendapatanDriver = 0;
  dynamic _totalPendapatanUser = 0;
  double _totalBerat = 0;

  String _alamatPenjemputan = 'Loading...';
  String _tanggalPenjemputan = 'Loading...';
  String _waktuPenjemputan = 'Loading...';
  String _namaUser = 'Loading...';
  String _noTelpUser = 'Loading...';

  dynamic _koinUser = 0;
  dynamic _jemputUser = 0;
  dynamic _beratUser = 0;

  dynamic _koinDriver = 0;
  dynamic _jemputDriver = 0;
  dynamic _beratDriver = 0;

  int _timeCode = 0;

  String _idSampah = '';
  String _idUser = '';

  TimeCodeConverter timeCodeConverter = TimeCodeConverter();

  void setJemput() {
    var jemput = FetchData().fetchMapData('jemput', idJemput);
    jemput.then((value) {
      setState(() {
        _totalPendapatanDriver = value['total_koin_driver'];
        _totalPendapatanUser = value['total_koin_user'];
        _totalBerat = value['total_berat'];
        _idSampah = value['id_sampah'];
        _alamatPenjemputan = value['address'];
        _tanggalPenjemputan = value['date'];
        _idUser = value['id_user'];
        _timeCode = value['time_code'];
        _waktuPenjemputan =
            timeCodeConverter.timeCodeConverter(value['time_code']);
        setSampah();
        setUser();
        setDriver();
      });
    });
  }

  void setSampah() {
    var sampah = FetchData().fetchMapData('sampah', _idSampah);
    sampah.then((value) {
      setState(() {
        _beratSampahPlastik = value['berat1'].toDouble();
        _beratSampahKarton = value['berat2'].toDouble();
        _beratSampahKaca = value['berat3'].toDouble();
        _beratSampahKaleng = value['berat4'].toDouble();
      });
    });
  }

  void setUser() {
    var user = FetchData().fetchMapData('user', _idUser);
    user.then((value) {
      setState(() {
        _namaUser = value['name_user'];
        _noTelpUser = value['phone_num_user'];
        _koinUser = value['jml_koin_user'];
        _jemputUser = value['jml_jemput'];
        _beratUser = value['jml_berat'];
      });
    });
  }

  void setDriver() {
    var driver = FetchData().fetchMapData('driver', uid);
    driver.then((value) {
      setState(() {
        _koinDriver = value['jml_koin_driver'];
        _jemputDriver = value['jml_jemput'];
        _beratDriver = value['jml_berat'];
      });
    });
  }

  void setDone() {
    final jemput = <String, dynamic>{
      "is_pickup_done": true,
      "ongoing": false,
    };
    db.collection('jemput').doc(idJemput).update(jemput);
    final updateDriver = <String, dynamic>{
      "jml_koin_driver": _koinDriver + _totalPendapatanDriver,
      "jml_jemput": _jemputDriver + 1,
      "jml_berat": _beratDriver + _totalBerat,
      "is_pickup_done": true,
    };
    db.collection('driver').doc(uid).update(updateDriver);
    final updateUser = <String, dynamic>{
      "jml_koin_user": _koinUser + _totalPendapatanUser,
      "jml_jemput": _jemputUser + 1,
      "jml_berat": _beratUser + _totalBerat,
    };
    db.collection('user').doc(_idUser).update(updateUser);
    db.collection('driver').doc(uid).update({'slot_$_timeCode': ''});
  }

  void setCancel() {
    db.collection('jemput').doc(idJemput).update({'is_pickup_done': false});
    db.collection('jemput').doc(idJemput).update({'ongoing': false});
    db.collection('driver').doc(uid).update({'slot_$_timeCode': ''});
  }

  @override
  void initState() {
    setJemput();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      backgroundColor: AppColors.backgroundGreen,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: AppColors.mainGreen,
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.separatorLine,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  margin: const EdgeInsets.only(top: 10, left: 24, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _namaUser,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, right: 24, bottom: 10),
                  child:
                      Text((_noTelpUser), style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 24, top: 10),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Types of Recyclable Waste:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
              height: 42,
              margin: const EdgeInsets.only(left: 24, right: 24, top: 5),
              padding: const EdgeInsets.only(left: 10, right: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondaryBorder,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE)),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 34,
                    height: 34,
                    child: Image.asset(
                      iconPlastik,
                    ),
                  ),
                  const SizedBox(
                    width: 220,
                    child: Text('Plastic'),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Text("$_beratSampahPlastik"),
                        const Text(' Kg'),
                      ],
                    ),
                  ),
                ],
              )),
          Container(
              height: 42,
              margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
              padding: const EdgeInsets.only(left: 10, right: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondaryBorder,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE)),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 34,
                    height: 34,
                    child: Image.asset(
                      iconKarton,
                    ),
                  ),
                  const SizedBox(
                    width: 220,
                    child: Text('Cardboard'),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Text("$_beratSampahKarton"),
                        const Text(' Kg'),
                      ],
                    ),
                  ),
                ],
              )),
          Container(
              height: 42,
              margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
              padding: const EdgeInsets.only(left: 10, right: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondaryBorder,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE)),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 34,
                    height: 34,
                    child: Image.asset(
                      iconKaca,
                    ),
                  ),
                  const SizedBox(
                    width: 220,
                    child: Text('Glass'),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Text("$_beratSampahKaca"),
                        const Text(' Kg'),
                      ],
                    ),
                  ),
                ],
              )),
          Container(
              height: 42,
              margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
              padding: const EdgeInsets.only(left: 10, right: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondaryBorder,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE)),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 34,
                    height: 34,
                    child: Image.asset(
                      iconKaleng,
                    ),
                  ),
                  const SizedBox(
                    width: 220,
                    child: Text('Can'),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Text("$_beratSampahKaleng"),
                        const Text(' Kg'),
                      ],
                    ),
                  ),
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5, right: 24),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Total Weight:',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, right: 35),
                child: Text(("$_totalBerat Kg"),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 24, top: 15),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Pickup Location',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
              height: 42,
              margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondaryBorder,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE)),
                ],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 34,
                  height: 34,
                  child: const Icon(Icons.location_on),
                ),
                SizedBox(
                    width: 260,
                    child: Text(
                      _alamatPenjemputan,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15),
                    )),
              ])),
          Container(
            margin: const EdgeInsets.only(left: 24, top: 15),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Pickup Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
              height: 42,
              margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondaryBorder,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE)),
                ],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 34,
                  height: 34,
                  child: const Icon(Icons.calendar_month),
                ),
                SizedBox(
                    width: 260,
                    child: Text(
                      _tanggalPenjemputan,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15),
                    )),
              ])),
          Container(
            margin: const EdgeInsets.only(left: 24, top: 15),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Pickup Time',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
              height: 42,
              margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondaryBorder,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE)),
                ],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 34,
                  height: 34,
                  child: const Icon(Icons.timer),
                ),
                SizedBox(
                    width: 260,
                    child: Text(
                      _waktuPenjemputan,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15),
                    )),
              ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 25, left: 24),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Your Total Earnings',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25, right: 24),
                child: Text(("$_totalPendapatanDriver Coins"),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => {
                    DLAlert(
                      cancelTitle: 'Cancel',
                      alertTitle: 'Cancel Confirmation',
                      alertDetailMessage:
                          'Are you sure you want to cancel this order?',
                      alertActionTitles: ['Confirm'],
                      onAlertAction: (index) {
                        if (index == 0) {
                          setCancel();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BaseScreen()));
                        }
                      },
                    ).show(context),
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 30),
                    width: 170,
                    alignment: Alignment.center,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color(0xffEEEEEE)),
                      ],
                    ),
                    child: const Text(
                      'Cancel Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    DLAlert(
                      cancelTitle: 'Cancel',
                      alertTitle: 'Pickup Confirmation',
                      alertDetailMessage:
                          'Are you sure you want to complete this order?',
                      alertActionTitles: ['Confirm'],
                      onAlertAction: (index) {
                        if (index == 0) {
                          setDone();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BaseScreen()));
                        }
                      },
                    ).show(context),
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 30),
                    width: 170,
                    alignment: Alignment.center,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.buttonBackground,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color(0xffEEEEEE)),
                      ],
                    ),
                    child: const Text(
                      'Order Completed',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
