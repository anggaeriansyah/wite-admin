import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wite_dashboard/Bloc/auth_bloc.dart';
import 'package:wite_dashboard/Bloc/auth_event.dart';
import 'package:wite_dashboard/Bloc/auth_state.dart';
import 'package:wite_dashboard/Screen/detailScreen.dart';
import 'package:wite_dashboard/Screen/tambah_screen.dart';
import 'package:wite_dashboard/Screen/update_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

//

class _DashboardState extends State<Dashboard> {
  var db = FirebaseFirestore.instance;
// var listItem;
  var listItemOnSearch;
  TextEditingController _searchController = TextEditingController();
  // QuerySnapshot? _searchResults;
  var _searchResults;

  bool onSearching = false;
  @override
  void initState() {
    super.initState();
    _searchData('');
  }

  getData() {
    return _searchResults;
  }

  Future<void> deleteImageFromFirebase(String imageUrl) async {
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);
    // Menghapus gambar dari Firebase Storage
    await ref.delete();
  }

  // Stream<Object>? convertQuerySnapshotToStream(_JsonQuerySnapshot querySnapshot) {
  //   return Stream.fromFuture(
  //       Future(() => querySnapshot.docs.map((doc) => doc.data()).toList()));
  // }

  void _searchData(value) {
    final query = value;
    final queryLetters = query.split('');
    if (query == '') {
      final snapshot = FirebaseFirestore.instance
          .collection('wisata') // Ganti dengan nama koleksi Firebase Anda
          // .orderBy('nama')
          .snapshots();

      setState(() {
        _searchResults = snapshot;
      });
    } else {
      final snapshot = FirebaseFirestore.instance
          .collection('wisata') // Ganti dengan nama koleksi Firebase Anda
          .orderBy('nama')
          .where('nama',
              isGreaterThanOrEqualTo: query) // Pencarian di tengah kata
          .where('nama', isLessThan: query + 'z') // Pencarian di tengah kata
          .snapshots();

      setState(() {
        _searchResults = snapshot;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                showChangePasswordDialog(context);
              },
              child: const Icon(Icons.key)),
          centerTitle: true,
          title: const Text(
            "Kelola Wisata",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding:
                          const EdgeInsets.fromLTRB(24.0, 15, 24.0, 10),
                      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      title: const Text('Perhatian!'),
                      content: const Text(
                        'Apakah anda yakin ingin Logout?',
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
                                    'Logout',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              onPressed: () {
                                Navigator.pop(context);
                                FirebaseAuth.instance.signOut();
                                print("Logout");
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('Batal'),
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
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.logout_rounded),
              ),
            )
          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              // Lakukan logout
              FirebaseAuth.instance.signOut();
            }
          },
          child: GestureDetector(
            onTap: () {
              authBloc.add(const AuthUserInteraction());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 25, bottom: 20, right: 20, left: 20),
                  child: GestureDetector(
                    onTap: () => Get.to(TambahScreen()),
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 10,
                                  color: Colors.black12,
                                  // spreadRadius: 0.5,
                                )
                              ]),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add_box_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Tambah data wisata',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 2,
                ),
                Flexible(
                    // child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 20, vertical: 20),
                    //     child: ListView.builder(
                    //         itemCount: item.length,
                    //         itemBuilder: ((context, index) {
                    //           return Container(
                    //               margin: const EdgeInsets.only(bottom: 5),
                    //               // padding: const EdgeInsets.all(16),
                    //               decoration: BoxDecoration(
                    //                   color: Theme.of(context).primaryColor,
                    //                   borderRadius: const BorderRadius.all(
                    //                       Radius.circular(20)),
                    //                   boxShadow: const [
                    //                     BoxShadow(
                    //                       offset: Offset(0, 3),
                    //                       blurRadius: 10,
                    //                       color: Colors.black12,
                    //                       // spreadRadius: 0.5,
                    //                     )
                    //                   ]),
                    //               child:
                    //                   // ListTile(
                    //                   //   leading: Text(item[index].toString()),
                    //                   //   // subtitle: const Text('tes'),
                    //                   //   trailing: Row(
                    //                   //     children: const [
                    //                   //       Expanded(
                    //                   //         child: Icon(
                    //                   //           Icons.edit,
                    //                   //           size: 30,
                    //                   //           color: Colors.white,
                    //                   //         ),
                    //                   //       ),
                    //                   //       Expanded(
                    //                   //         child: Icon(
                    //                   //           Icons.edit,
                    //                   //           size: 30,
                    //                   //           color: Colors.white,
                    //                   //         ),
                    //                   //       ),
                    //                   //     ],
                    //                   //   ),
                    //                   // ),
                    //                   ListTile(
                    //                 leading: Image.network(
                    //                     "https://firebasestorage.googleapis.com/v0/b/wite-firebase.appspot.com/o/kampung-istal.jpeg?alt=media&token=f14f2fdc-770b-451f-ab50-70a5d8fe2878&_gl=1*17chxsf*_ga*NjU0MDExNDQ4LjE2ODU1MTU2MjQ.*_ga_CW55HF8NVT*MTY4NTcxNTQ3MC4xNS4xLjE2ODU3MTc5OTAuMC4wLjA.",
                    //                     width: 40,
                    //                     height: 40,
                    //                     alignment: Alignment.centerLeft,
                    //                     fit: BoxFit.cover),
                    //                 title: Text(
                    //                   'John Doe',
                    //                   style: const TextStyle(
                    //                       color: Colors.white,
                    //                       overflow: TextOverflow.fade),
                    //                 ),
                    //                 trailing: Row(
                    //                   mainAxisSize: MainAxisSize.min,
                    //                   children: [
                    //                     IconButton(
                    //                       onPressed: () {
                    //                         // Aksi ketika tombol ditekan
                    //                       },
                    //                       icon: const Icon(
                    //                         Icons.edit,
                    //                         color: Colors.white,
                    //                       ),
                    //                     ),
                    //                     IconButton(
                    //                       onPressed: () {
                    //                         // Aksi ketika ikon ditekan
                    //                       },
                    //                       icon: const Icon(
                    //                         Icons.delete,
                    //                         color: Colors.white,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ));
                    //           // Container(
                    //           //     margin: const EdgeInsets.only(bottom: 5),
                    //           //     padding: const EdgeInsets.all(16),
                    //           //     decoration: BoxDecoration(
                    //           //         color: Theme.of(context).primaryColor,
                    //           //         borderRadius: const BorderRadius.all(
                    //           //             Radius.circular(20)),
                    //           //         boxShadow: const [
                    //           //           BoxShadow(
                    //           //             offset: Offset(0, 3),
                    //           //             blurRadius: 10,
                    //           //             color: Colors.black12,
                    //           //             // spreadRadius: 0.5,
                    //           //           )
                    //           //         ]),
                    //           //     child: Text(
                    //           //       item[index].toString(),
                    //           //       style: const TextStyle(
                    //           //         color: Colors.white,
                    //           //       ),
                    //           //     )

                    //           //     );
                    //         }))

                    //         )
                    child: Scaffold(
                        appBar: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          toolbarHeight: 60,
                          titleSpacing: 0.0,
                          automaticallyImplyLeading: false,
                          title: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              right: 20,
                              left: 20,
                            ),
                            child: TextField(
                              controller: _searchController,
                              // onChanged: (value) {
                              //   setState(() {
                              //     listNamaOnSearch = listItem
                              //         .where((element) =>
                              //             element.toLowerCase().contains(value.toLowerCase()))
                              //         .toList();
                              //   });
                              // },

                              onChanged: ((value) =>
                                  _searchData(value.capitalize)),
                              style: const TextStyle(
                                  height: 1.2, color: Colors.black54),
                              // autofocus: true,
                              cursorColor: Colors.black54,
                              cursorWidth: 1.5,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(0),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none),
                                hintText: 'cari',
                                hintStyle:
                                    const TextStyle(color: Colors.black38),
                                prefixIcon: const Icon(
                                  Iconsax.search_normal,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        body: _searchResults == null
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            // const Padding(
                            //     padding: EdgeInsets.only(top: 20),
                            //     child: Align(
                            //       alignment: Alignment.topCenter,
                            //       child: Text(
                            //         'Wisata tidak ditemukan',
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.w500, color: Colors.black54),
                            //       ),
                            //     ),
                            //   )
                            : StreamBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                stream: getData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black54)),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text("Error"),
                                    );
                                  }
                                  var wisata = snapshot.data!.docs;
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: wisata.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        final document = wisata[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                DetailScreen(wisata: document));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              top: 4,
                                              left: 20,
                                              right: 20,
                                              bottom: 15,
                                            ),
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(0, 2),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20)),
                                                    child: document['image']
                                                                .toString()
                                                                .substring(
                                                                    0, 6) !=
                                                            'assets'
                                                        ? CachedNetworkImage(
                                                            imageUrl: document[
                                                                'image'],
                                                            height: 80,
                                                            width: 80,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image(
                                                            height: 80,
                                                            width: 80,
                                                            image: AssetImage(
                                                                document[
                                                                    'image']),
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                                ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 20.0,
                                                            vertical: 3),
                                                    leading: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 60),
                                                      child: const Text(''),
                                                    ),
                                                    title: Text(
                                                      document['nama'],
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                    subtitle: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Flexible(
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .locationArrow,
                                                              size: 13,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            flex: 5,
                                                            child: Text(
                                                              document['desa'],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              maxLines: 1,
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    trailing: Column(
                                                      // crossAxisAlignment:
                                                      //     CrossAxisAlignment.center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () => Get.to(
                                                              UpdateScreen(
                                                                  documentId:
                                                                      document)),
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            _dialogBuilder(
                                                                context,
                                                                document);
                                                            deleteImageFromFirebase(
                                                                document[
                                                                    'image']);
                                                            // document.reference
                                                            //     .delete()
                                                            //     .then((value) => print(
                                                            //         "Delete berhasil"));
                                                          },
                                                          child: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                })))
              ],
            ),
          ),
        ));
  }
}

