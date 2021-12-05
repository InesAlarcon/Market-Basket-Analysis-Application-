import 'dart:convert';
import 'dart:convert';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:file/memory.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:intl/intl.dart';
import 'package:mbaa/api/firebase_api.dart';
import 'package:mbaa/model/firebase_file.dart';
import 'package:mbaa/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:file/file.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';




class ReportingScreen extends StatefulWidget {
  @override
  _ReportingScreenState createState() => _ReportingScreenState();
}

class _ReportingScreenState extends State<ReportingScreen>
    with SingleTickerProviderStateMixin{

  late TabController _tabController;
  Image? wc;
  Image? freq;
  Image? maptree;
  Image? freqitems;
  Image? pivots;

  late Future<List<FirebaseFile>> futureFiles;
  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll(id);
  }

  final firestoreInstance = FirebaseFirestore.instance;
  String doc_id = '0';
  String id = FirebaseAuth.instance.currentUser!.uid;
  Future<void>? _launched;
  FirebaseFile? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'MARKET BASKET ANALYSIS',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body:
      Container(
        height: 1000,
        width: 2100,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: ListView(
          padding: EdgeInsets.all(12.0),
          children: [
            Card(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.file_copy),
                  label: Text("Seleccionar Archivo"),
                  onPressed: () async {
                    var picked = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['csv'],
                      withReadStream: true,
                    );

                    if (picked != null) {
                      // Sending file
                      //---Create http package multipart request object
                      final request = http.MultipartRequest(
                        "POST",
                        Uri.parse("http://127.0.0.1:15000/file"),
                      );


                      // Adding selected file
                      request.files.add(
                        new http.MultipartFile(
                          "filebytes",
                          picked.files.first.readStream!,
                          picked.files.first.size,
                          filename: picked.files.first.name,
                        ),
                      );

                      //-------Send request
                      http.StreamedResponse response = await showDialog(
                        context: context,
                        builder: (context) =>
                            FutureProgressDialog(Future<http.StreamedResponse>(
                                    ()async{
                                  return await request.send();
                                }
                            ),
                                message: Text('Loading...')),
                      );

                      // Parse raw response
                      http.Response parsedResponse =
                      await http.Response.fromStream(response);

                      // Check Status
                      if (parsedResponse.statusCode == 200) {
                        // Parsear body
                        Map<String, dynamic> recvJson =
                        JsonDecoder().convert(parsedResponse.body);
                        // Extract values
                        var message = recvJson['message'];
                        print(message);

                        //////////////////////////////////////////////////
                        var time = recvJson['time'];
                        //print(time);

                        var date = recvJson['date'];
                        //print(date);

                        var utcnow = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy, ' ', HH, ':', nn]);

                        var transactions = recvJson['transactions'];
                        //print(transactions);
                        //////////////////////////////////////////////////

                        String wordcloud = recvJson['wordcloud'];
                        Uint8List _bytesImage;
                        _bytesImage = Base64Decoder().convert(wordcloud);
                        UploadTask wctask = FirebaseStorage.instance.ref(id).child(utcnow.toString()).child("Wordcloud.png").putData(_bytesImage);
                        var urlwordcloud = await (await wctask).ref.getDownloadURL();
                        var urlwc = urlwordcloud.toString();
                        //print(urlwc);
                        String frequency = recvJson['frequency'];
                        Uint8List _bytesImagef;
                        _bytesImagef = Base64Decoder().convert(frequency);
                        UploadTask frtask = FirebaseStorage.instance.ref(id).child(utcnow.toString()).child("Frequency.png").putData(_bytesImagef);
                        var urlfreq = await (await frtask).ref.getDownloadURL();
                        var urlfr = urlfreq.toString();
                        //print(urlfr);

                        String mptree = recvJson['maptree'];
                        Uint8List _bytesImagemt;
                        _bytesImagemt = Base64Decoder().convert(mptree);
                        UploadTask mptask = FirebaseStorage.instance.ref(id).child(utcnow.toString()).child("Map Tree.png").putData(_bytesImagemt);
                        var urlmaptree = await (await mptask).ref.getDownloadURL();
                        var urlmp = urlmaptree.toString();
                        // print(urlmp);

                        String frqitems = recvJson['freqitems'];
                        Uint8List _bytesImagefi;
                        _bytesImagefi = Base64Decoder().convert(frqitems);
                        UploadTask fitask = FirebaseStorage.instance.ref(id).child(utcnow.toString()).child("Frequent Items.png").putData(_bytesImagefi);
                        var urlfreqitems = await (await fitask).ref.getDownloadURL();
                        var urlfi = urlfreqitems.toString();
                        //print(urlmp);

                        var filebase64 = recvJson['file64'];
                        var extension = recvJson['extension'];

                        // Convert base 64 to Array of int8 (aka, string to byte conversion)
                        Uint8List bytes = base64.decode(filebase64);
                        // Flutter web shenanigans to manipulate files and download it
                        final blob = html.Blob([bytes]);
                        final url = html.Url.createObjectUrlFromBlob(blob);
                        final anchor =
                        html.document.createElement('a') as html.AnchorElement
                          ..href = url
                          ..style.display = 'none'
                          ..download = 'TimeAnalysisTable.' + extension;
                        html.document.body!.children.add(anchor);
                        // download
                        anchor.click();
                        // cleanup
                        html.document.body!.children.remove(anchor);
                        html.Url.revokeObjectUrl(url);
                        UploadTask tattask = FirebaseStorage.instance.ref(id).child(utcnow.toString()).child("Time Analysis Table.xlsx").putData(bytes);
                        var urltimeanalysistable = await (await tattask).ref.getDownloadURL();
                        var urltat = urltimeanalysistable.toString();
                        //print(urltat);

                        setState(() {
                          wc = Image.memory(_bytesImage);
                          freq = Image.memory(_bytesImagef);
                          maptree = Image.memory(_bytesImagemt);
                          freqitems = Image.memory(_bytesImagefi);
                        });

                        firestoreInstance
                            .collection('empresa')
                            .doc(id)
                            .collection('reportes')
                            .doc()
                            .set({
                          "date": date,
                          "time": time,
                          "transactions": transactions
                        });

                        ////////////////////////////////////////////////////
                        //GUARDAR URLS
                        firestoreInstance
                            .collection('empresa')
                            .doc(id)
                            .collection('historial')
                            .doc(utcnow.toString())
                            .set({
                          "fecha": utcnow.toString(),
                          "wordcloud": urlwc,
                          "frequency": urlfr,
                          "map tree": urlmp,
                          "frequent itemsets": urlfi,
                          "time table analysis": urltat
                        });

                        // Do something else
                      } else {
                        // Reportar error
                        // Do something
                      }
                    }
                  },
                )
            ),
            Card(
              child: Text(
                "Wordcloud",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                  )),
            ),
            Card(
              child: wc,
            ),
            Card(
              child: Text("Frequency", style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
              )
              ),
            ),
            Card(
              child: freq,
            ),
            Card(
              child: Text("Map Tree",style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
              )),
            ),
            Card(
              child: maptree,
            ),
            Card(
              child: Text("Frequent Itemsets", style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
              ) ),
            ),
            Card(
              child: freqitems,
            )
          ],
        ),
      ),
    );
  }
  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
    title: Text(
      file.name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        color: Colors.blue,
      ),
    ),
    onTap: () => setState(() {
      _launched = _launchInWebViewOrVC(file.url, context);
    }),
  );
  Widget buildHeader(int length) => ListTile(
    tileColor: Colors.blue,
    leading: Container(
      width: 52,
      height: 52,
      child: Icon(
        Icons.file_copy,
        color: Colors.white,
      ),
    ),
    title: Text(
      '$length Files',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}

Future<void> _launchInWebViewOrVC(String url, BuildContext context) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    _showDialog1(context);
  }
}

Future<void> _showDialog1(BuildContext context) {
  return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              'Ha ocurrido un error con tu URL, por favor revisa que sea el correcto'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  _dismissDialog(context);
                },
                child: Text('Close')),
          ],
        );
      });
}

Future<void> _dismissDialog(BuildContext context) async {
  Navigator.pop(context);
}


