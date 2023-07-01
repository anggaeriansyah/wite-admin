import 'dart:collection';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wite_dashboard/Screen/dashboard.dart';

class UpdateScreen extends StatefulWidget {
  // const MyWidget({Key? key}) : super(key: key);
  final documentId;

  UpdateScreen({required this.documentId});
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  // final _formKey =ormState>();
  late GoogleMapController _mapController;
  bool mapsOrLatlong = true;
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};
  final picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _namaController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _tiketController = TextEditingController();
  //Jam Controller
  TextEditingController _seninBukaController = TextEditingController();
  TextEditingController _seninTutupController = TextEditingController();
  TextEditingController _selasaBukaController = TextEditingController();
  TextEditingController _selasaTutupController = TextEditingController();
  TextEditingController _rabuBukaController = TextEditingController();
  TextEditingController _rabuTutupController = TextEditingController();
  TextEditingController _kamisBukaController = TextEditingController();
  TextEditingController _kamisTutupController = TextEditingController();
  TextEditingController _jumatBukaController = TextEditingController();
  TextEditingController _jumatTutupController = TextEditingController();
  TextEditingController _sabtuBukaController = TextEditingController();
  TextEditingController _sabtuTutupController = TextEditingController();
  TextEditingController _mingguBukaController = TextEditingController();
  TextEditingController _mingguTutupController = TextEditingController();
  TimeOfDay? _selectedOpeningTime;
  TimeOfDay? _selectedClosingTime;
  TextEditingController _latController = TextEditingController();
  TextEditingController _longController = TextEditingController();
  String selectedOptionKategori = 'air-terjun';

  final Set<Polygon> _polygon = HashSet<Polygon>();

  List<LatLng> points = const [
    LatLng(-6.715958, 106.730926),
    LatLng(-6.712839, 106.725821),
    LatLng(-6.706891, 106.720422),
    LatLng(-6.704236, 106.715780),
    LatLng(-6.698845, 106.710584),
    LatLng(-6.697333, 106.708581),
    LatLng(-6.694545, 106.706684),
    LatLng(-6.692586, 106.704864),
    LatLng(-6.691757, 106.702967),
    LatLng(-6.688216, 106.701677),
    LatLng(-6.686736, 106.699764), //curug ciampea
    LatLng(-6.681963, 106.695988),
    LatLng(-6.679024, 106.694471),
    LatLng(-6.671113, 106.698339),
    LatLng(-6.667270, 106.698946),
    LatLng(-6.665235, 106.697960),
    LatLng(-6.664557, 106.696215),
    LatLng(-6.655365, 106.691967),
    LatLng(-6.645795, 106.688857),
    LatLng(-6.633965, 106.687871),
    LatLng(-6.629219, 106.684740),
    LatLng(-6.621204, 106.684367),
    LatLng(-6.618511, 106.687320),
    LatLng(-6.615679, 106.688260),
    LatLng(-6.611984, 106.686924),
    LatLng(-6.609963, 106.687040),
    LatLng(-6.609155, 106.688202),
    LatLng(-6.607654, 106.687912),
    LatLng(-6.603224, 106.689516),
    LatLng(-6.604090, 106.693191), // turn2
    LatLng(-6.606627, 106.694437),
    LatLng(-6.606999, 106.695620),
    LatLng(-6.606484, 106.697133),
    LatLng(-6.605202, 106.697391),
    LatLng(-6.604006, 106.697133),
    LatLng(-6.604006, 106.699714),
    LatLng(-6.601272, 106.701520),
    LatLng(-6.598367, 106.701348),
    LatLng(-6.594351, 106.704187),
    LatLng(-6.589822, 106.708315),
    LatLng(-6.590249, 106.712788),
    LatLng(-6.594094, 106.712874),
    LatLng(-6.595291, 106.711326),
    LatLng(-6.598025, 106.711670),
    LatLng(-6.598879, 106.710552),
    LatLng(-6.601614, 106.710810),
    LatLng(-6.602041, 106.713648),
    LatLng(-6.603664, 106.715369),
    LatLng(-6.604861, 106.715541),
    LatLng(-6.605971, 106.714423),
    LatLng(-6.608279, 106.713906),
    LatLng(-6.609646, 106.712186),
    LatLng(-6.615370, 106.709606),
    LatLng(-6.618703, 106.713132),
    LatLng(-6.621864, 106.713046), //
    LatLng(-6.623915, 106.714681),
    LatLng(-6.626393, 106.714939),
    LatLng(-6.628101, 106.716401),
    LatLng(-6.630152, 106.714939),
    LatLng(-6.630579, 106.711756),
    LatLng(-6.634595, 106.711498),
    LatLng(-6.636902, 106.714078),
    LatLng(-6.643652, 106.716917),
    LatLng(-6.647155, 106.719756),
    LatLng(-6.649974, 106.719670),
    LatLng(-6.652537, 106.721906),
    LatLng(-6.652537, 106.721906),
    LatLng(-6.662277, 106.724314),
    LatLng(-6.667945, 106.725992),
    LatLng(-6.670190, 106.726032),
    LatLng(-6.676116, 106.727022),
    LatLng(-6.678081, 106.728530),
    LatLng(-6.680607, 106.729001),
    LatLng(-6.684163, 106.728624),
    LatLng(-6.685660, 106.729754),
    LatLng(-6.688374, 106.729377),
    LatLng(-6.691929, 106.730320),
    LatLng(-6.693707, 106.729001),
    LatLng(-6.696514, 106.729566),
    LatLng(-6.701379, 106.728059),
    LatLng(-6.702130, 106.731342),
    LatLng(-6.705601, 106.733205),
    LatLng(-6.715349, 106.733612),
  ];
  // Baru
  File? _imageFile;
  String? _imageUrl;
  List<String>? downloadUrls;
  bool switchValueTempClosed = false;
  bool switchValueCamp = false;
  bool _senin24Checked = false;
  bool _selasa24Checked = false;
  bool _rabu24Checked = false;
  bool _kamis24Checked = false;
  bool _jumat24Checked = false;
  bool _sabtu24Checked = false;
  bool _minggu24Checked = false;

  //untuk form input operasional
  bool _senin = false;
  bool _selasa = false;
  bool _rabu = false;
  bool _kamis = false;
  bool _jumat = false;
  bool _sabtu = false;
  bool _minggu = false;

  //validasi form
  bool _isNamaEmpty = false;
  bool _isTiketEmpty = false;
  bool _isLatEmpty = false;
  bool _isLongEmpty = false;

  List<String> galeri() {
    List<String> galeries = [];
    var a = widget.documentId.data()['imageGaleries'];
    for (var i = 0; i < a.length; i++) {
      galeries.add(widget.documentId.data()['imageGaleries'][i]);
    }
    return galeries;
  }

  Future<void> fetchPreviousData() async {
    final data = widget.documentId.data();
    _namaController.text = data['nama'];
    _descController.text = data['desc'].toString();
    _tiketController.text = data['tiket'].toString();
    selectedOptionDesa = data['desa'].toString();
    switchValueTempClosed = data['tempClosed'];
    switchValueCamp = data['penginapan'];
    _imageUrl = data['image'];
    // var a = data['imageGaleries'] as List<String>;
    downloadUrls = galeri();
    _selectedLocation =
        LatLng(data['latitude'] as double, data['longitude'] as double);

    _senin = data['hariOp'][0];
    _selasa = data['hariOp'][1];
    _rabu = data['hariOp'][2];
    _kamis = data['hariOp'][3];
    _jumat = data['hariOp'][4];
    _sabtu = data['hariOp'][5];
    _minggu = data['hariOp'][6];

    var seninBuka =
        data['jamOp'][0] == 'Buka 24 jam' || data['jamOp'][0] == 'Tutup'
            ? data['jamOp'][0].toString()
            : data['jamOp'][0].toString().substring(0, 5);
    if (seninBuka == 'Buka 24 jam') {
      _senin24Checked = true;
    } else if (seninBuka == 'Tutup') {
      _senin = false;
    } else {
      _seninBukaController.text = seninBuka;
    }
    var seninTutup =
        data['jamOp'][0] == 'Buka 24 jam' || data['jamOp'][0] == 'Tutup'
            ? data['jamOp'][0].toString()
            : data['jamOp'][0].toString().substring(8, 13);
    if (seninTutup == 'Buka 24 jam') {
      _senin24Checked = true;
    } else if (seninTutup == 'Tutup') {
      _senin = false;
    } else {
      _seninTutupController.text = seninTutup;
    }

    var selasaBuka =
        data['jamOp'][1] == 'Buka 24 jam' || data['jamOp'][1] == 'Tutup'
            ? data['jamOp'][1].toString()
            : data['jamOp'][1].toString().substring(0, 5);
    if (selasaBuka == 'Buka 24 jam') {
      _selasa24Checked = true;
    } else if (selasaBuka == 'Tutup') {
      _selasa = false;
    } else {
      _selasaBukaController.text = selasaBuka;
    }
    var selasaTutup =
        data['jamOp'][1] == 'Buka 24 jam' || data['jamOp'][1] == 'Tutup'
            ? data['jamOp'][1].toString()
            : data['jamOp'][1].toString().substring(8, 13);
    if (selasaTutup == 'Buka 24 jam') {
      _selasa24Checked = true;
    } else if (selasaTutup == 'Tutup') {
      _selasa = false;
    } else {
      _selasaTutupController.text = selasaTutup;
    }

    var rabuBuka =
        data['jamOp'][2] == 'Buka 24 jam' || data['jamOp'][2] == 'Tutup'
            ? data['jamOp'][2].toString()
            : data['jamOp'][2].toString().substring(0, 5);
    if (rabuBuka == 'Buka 24 jam') {
      _rabu24Checked = true;
    } else if (rabuBuka == 'Tutup') {
      _rabu = false;
    } else {
      _rabuBukaController.text = rabuBuka;
    }
    var rabuTutup =
        data['jamOp'][2] == 'Buka 24 jam' || data['jamOp'][2] == 'Tutup'
            ? data['jamOp'][2].toString()
            : data['jamOp'][2].toString().substring(8, 13);
    if (rabuTutup == 'Buka 24 jam') {
      _rabu24Checked = true;
    } else if (rabuTutup == 'Tutup') {
      _rabu = false;
    } else {
      _rabuTutupController.text = rabuTutup;
    }

    var kamisBuka =
        data['jamOp'][3] == 'Buka 24 jam' || data['jamOp'][3] == 'Tutup'
            ? data['jamOp'][3].toString()
            : data['jamOp'][3].toString().substring(0, 5);
    if (kamisBuka == 'Buka 24 jam') {
      _kamis24Checked = true;
    } else if (kamisBuka == 'Tutup') {
      _kamis = false;
    } else {
      _kamisBukaController.text = kamisBuka;
    }
    var kamisTutup =
        data['jamOp'][3] == 'Buka 24 jam' || data['jamOp'][3] == 'Tutup'
            ? data['jamOp'][3].toString()
            : data['jamOp'][3].toString().substring(8, 13);
    if (kamisTutup == 'Buka 24 jam') {
      _kamis24Checked = true;
    } else if (kamisTutup == 'Tutup') {
      _kamis = false;
    } else {
      _kamisTutupController.text = kamisTutup;
    }

    var jumatBuka =
        data['jamOp'][4] == 'Buka 24 jam' || data['jamOp'][4] == 'Tutup'
            ? data['jamOp'][4].toString()
            : data['jamOp'][4].toString().substring(0, 5);
    if (jumatBuka == 'Buka 24 jam') {
      _jumat24Checked = true;
    } else if (jumatBuka == 'Tutup') {
      _jumat = false;
    } else {
      _jumatBukaController.text = jumatBuka;
    }
    var jumatTutup =
        data['jamOp'][4] == 'Buka 24 jam' || data['jamOp'][4] == 'Tutup'
            ? data['jamOp'][4].toString()
            : data['jamOp'][4].toString().substring(8, 13);
    if (jumatTutup == 'Buka 24 jam') {
      _jumat24Checked = true;
    } else if (jumatTutup == 'Tutup') {
      _jumat = false;
    } else {
      _jumatTutupController.text = jumatTutup;
    }

    var sabtuBuka =
        data['jamOp'][5] == 'Buka 24 jam' || data['jamOp'][5] == 'Tutup'
            ? data['jamOp'][5].toString()
            : data['jamOp'][5].toString().substring(0, 5);
    if (sabtuBuka == 'Buka 24 jam') {
      _sabtu24Checked = true;
    } else if (sabtuBuka == 'Tutup') {
      _sabtu = false;
    } else {
      _sabtuBukaController.text = sabtuBuka;
    }
    var sabtuTutup =
        data['jamOp'][5] == 'Buka 24 jam' || data['jamOp'][5] == 'Tutup'
            ? data['jamOp'][5].toString()
            : data['jamOp'][5].toString().substring(8, 13);
    if (sabtuTutup == 'Buka 24 jam') {
      _sabtu24Checked = true;
    } else if (sabtuTutup == 'Tutup') {
      _sabtu = false;
    } else {
      _sabtuTutupController.text = sabtuTutup;
    }

    var mingguBuka =
        data['jamOp'][6] == 'Buka 24 jam' || data['jamOp'][6] == 'Tutup'
            ? data['jamOp'][6].toString()
            : data['jamOp'][6].toString().substring(0, 5);
    if (mingguBuka == 'Buka 24 jam') {
      _minggu24Checked = true;
    } else if (mingguBuka == 'Tutup') {
      _minggu = false;
    } else {
      _mingguBukaController.text = mingguBuka;
    }
    var mingguTutup =
        data['jamOp'][6] == 'Buka 24 jam' || data['jamOp'][6] == 'Tutup'
            ? data['jamOp'][6].toString()
            : data['jamOp'][6].toString().substring(8, 13);
    if (mingguTutup == 'Buka 24 jam') {
      _minggu24Checked = true;
    } else if (mingguTutup == 'Tutup') {
      _minggu = false;
    } else {
      _mingguTutupController.text = mingguTutup;
    }
  }
  // getDataOpBuka(value){
  //   var jamBuka = value == 'Buka 24 jam'
  //       ? value.toString()
  //       : value.substring(0, 5);
  //   if (jamBuka == 'Buka 24 jam') {
  //     _senin24Checked = true;
  //   }
  //   }

  void validateNama(value) {
    setState(() {
      _isNamaEmpty = _namaController.text.isEmpty || value == '';
    });
  }

  void validateTiket(value) {
    setState(() {
      _isTiketEmpty = _tiketController.text.isEmpty || value == '';
    });
  }

  void textFieldToMaps() {
    setState(() {
      if (_latController.text.isNotEmpty && _longController.text.isNotEmpty) {
        _selectedLocation = LatLng(double.parse(_latController.text),
            double.parse(_longController.text));
      } else {
        _selectedLocation = null;
      }
    });
  }

  void mapsToTextField() {
    setState(() {
      if (_selectedLocation != null) {
        _latController.text = _selectedLocation!.latitude.toString();
        _longController.text = _selectedLocation!.longitude.toString();
        _isLatEmpty = _latController.text.isEmpty;
        _isLongEmpty = _longController.text.isEmpty;
      }
    });
  }

  void getLat(value) {
    setState(() {
      _isLatEmpty = _latController.text.isEmpty || value == '';
    });
  }

  void getLong(value) {
    setState(() {
      _isLongEmpty = _longController.text.isEmpty || value == '';
    });
  }

  var currentStep = 0;
  int _totalInnerSteps = 2;
  var _currentInnerStep = 0;
  var selectedOptionDesa;
  // String selectedOptionDesa = 'Tapos I';

  @override
  void initState() {
    super.initState();
    galeri();
    fetchPreviousData();
    _markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: _selectedLocation!,
      ),
    );
  }

  // void saveDataToFirestore() {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   final wisata = <String, dynamic>{
  //     "nama": _namaController.text,
  //     "image": _imageUrl,
  //     "desa": selectedOptionDesa,
  //     "kec": "Kecamatan Tenjolaya",
  //     "tiket": int.parse(_tiketController.text),
  //     "desc": _descController.text,
  //     "tempClosed": switchValueTempClosed,
  //     "penginapan": switchValueCamp,
  //     "kategori": selectedOptionKategori,
  //     "hariOp": [_senin, _selasa, _rabu, _kamis, _jumat, _sabtu, _minggu],
  //     "jamOp": [
  //       _senin
  //           ? _senin24Checked
  //               ? "Buka 24 jam"
  //               : '${_seninBukaController.text} - ${_seninTutupController.text}'
  //           : 'Tutup',
  //       _selasa
  //           ? _selasa24Checked
  //               ? "Buka 24 jam"
  //               : '${_selasaBukaController.text} - ${_selasaTutupController.text}'
  //           : 'Tutup',
  //       _rabu
  //           ? _rabu24Checked
  //               ? "Buka 24 jam"
  //               : '${_rabuBukaController.text} - ${_rabuTutupController.text}'
  //           : 'Tutup',
  //       _kamis
  //           ? _kamis24Checked
  //               ? "Buka 24 jam"
  //               : '${_kamisBukaController.text} - ${_kamisTutupController.text}'
  //           : 'Tutup',
  //       _jumat
  //           ? _jumat24Checked
  //               ? "Buka 24 jam"
  //               : '${_jumatBukaController.text} - ${_jumatTutupController.text}'
  //           : 'Tutup',
  //       _sabtu
  //           ? _sabtu24Checked
  //               ? "Buka 24 jam"
  //               : '${_sabtuBukaController.text} - ${_sabtuTutupController.text}'
  //           : 'Tutup',
  //       _minggu
  //           ? _minggu24Checked
  //               ? "Buka 24 jam"
  //               : '${_mingguBukaController.text} - ${_mingguTutupController.text}'
  //           : 'Tutup',
  //     ],
  //     "imageGaleries": downloadUrls
  //   };
  //   firestore.collection("wisata").add(wisata).then((DocumentReference doc) =>
  //       print('DocumentSnapshot added with ID: ${doc.id}'));
  //   setState(() {
  //     Navigator.pop(context);
  //   });
  // }

  void updateDataToFirestore() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, dynamic> wisata = {
      "nama": _namaController.text,
      "image": _imageUrl,
      "desa": selectedOptionDesa,
      "kec": "Kecamatan Tenjolaya",
      "tiket": int.parse(_tiketController.text),
      "desc": _descController.text,
      "tempClosed": switchValueTempClosed,
      "penginapan": switchValueCamp,
      "kategori": selectedOptionKategori,
      "hariOp": [_senin, _selasa, _rabu, _kamis, _jumat, _sabtu, _minggu],
      "jamOp": [
        _senin
            ? _senin24Checked
                ? "Buka 24 jam"
                : '${_seninBukaController.text} - ${_seninTutupController.text}'
            : 'Tutup',
        _selasa
            ? _selasa24Checked
                ? "Buka 24 jam"
                : '${_selasaBukaController.text} - ${_selasaTutupController.text}'
            : 'Tutup',
        _rabu
            ? _rabu24Checked
                ? "Buka 24 jam"
                : '${_rabuBukaController.text} - ${_rabuTutupController.text}'
            : 'Tutup',
        _kamis
            ? _kamis24Checked
                ? "Buka 24 jam"
                : '${_kamisBukaController.text} - ${_kamisTutupController.text}'
            : 'Tutup',
        _jumat
            ? _jumat24Checked
                ? "Buka 24 jam"
                : '${_jumatBukaController.text} - ${_jumatTutupController.text}'
            : 'Tutup',
        _sabtu
            ? _sabtu24Checked
                ? "Buka 24 jam"
                : '${_sabtuBukaController.text} - ${_sabtuTutupController.text}'
            : 'Tutup',
        _minggu
            ? _minggu24Checked
                ? "Buka 24 jam"
                : '${_mingguBukaController.text} - ${_mingguTutupController.text}'
            : 'Tutup',
      ],
      "imageGaleries": downloadUrls,
      "latitude": _selectedLocation!.latitude,
      "longitude": _selectedLocation!.longitude,
    };
    firestore
        .collection("wisata")
        .doc(widget.documentId.id)
        .update(wisata)
        .then((_) {
      print('Data updated successfully');
      setState(() {
        Navigator.pop(context);
      });
    }).catchError((error) {
      print('Error updating data: $error');
    });
    // docRef.update(wisata);
    // .then((_) => print('Data updated successfully'))
    // .catchError((error) => print('Error updating data: $error'));
  }

  Future<List<String>> uploadImagesToFirebase(List<XFile> imageFiles) async {
    List<String> _downloadUrls = [];

    // Mendapatkan referensi ke Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('images');

    // Mengunggah setiap gambar ke Firebase Storage
    for (var imageFile in imageFiles) {
      // Mendapatkan nama unik untuk file gambar
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Mengupload gambar ke Firebase Storage
      final uploadTask =
          storageRef.child(fileName).putFile(File(imageFile.path));

      // Menunggu penyelesaian upload
      final TaskSnapshot snapshot = await uploadTask;

      // Mengambil URL download gambar
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Menambahkan URL download ke dalam list
      _downloadUrls.add(downloadUrl);
    }

    // Mengembalikan list URL download gambar
    return _downloadUrls;
  }

  Future<void> _selectOpeningTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedOpeningTime = selectedTime;
        setState(() {});
      });
    }
  }

  Future<void> _selectClosingTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedClosingTime = selectedTime;
        setState(() {});
      });
    }
  }

  Future<void> _selectTimeSeninB(BuildContext context) async {
    final TimeOfDay? seninBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (seninBukaTime != null) {
      _seninBukaController.text = seninBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeSeninT(BuildContext context) async {
    final TimeOfDay? seninTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (seninTutupTime != null) {
      _seninTutupController.text = seninTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeSelasaB(BuildContext context) async {
    final TimeOfDay? selasaBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selasaBukaTime != null) {
      _selasaBukaController.text = selasaBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeSelasaT(BuildContext context) async {
    final TimeOfDay? selasaTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selasaTutupTime != null) {
      _selasaTutupController.text = selasaTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeRabuB(BuildContext context) async {
    final TimeOfDay? rabuBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (rabuBukaTime != null) {
      _rabuBukaController.text = rabuBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeRabuT(BuildContext context) async {
    final TimeOfDay? rabuTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (rabuTutupTime != null) {
      _rabuTutupController.text = rabuTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeKamisB(BuildContext context) async {
    final TimeOfDay? kamisBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (kamisBukaTime != null) {
      _kamisBukaController.text = kamisBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeKamisT(BuildContext context) async {
    final TimeOfDay? kamisTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (kamisTutupTime != null) {
      _kamisTutupController.text = kamisTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeJumatB(BuildContext context) async {
    final TimeOfDay? jumatBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (jumatBukaTime != null) {
      _jumatBukaController.text = jumatBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeJumatT(BuildContext context) async {
    final TimeOfDay? jumatTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (jumatTutupTime != null) {
      _jumatTutupController.text = jumatTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeSabtuB(BuildContext context) async {
    final TimeOfDay? sabtuBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (sabtuBukaTime != null) {
      _sabtuBukaController.text = sabtuBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeSabtuT(BuildContext context) async {
    final TimeOfDay? sabtuTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (sabtuTutupTime != null) {
      _sabtuTutupController.text = sabtuTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeMingguB(BuildContext context) async {
    final TimeOfDay? mingguBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (mingguBukaTime != null) {
      _mingguBukaController.text = mingguBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeMingguT(BuildContext context) async {
    final TimeOfDay? mingguTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (mingguTutupTime != null) {
      _mingguTutupController.text = mingguTutupTime.format(context);
      setState(() {});
    }
  }

  //untuk upload image
  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      // Jika gambar belum dipilih, tidak melakukan upload
      return print("object");
    }

    try {
      // Upload gambar ke Firebase Storage
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}.jpg');
      firebase_storage.UploadTask uploadTask = ref.putFile(_imageFile!);

      // Menunggu penyelesaian upload
      await uploadTask.whenComplete(() {});

      // Dapatkan URL download gambar
      String downloadUrl = await ref.getDownloadURL();

      // Simpan URL download gambar
      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (e) {
      // Tangani kesalahan jika ada
      print('Error uploading image: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        _uploadImage();
        if (_imageUrl != null) {
          deleteImageFromFirebase(_imageUrl!);
        }
      }
    });
  }

  Future<void> deleteImageFromFirebase(String imageUrl) async {
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);
    // Menghapus gambar dari Firebase Storage
    await ref.delete();
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: const Text("Page 1"),
            content: Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _pickImage(),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: _imageUrl != null
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Image.network(
                                _imageUrl!.toString(),
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) {
                                    return child;
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text('Upload',
                                    style: TextStyle(color: Colors.blue)),
                                Text('Gambar',
                                    style: TextStyle(color: Colors.blue)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onChanged: validateNama,
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: "Nama Wisata",
                      errorText: _isNamaEmpty
                          ? 'Nama wisata tidak boleh kosong'
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text("Desa : "),
                      const SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        itemHeight: kMinInteractiveDimension + 5,
                        value: selectedOptionDesa,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOptionDesa = newValue!;
                          });
                        },
                        items: <String>[
                          'Tapos I',
                          'Tapos II',
                          'Gunung Malang',
                          'Gunung Mulya',
                          'Situ Daun',
                          'Cinangneng',
                          'Cibitung Tengah'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  Row(
                    children: [
                      const Text("Kategori :"),
                      const SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        itemHeight: kMinInteractiveDimension + 5,
                        value: selectedOptionKategori,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOptionKategori = newValue!;
                          });
                        },
                        items: <String>['air-terjun', 'rekreasi', 'situs']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descController,
                    maxLines:
                        null, // Mengatur jumlah baris menjadi null agar dapat menampung teks yang panjang
                    decoration: InputDecoration(
                      hintText: 'Deskripsi',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10),
                    ),
                  ),
                ],
              ),
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: const Text("Page 2"),
            content: Column(children: [
              Flexible(
                flex: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Operasional',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('Buka/Tutup',
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Senin',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _senin,
                    onChanged: (value) {
                      setState(() {
                        _seninBukaController.text = '';
                        _seninTutupController.text = '';
                        _senin24Checked = false;
                        _senin = value!;
                      });
                    },
                  ),
                  Visibility(
                      visible: _senin,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _senin24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _senin24Checked = value!;
                                  _seninBukaController.text = '';
                                  _seninTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _senin && !_senin24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _seninBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSeninB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSeninB(context);
                            },
                          ),
                          TextFormField(
                            controller: _seninTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSeninT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSeninT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Selasa',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _selasa,
                    onChanged: (value) {
                      setState(() {
                        _selasaBukaController.text = '';
                        _selasaTutupController.text = '';
                        _selasa24Checked = false;
                        _selasa = value!;
                      });
                    },
                  ),
                  Visibility(
                      visible: _selasa,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _selasa24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _selasa24Checked = value!;
                                  _selasaBukaController.text = '';
                                  _selasaTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _selasa && !_selasa24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _selasaBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSelasaB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSelasaB(context);
                            },
                          ),
                          TextFormField(
                            controller: _selasaTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSelasaT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSelasaT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Rabu',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _rabu,
                    onChanged: (value) {
                      setState(() {
                        _rabuBukaController.text = '';
                        _rabuTutupController.text = '';
                        _rabu = value!;
                        _rabu24Checked = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: _rabu,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _rabu24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _rabu24Checked = value!;
                                  _rabuBukaController.text = '';
                                  _rabuTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _rabu && !_rabu24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _rabuBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeRabuB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeRabuB(context);
                            },
                          ),
                          TextFormField(
                            controller: _rabuTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeRabuT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeRabuT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Kamis',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _kamis,
                    onChanged: (value) {
                      setState(() {
                        _kamisBukaController.text = '';
                        _kamisTutupController.text = '';
                        _kamis = value!;
                        _kamis24Checked = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: _kamis,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _kamis24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _kamis24Checked = value!;
                                  _kamisBukaController.text = '';
                                  _kamisTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _kamis && !_kamis24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _kamisBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeKamisB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeKamisB(context);
                            },
                          ),
                          TextFormField(
                            controller: _kamisTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeKamisT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeKamisT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "Jum\'at",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _jumat,
                    onChanged: (value) {
                      setState(() {
                        _jumatBukaController.text = '';
                        _jumatTutupController.text = '';
                        _jumat = value!;
                        _jumat24Checked = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: _jumat,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _jumat24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _jumat24Checked = value!;
                                  _jumatBukaController.text = '';
                                  _jumatTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _jumat && !_jumat24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _jumatBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeJumatB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeJumatB(context);
                            },
                          ),
                          TextFormField(
                            controller: _jumatTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeJumatT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeJumatT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Sabtu',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _sabtu,
                    onChanged: (value) {
                      setState(() {
                        _sabtuBukaController.text = '';
                        _sabtuTutupController.text = '';
                        _sabtu = value!;
                        _sabtu24Checked = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: _sabtu,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _sabtu24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _sabtu24Checked = value!;
                                  _sabtuBukaController.text = '';
                                  _sabtuTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _sabtu && !_sabtu24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _sabtuBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSabtuB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSabtuB(context);
                            },
                          ),
                          TextFormField(
                            controller: _sabtuTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSabtuT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSabtuT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Minggu',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _minggu,
                    onChanged: (value) {
                      setState(() {
                        _mingguBukaController.text = '';
                        _mingguTutupController.text = '';
                        _minggu = value!;
                        _minggu24Checked = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: _minggu,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _minggu24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _minggu24Checked = value!;
                                  _mingguBukaController.text = '';
                                  _mingguTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _minggu && !_minggu24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _mingguBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeMingguB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeMingguB(context);
                            },
                          ),
                          TextFormField(
                            controller: _mingguTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeMingguT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeMingguT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Penginapan / Camping :",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(
                    width: 10,
                  ),
                  Switch(
                    value: switchValueCamp,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool newValue) {
                      setState(() {
                        switchValueCamp = newValue;
                      });
                    },
                  ),
                ],
              )
            ])),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: const Text("Page 3"),
            content:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  // Text(
                  //   '${widget.documentId.data()['imageGaleries'][0]}',
                  //   softWrap: true,
                  //   style: TextStyle(color: Colors.red),
                  // ),
                  // Text('${widget.documentId.data()['imageGaleries'][1]}',
                  //     softWrap: true, style: TextStyle(color: Colors.red)),
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text("Galeri :",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      List<XFile> selectedImages =
                          await ImagePicker().pickMultiImage();

                      if (selectedImages.isNotEmpty) {
                        var urls = await uploadImagesToFirebase(selectedImages);
                        setState(() {
                          downloadUrls?.addAll(urls);
                        });

                        // Lakukan sesuatu dengan URL download gambar
                        // Misalnya, simpan URL ke database atau tampilkan di UI
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: const [
                          Icon(
                            Iconsax.add,
                            color: Colors.white,
                          ),
                          Text("Tambah",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              downloadUrls == null
                  ? const SizedBox()
                  : Container(
                      height: 100, // Atur tinggi sesuai kebutuhan
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            downloadUrls!.length, // Jumlah gambar dalam galeri
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Stack(children: [
                                    Image.network(
                                      downloadUrls![index],
                                      height: 100,
                                      width: 150, // Atur lebar sesuai kebutuhan
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: downloadUrls!.isEmpty
                                            ? null
                                            : () {
                                                setState(() {
                                                  downloadUrls!.remove(
                                                      downloadUrls?[index]
                                                          .toString());
                                                });
                                              },
                                        child: const Icon(
                                          Icons.disabled_by_default_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ])));
                        },
                      ),
                    ),
              const SizedBox(height: 10),
              TextFormField(
                onChanged: validateTiket,
                controller: _tiketController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Tiket",
                  errorText:
                      _isNamaEmpty ? 'Nama wisata tidak boleh kosong' : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 10),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Lokasi :",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          spreadRadius: -2,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        mapsOrLatlong
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5)),
                                ),
                                child: const Icon(
                                  Icons.place_rounded,
                                  color: Colors.white,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    mapsOrLatlong = true;
                                    textFieldToMaps();
                                    _markers.clear();
                                    if (_latController.text.isNotEmpty &&
                                        _longController.text.isNotEmpty) {
                                      _markers.add(
                                        Marker(
                                          markerId: const MarkerId(
                                              'selected_location'),
                                          position: _selectedLocation!,
                                        ),
                                      );
                                    }
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  color: Colors.white,
                                  child: const Icon(
                                    Icons.place_rounded,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                        !mapsOrLatlong
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                ),
                                child: Icon(
                                  Icons.text_snippet_rounded,
                                  color: Colors.white,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    mapsOrLatlong = false;
                                    mapsToTextField();
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  color: Colors.white,
                                  child: const Icon(
                                    Icons.text_snippet_rounded,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              mapsOrLatlong
                  ? Expanded(
                      flex: 0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: GoogleMap(
                            zoomGesturesEnabled: true,
                            onCameraMove: (controller) {
                              _mapController =
                                  controller as GoogleMapController;
                            },
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(
                                  () => PanGestureRecognizer())),
                            onTap: (LatLng latLng) {
                              setState(() {
                                _selectedLocation = latLng;
                                _markers
                                    .clear(); // Hapus marker sebelumnya (jika ada)
                                _markers.add(
                                  Marker(
                                    markerId:
                                        const MarkerId('selected_location'),
                                    position: _selectedLocation!,
                                  ),
                                );
                              });
                            },
                            markers: _markers,
                            polygons: _polygon,
                            initialCameraPosition: CameraPosition(
                              target: _selectedLocation != null
                                  ? _selectedLocation!
                                  : LatLng(-6.6400000,
                                      106.708000), // Koordinat awal peta
                              zoom: 12, // Tingkat zoom awal
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: getLat,
                            controller: _latController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Latitude",
                              errorText: _isLatEmpty
                                  ? 'Latitude tidak boleh kosong'
                                  : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 10),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            onChanged: (value) => getLong(value),
                            controller: _longController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Longitude",
                              errorText: _isLongEmpty
                                  ? 'Longitude tidak boleh kosong'
                                  : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
              Row(
                children: [
                  const Text("Tutup Sementara :",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(
                    width: 10,
                  ),
                  Switch(
                    value: switchValueTempClosed,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool newValue) {
                      setState(() {
                        switchValueTempClosed = newValue;
                      });
                    },
                  ),
                ],
              ),
            ]))
      ];

  @override
  Widget build(BuildContext context) {
    _polygon.add(
      Polygon(
          polygonId: const PolygonId('1'),
          points: points,
          // fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
          fillColor: Colors.white.withOpacity(0.1),
          geodesic: true,
          strokeWidth: 1,
          strokeColor: Theme.of(context).primaryColor.withOpacity(0.8)),
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            // "${widget.documentId.id}",
            "Update Data ${widget.documentId.data()['nama']}",
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            _namaController.text.isNotEmpty &&
                    _tiketController.text.isNotEmpty &&
                    ((_selectedLocation?.latitude != null &&
                            _selectedLocation?.longitude != null) ||
                        (_latController.text.isNotEmpty &&
                            _longController.text.isNotEmpty)) &&
                    _imageUrl != null &&
                    (!_senin ||
                        (_senin24Checked ||
                            (_seninBukaController.text.isNotEmpty &&
                                _seninTutupController.text.isNotEmpty))) &&
                    (!_selasa ||
                        (_selasa24Checked ||
                            (_selasaBukaController.text.isNotEmpty &&
                                _selasaTutupController.text.isNotEmpty))) &&
                    (!_rabu ||
                        (_rabu24Checked ||
                            (_rabuBukaController.text.isNotEmpty &&
                                _rabuTutupController.text.isNotEmpty))) &&
                    (!_kamis ||
                        (_kamis24Checked ||
                            (_kamisBukaController.text.isNotEmpty &&
                                _kamisTutupController.text.isNotEmpty))) &&
                    (!_jumat ||
                        (_jumat24Checked ||
                            (_jumatBukaController.text.isNotEmpty &&
                                _jumatTutupController.text.isNotEmpty))) &&
                    (!_sabtu ||
                        (_sabtu24Checked ||
                            (_sabtuBukaController.text.isNotEmpty &&
                                _sabtuTutupController.text.isNotEmpty))) &&
                    (!_minggu ||
                        (_minggu24Checked ||
                            (_mingguBukaController.text.isNotEmpty &&
                                _mingguTutupController.text.isNotEmpty)))
                ? GestureDetector(
                    onTap: () {
                      if (_namaController.text.isNotEmpty &&
                          _tiketController.text.isNotEmpty &&
                          ((_selectedLocation?.latitude != null &&
                                  _selectedLocation?.longitude != null) ||
                              (_latController.text.isNotEmpty &&
                                  _longController.text.isNotEmpty)) &&
                          _imageUrl != null &&
                          (!_senin ||
                              (_senin24Checked ||
                                  (_seninBukaController.text.isNotEmpty &&
                                      _seninTutupController
                                          .text.isNotEmpty))) &&
                          (!_selasa ||
                              (_selasa24Checked ||
                                  (_selasaBukaController.text.isNotEmpty &&
                                      _selasaTutupController
                                          .text.isNotEmpty))) &&
                          (!_rabu ||
                              (_rabu24Checked ||
                                  (_rabuBukaController.text.isNotEmpty &&
                                      _rabuTutupController.text.isNotEmpty))) &&
                          (!_kamis ||
                              (_kamis24Checked ||
                                  (_kamisBukaController.text.isNotEmpty &&
                                      _kamisTutupController
                                          .text.isNotEmpty))) &&
                          (!_jumat ||
                              (_jumat24Checked ||
                                  (_jumatBukaController.text.isNotEmpty &&
                                      _jumatTutupController
                                          .text.isNotEmpty))) &&
                          (!_sabtu ||
                              (_sabtu24Checked ||
                                  (_sabtuBukaController.text.isNotEmpty &&
                                      _sabtuTutupController
                                          .text.isNotEmpty))) &&
                          (!_minggu ||
                              (_minggu24Checked ||
                                  (_mingguBukaController.text.isNotEmpty &&
                                      _mingguTutupController
                                          .text.isNotEmpty)))) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(24.0, 15, 24.0, 10),
                              actionsPadding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              title: const Text('Perhatian!'),
                              content: const Text(
                                'Apakah anda yakin ingin menyimpan perubahan wisata ini?',
                                style: TextStyle(fontSize: 16),
                              ),
                              actions: <Widget>[
                                const Divider(
                                  thickness: 1,
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: const Text(
                                            'Simpan',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      onPressed: () {
                                        updateDataToFirestore();
                                        // Get.to(const Dashboard());
                                        Get.snackbar(
                                          'Sukses',
                                          'Data berhasil diubah',
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 3),
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                        Navigator.pop(context);
                                        print("Completed");
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('Kembali'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Get.defaultDialog(
                          title: 'Data tidak lengkap',
                          middleText: 'lengkapi data terlebih dahulu',
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).accentColor),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                    ))
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.save,
                      color: Colors.grey,
                    ),
                  )
          ],
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
              colorScheme:
                  ColorScheme.light(primary: Theme.of(context).primaryColor)),
          child: Stepper(
            elevation: 0,
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            controlsBuilder: (BuildContext context, ControlsDetails controls) {
              return Row(
                children: [
                  ElevatedButton(
                    onPressed: controls.onStepContinue,
                    child: Text(currentStep < getSteps().length - 1
                        ? 'Selanjutnya'
                        : 'Simpan'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: controls.onStepCancel,
                    child: const Text('Kembali'),
                  ),
                ],
              );
            },
            onStepContinue: () {
              final isLastStep = currentStep == getSteps().length - 1;
              if (isLastStep) {
                if (_namaController.text.isNotEmpty &&
                    _imageUrl != null &&
                    _tiketController.text.isNotEmpty &&
                    (!_senin ||
                        (_senin24Checked ||
                            (_seninBukaController.text.isNotEmpty &&
                                _seninTutupController.text.isNotEmpty))) &&
                    (!_selasa ||
                        (_selasa24Checked ||
                            (_selasaBukaController.text.isNotEmpty &&
                                _selasaTutupController.text.isNotEmpty))) &&
                    (!_rabu ||
                        (_rabu24Checked ||
                            (_rabuBukaController.text.isNotEmpty &&
                                _rabuTutupController.text.isNotEmpty))) &&
                    (!_kamis ||
                        (_kamis24Checked ||
                            (_kamisBukaController.text.isNotEmpty &&
                                _kamisTutupController.text.isNotEmpty))) &&
                    (!_jumat ||
                        (_jumat24Checked ||
                            (_jumatBukaController.text.isNotEmpty &&
                                _jumatTutupController.text.isNotEmpty))) &&
                    (!_sabtu ||
                        (_sabtu24Checked ||
                            (_sabtuBukaController.text.isNotEmpty &&
                                _sabtuTutupController.text.isNotEmpty))) &&
                    (!_minggu ||
                        (_minggu24Checked ||
                            (_mingguBukaController.text.isNotEmpty &&
                                _mingguTutupController.text.isNotEmpty)))) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding:
                            const EdgeInsets.fromLTRB(24.0, 15, 24.0, 10),
                        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        title: const Text('Perhatian!'),
                        content: const Text(
                          'Apakah anda yakin ingin menyimpan perubahan wisata ini?',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: <Widget>[
                          const Divider(
                            thickness: 1,
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: const Text(
                                      'Update',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                onPressed: () {
                                  updateDataToFirestore();
                                  // Get.to(Dashboard());
                                  Navigator.pop(context);
                                  print("Completed");
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('Kembali'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Get.defaultDialog(
                    title: 'Data tidak lengkap',
                    middleText: 'lengkapi data terlebih dahulu',
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).accentColor),
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                }
              } else {
                setState(() {
                  currentStep += 1;
                });
              }
            },
            onStepCancel: currentStep == 0
                ? () {
                    Get.defaultDialog(
                      title: 'Konfirmasi',
                      middleText: 'Apakah Anda yakin ingin keluar?',
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          onPressed: () {
                            Get.back();
                            Navigator.pop(context);
                          },
                          child: const Text('Ya'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).accentColor),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Tidak'),
                        ),
                      ],
                    );
                  }
                : () {
                    setState(() {
                      currentStep -= 1;
                    });
                  },
            onStepTapped: (step) => setState(() {
              currentStep = step;
            }),
          ),
        ));
  }
}