Future<void> _dialogBuilder(BuildContext context, data) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24.0, 15, 24.0, 10),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: const Text('Perhatian!'),
        content: const Text(
          'Apakah anda yakin ingin menghapus wisata ini?',
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
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: () {
                  data.reference
                      .delete()
                      .then((value) => print("Delete berhasil"));
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
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
}

showChangePasswordDialog(BuildContext context) {
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';
  String pesanKesalahan = '';
  bool isLoading = false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Center(child: Text('Ganti Password')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                onChanged: (value) {
                  currentPassword = value;
                },
                decoration: InputDecoration(
                  labelText: 'Password Saat Ini',
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  newPassword = value;
                },
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  confirmPassword = value;
                },
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          )))
                  : pesanKesalahan == ''
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              softWrap: true,
                              pesanKesalahan,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.red),
                            ),
                          ),
                        ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary:
                      Theme.of(context).primaryColor, // Warna latar belakang
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (currentPassword.isEmpty ||
                        newPassword.isEmpty ||
                        confirmPassword.isEmpty) {
                      setState(() {
                        isLoading = false;
                        pesanKesalahan = 'Semua field password harus diisi';
                      });
                      print('Semua field password harus diisi');
                      return;
                    }

                    if (newPassword != confirmPassword) {
                      setState(() {
                        isLoading = false;
                        pesanKesalahan = 'Konfirmasi password tidak cocok';
                      });
                      print('Konfirmasi password tidak cocok');
                      return;
                    }
                    if (user != null) {
                      AuthCredential credential = EmailAuthProvider.credential(
                        email: user.email!,
                        password: currentPassword,
                      );

                      await user.reauthenticateWithCredential(credential);
                      await user.updatePassword(newPassword);
                      print('Password berhasil diubah');
                      setState(() {
                        isLoading = false;
                        pesanKesalahan = 'Password berhasil diubah';
                      });
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        isLoading = false;
                        pesanKesalahan = 'Pengguna tidak ditemukan';
                      });
                      print('Pengguna tidak ditemukan');
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                      pesanKesalahan =
                          'Terjadi kesalahan saat mengubah password';
                    });
                    String errorMessage =
                        'Terjadi kesalahan saat mengubah password';

                    if (e is FirebaseAuthException) {
                      if (e.code == 'wrong-password') {
                        setState(() {
                          isLoading = false;
                          pesanKesalahan = 'Password saat ini salah';
                        });
                        errorMessage = 'Password saat ini salah';
                      } else {
                        setState(() {
                          isLoading = false;
                          pesanKesalahan = '${e.message}';
                        });
                        errorMessage = '${e.message}';
                      }
                    }
                    setState(() {
                      isLoading = false;
                      pesanKesalahan = '$errorMessage';
                    });
                    print(errorMessage);
                  }
                },
                child: const Text('Ubah'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15, bottom: 5),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Theme.of(context).primaryColor, // Warna latar belakang
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Batal'),
              ),
            ),
          ],
        );
      });
    },
  );
}
