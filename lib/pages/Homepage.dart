// // import 'dart:io';
// // import 'package:flutter/foundation.dart' show kIsWeb;
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:translator/translator.dart';
// // import 'package:tflite_flutter/tflite_flutter.dart';
// // import 'package:image/image.dart' as img;
// // import 'package:pashudhan/Authentication/Authentication.dart';
// //
// // class MyIntro extends StatefulWidget {
// //   @override
// //   _MyIntroState createState() => _MyIntroState();
// // }
// //
// // class _MyIntroState extends State<MyIntro> {
// //   int _selectedIndex = 0;
// //
// //   /// ---- Shared state ----
// //   List<XFile> _images = []; // store up to 2 images
// //   List<Map<String, dynamic>> _predictions = [];
// //   final picker = ImagePicker();
// //
// //   final translator = GoogleTranslator();
// //   String dropdownValue = "en"; // default
// //   final Map<String, String> languages = {
// //     "hi": "Hindi",
// //     "pa": "Punjabi",
// //     "en": "English",
// //   };
// //
// //   /// Cache translations
// //   final Map<String, Map<String, String>> _translationCache = {};
// //   String? confirmedBreed;
// //
// //   /// ---- Activity Log ----
// //   List<Map<String, dynamic>> activityLog = [];
// //
// //   /// ---- TFLite Model ----
// //   late Interpreter _interpreter;
// //   late List<String> _labels;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadModel();
// //   }
// //
// //   Future<void> _loadModel() async {
// //     _interpreter = await Interpreter.fromAsset('assets/best_float32.tflite');
// //     _labels = [
// //       "Alambadi","Amritmahal","Ayrshire","Banni","Bargur","Bhadawari","Brown_Swiss","Dangi","Deoni","Gir",
// //       "Guernsey","Hallikar","Hariana","Holstein_Friesian","Jaffrabadi","Jersey","Kangayam","Kankrej","Kasargod",
// //       "Kenkatha","Kherigarh","Khillari","Krishna_Valley","Malnad_gidda","Mehsana","Murrah","Nagori","Nagpuri",
// //       "Nili_Ravi","Nimari","Ongole","Pulikulam","Rathi","Red_Dane","Red_Sindhi","Sahiwal","Surti","Tharparkar",
// //       "Toda","Umblachery","Vechur"
// //     ];
// //   }
// //
// //   /// ---- Preprocess image into 4D float array for TFLite ----
// //   List<List<List<List<double>>>> _preprocess(XFile imageFile) {
// //     final bytes = File(imageFile.path).readAsBytesSync();
// //     img.Image image = img.decodeImage(bytes)!;
// //     image = img.copyResize(image, width: 224, height: 224);
// //
// //     List<List<List<List<double>>>> input = List.generate(
// //         1,
// //             (i) => List.generate(
// //             224,
// //                 (y) => List.generate(
// //                 224,
// //                     (x) => List.generate(
// //                     3,
// //                         (c) {
// //                       int pixel = image.getPixel(x, y);
// //                       int value = 0;
// //                       if (c == 0) value = img.getRed(pixel);
// //                       if (c == 1) value = img.getGreen(pixel);
// //                       if (c == 2) value = img.getBlue(pixel);
// //                       return value / 255.0; // normalize
// //                     }
// //                 )
// //             )
// //         )
// //     );
// //     return input;
// //   }
// //
// //   /// ---- Predict top 3 breeds ----
// //   Future<List<Map<String, dynamic>>> _predict(XFile imageFile) async {
// //     final input = _preprocess(imageFile); // shape [1,224,224,3]
// //     final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
// //
// //     _interpreter.run(input, output);
// //
// //     List<Map<String, dynamic>> results = [];
// //     for (int i = 0; i < _labels.length; i++) {
// //       results.add({
// //         "label": _labels[i],
// //         "confidence": output[0][i],
// //       });
// //     }
// //
// //     results.sort((a, b) => (b["confidence"] as double).compareTo(a["confidence"] as double));
// //     return results.take(3).toList();
// //   }
// //
// //   /// ---- Translation helper ----
// //   Future<String> t(String text) async {
// //     if (dropdownValue == "en") return text;
// //     if (_translationCache[text] != null &&
// //         _translationCache[text]![dropdownValue] != null) {
// //       return _translationCache[text]![dropdownValue]!;
// //     }
// //     final result = await translator.translate(text, to: dropdownValue);
// //     _translationCache[text] ??= {};
// //     _translationCache[text]![dropdownValue] = result.text;
// //     return result.text;
// //   }
// //
// //   /// ---- Image Picking ----
// //   Future<void> _getImage(bool fromCamera) async {
// //     final picked = await picker.pickImage(
// //         source: fromCamera ? ImageSource.camera : ImageSource.gallery);
// //
// //     if (picked != null) {
// //       setState(() {
// //         if (_images.length < 2) _images.add(picked);
// //       });
// //
// //       // Run TFLite prediction on the last image
// //       final preds = await _predict(picked);
// //       setState(() {
// //         _predictions = preds;
// //       });
// //     }
// //   }
// //
// //   /// ---- Confirm Prediction ----
// //   void _confirmPrediction(String breed) {
// //     if (_images.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("⚠ Please upload an image first")),
// //       );
// //       return;
// //     }
// //
// //     setState(() {
// //       confirmedBreed = breed;
// //       activityLog.add({
// //         "animal_id": "TEMP${activityLog.length + 1}",
// //         "breed": breed,
// //         "images": _images.map((e) => e.path).toList(),
// //         "timestamp": DateTime.now().toIso8601String(),
// //       });
// //       _images = [];
// //       _predictions = [];
// //     });
// //
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text("✅ Confirmed: $breed")),
// //     );
// //   }
// //
// //   void _editCattle(int index) {
// //     final controller = TextEditingController(
// //       text: activityLog[index]["breed"],
// //     );
// //
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: const Text("Edit Breed"),
// //         content: TextField(
// //           controller: controller,
// //           decoration: const InputDecoration(hintText: "Enter correct breed"),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               setState(() {
// //                 activityLog[index]["breed"] = controller.text;
// //               });
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(content: Text("Breed updated to: ${controller.text}")),
// //               );
// //             },
// //             child: const Text("Submit"),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _deleteCattle(int index) {
// //     setState(() {
// //       activityLog.removeAt(index);
// //     });
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Cattle Record Deleted")),
// //     );
// //   }
// //
// //   void _uploadtoserver(int index) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Data Successfully Uploaded")),
// //     );
// //   }
// //
// //   /// ---- UI Helpers ----
// //   Widget animatedIcon(IconData icon, {Color color = Colors.white, double size = 24}) {
// //     return AnimatedSwitcher(
// //       duration: const Duration(milliseconds: 300),
// //       transitionBuilder: (child, anim) => RotationTransition(
// //         turns: anim,
// //         child: ScaleTransition(scale: anim, child: child),
// //       ),
// //       child: Icon(icon, key: ValueKey(icon.codePoint), color: color, size: size),
// //     );
// //   }
// //
// //   Widget _previewImage() {
// //     if (_images.isEmpty) return const SizedBox();
// //     return Column(
// //       children: _images
// //           .map((imgFile) => kIsWeb
// //           ? Image.network(imgFile.path, height: 180, fit: BoxFit.cover)
// //           : Image.file(File(imgFile.path), height: 180, fit: BoxFit.cover))
// //           .toList(),
// //     );
// //   }
// //
// //   Widget _homeTab() {
// //     return FutureBuilder(
// //       future: Future.wait([t("Camera"), t("Gallery"), t("Result"), t("No results found")]),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData)
// //           return const Center(child: CircularProgressIndicator());
// //
// //         final texts = snapshot.data as List<String>;
// //
// //         return SingleChildScrollView(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             children: [
// //               _previewImage(),
// //               const SizedBox(height: 10),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   ElevatedButton.icon(
// //                     icon: animatedIcon(Icons.camera_alt),
// //                     label: Text(texts[0], style: const TextStyle(color: Colors.white)),
// //                     onPressed: () => _getImage(true),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.blueAccent,
// //                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
// //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //                     ),
// //                   ),
// //                   ElevatedButton.icon(
// //                     icon: animatedIcon(Icons.photo),
// //                     label: Text(texts[1], style: const TextStyle(color: Colors.white)),
// //                     onPressed: () => _getImage(false),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.blueAccent,
// //                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
// //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const Divider(),
// //               Text(texts[2], style: const TextStyle(fontSize: 18)),
// //               ..._predictions.map(
// //                     (p) => Card(
// //                   child: ListTile(
// //                     title: Text("${p['label']}"),
// //                     subtitle: LinearProgressIndicator(
// //                       value: p['confidence'],
// //                       color: Colors.green,
// //                       backgroundColor: Colors.white,
// //                     ),
// //                     trailing: Text("${(p['confidence'] * 100).toStringAsFixed(1)}%"),
// //                     onTap: () => _confirmPrediction(p['label']),
// //                   ),
// //                 ),
// //               ),
// //               if (_predictions.isEmpty)
// //                 Column(
// //                   children: [
// //                     const SizedBox(height: 20),
// //                     Image.asset(
// //                       "research.png",
// //                       width: 220,
// //                       height: 220,
// //                     ),
// //                   ],
// //                 ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _activityTab() {
// //     return FutureBuilder(
// //       future: Future.wait([t("Confirmed Breed:"), t("Correct Breed"), t("Payload ready for BPA:"),
// //         t("Edit"), t("Delete"), t("Upload"), t("No data found")]),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
// //         final texts = snapshot.data as List<String>;
// //
// //         return Container(
// //           color: Colors.grey.shade200,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text("${texts[0]} ${confirmedBreed ?? "None"}", style: const TextStyle(fontSize: 20)),
// //               const SizedBox(height: 20),
// //               Expanded(
// //                 child: activityLog.isEmpty
// //                     ? Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Image.asset("notfound.png", width: 200, height: 200),
// //                       Text(texts[6], style: TextStyle(fontSize: 16, color: Colors.grey.shade800)),
// //                     ],
// //                   ),
// //                 )
// //                     : ListView.builder(
// //                   itemCount: activityLog.length,
// //                   itemBuilder: (context, index) {
// //                     final item = activityLog[index];
// //                     return Card(
// //                       color: Colors.blueAccent,
// //                       child: ListTile(
// //                         title: Text("ID: ${item['animal_id']} | Breed: ${item['breed']}",
// //                             style: const TextStyle(color: Colors.white)),
// //                         subtitle: Text("Time: ${item['timestamp']}", style: const TextStyle(color: Colors.white)),
// //                         trailing: PopupMenuButton<String>(
// //                           icon: animatedIcon(CupertinoIcons.slider_horizontal_3),
// //                           onSelected: (value) {
// //                             if (value == "edit") _editCattle(index);
// //                             if (value == "delete") _deleteCattle(index);
// //                             if (value == "upload") _uploadtoserver(index);
// //                           },
// //                           itemBuilder: (context) => [
// //                             PopupMenuItem(value: "edit", child: Text(texts[3])),
// //                             PopupMenuItem(value: "delete", child: Text(texts[4])),
// //                             PopupMenuItem(value: "upload", child: Text(texts[5])),
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final tabs = [_homeTab(), _activityTab()];
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade200,
// //       appBar: AppBar(
// //         backgroundColor: Colors.blueAccent,
// //         elevation: 0,
// //         title: FutureBuilder(
// //           future: t("PashuSaarthi"),
// //           builder: (context, snapshot) => Text(snapshot.data?.toString() ?? "PashuSaarthi",
// //               style: const TextStyle(color: Colors.white)),
// //         ),
// //         actions: [
// //           DropdownButton<String>(
// //             value: dropdownValue,
// //             dropdownColor: Colors.black87,
// //             underline: const SizedBox(),
// //             style: const TextStyle(color: Colors.white),
// //             icon: animatedIcon(Icons.arrow_drop_down),
// //             items: languages.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value,
// //                 style: const TextStyle(color: Colors.white)))).toList(),
// //             onChanged: (val) => setState(() => dropdownValue = val!),
// //           ),
// //           IconButton(
// //             onPressed: () {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => Login()),
// //               );
// //             },
// //             icon: animatedIcon(Icons.logout),
// //           ),
// //         ],
// //       ),
// //       body: tabs[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: (i) => setState(() => _selectedIndex = i),
// //         type: BottomNavigationBarType.fixed,
// //         backgroundColor: Colors.blueAccent,
// //         selectedItemColor: Colors.white,
// //         unselectedItemColor: Colors.white70,
// //         items: [
// //           BottomNavigationBarItem(icon: animatedIcon(CupertinoIcons.house_fill),
// //               label: dropdownValue == "en" ? "Home" : dropdownValue == "hi" ? "होम" : "ਘਰ"),
// //           BottomNavigationBarItem(icon: animatedIcon(CupertinoIcons.square_grid_4x3_fill),
// //               label: dropdownValue == "en" ? "Activity" : dropdownValue == "hi" ? "गतिविधि" : "ਗਤੀਵਿਧੀ"),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // -----------------------
// // import 'dart:io';
// // import 'package:flutter/foundation.dart' show kIsWeb;
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:translator/translator.dart';
// // import 'package:tflite_flutter/tflite_flutter.dart';
// // import 'package:image/image.dart' as img;
// // import 'package:pashudhan/Authentication/Authentication.dart';
// //
// // class MyIntro extends StatefulWidget {
// //   @override
// //   _MyIntroState createState() => _MyIntroState();
// // }
// //
// // class _MyIntroState extends State<MyIntro> {
// //   int _selectedIndex = 0;
// //
// //   /// ---- Shared state ----
// //   List<XFile> _images = []; // store up to 2 images per cattle
// //   List<Map<String, dynamic>> _predictions = [];
// //   final picker = ImagePicker();
// //
// //   final translator = GoogleTranslator();
// //   String dropdownValue = "en"; // default
// //   final Map<String, String> languages = {
// //     "hi": "Hindi",
// //     "pa": "Punjabi",
// //     "en": "English",
// //   };
// //
// //   /// Cache translations
// //   final Map<String, Map<String, String>> _translationCache = {};
// //   String? confirmedBreed;
// //
// //   /// ---- Activity Log ----
// //   List<Map<String, dynamic>> activityLog = [];
// //
// //   /// ---- TFLite Model ----
// //   late Interpreter _interpreter;
// //   late List<String> _labels;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadModel();
// //   }
// //
// //   Future<void> _loadModel() async {
// //     _interpreter = await Interpreter.fromAsset('assets/best_float32.tflite');
// //     _labels = [
// //       "Alambadi","Amritmahal","Ayrshire","Banni","Bargur","Bhadawari","Brown_Swiss","Dangi","Deoni","Gir",
// //       "Guernsey","Hallikar","Hariana","Holstein_Friesian","Jaffrabadi","Jersey","Kangayam","Kankrej","Kasargod",
// //       "Kenkatha","Kherigarh","Khillari","Krishna_Valley","Malnad_gidda","Mehsana","Murrah","Nagori","Nagpuri",
// //       "Nili_Ravi","Nimari","Ongole","Pulikulam","Rathi","Red_Dane","Red_Sindhi","Sahiwal","Surti","Tharparkar",
// //       "Toda","Umblachery","Vechur"
// //     ];
// //   }
// //
// //   /// ---- Preprocess image into 4D float array for TFLite ----
// //   List<List<List<List<double>>>> _preprocess(XFile imageFile) {
// //     final bytes = File(imageFile.path).readAsBytesSync();
// //     img.Image image = img.decodeImage(bytes)!;
// //     image = img.copyResize(image, width: 224, height: 224);
// //
// //     List<List<List<List<double>>>> input = List.generate(
// //         1,
// //             (i) => List.generate(
// //             224,
// //                 (y) => List.generate(
// //                 224,
// //                     (x) => List.generate(
// //                     3,
// //                         (c) {
// //                       int pixel = image.getPixel(x, y);
// //                       int value = 0;
// //                       if (c == 0) value = img.getRed(pixel);
// //                       if (c == 1) value = img.getGreen(pixel);
// //                       if (c == 2) value = img.getBlue(pixel);
// //                       return value / 255.0; // normalize
// //                     }
// //                 )
// //             )
// //         )
// //     );
// //     return input;
// //   }
// //
// //   /// ---- Predict top 3 breeds ----
// //   Future<List<Map<String, dynamic>>> _predict(XFile imageFile) async {
// //     final input = _preprocess(imageFile); // shape [1,224,224,3]
// //     final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
// //
// //     _interpreter.run(input, output);
// //
// //     List<Map<String, dynamic>> results = [];
// //     for (int i = 0; i < _labels.length; i++) {
// //       results.add({
// //         "label": _labels[i],
// //         "confidence": output[0][i],
// //       });
// //     }
// //
// //     results.sort((a, b) => (b["confidence"] as double).compareTo(a["confidence"] as double));
// //     return results.take(3).toList();
// //   }
// //
// //   /// ---- Translation helper ----
// //   Future<String> t(String text) async {
// //     if (dropdownValue == "en") return text;
// //     if (_translationCache[text] != null &&
// //         _translationCache[text]![dropdownValue] != null) {
// //       return _translationCache[text]![dropdownValue]!;
// //     }
// //     final result = await translator.translate(text, to: dropdownValue);
// //     _translationCache[text] ??= {};
// //     _translationCache[text]![dropdownValue] = result.text;
// //     return result.text;
// //   }
// //
// //   /// ---- Image Picking ----
// //   Future<void> _pickImage(bool fromCamera) async {
// //     if (_images.length >= 2) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("⚠ Maximum 2 images allowed")),
// //       );
// //       return;
// //     }
// //
// //     final picked = await picker.pickImage(
// //         source: fromCamera ? ImageSource.camera : ImageSource.gallery);
// //
// //     if (picked != null) {
// //       setState(() {
// //         _images.add(picked);
// //       });
// //
// //       // Run prediction on first image only
// //       if (_images.length == 1) {
// //         final preds = await _predict(picked);
// //         setState(() {
// //           _predictions = preds;
// //         });
// //       }
// //     }
// //   }
// //
// //   /// ---- Confirm Prediction ----
// //   void _confirmPrediction(String breed) {
// //     if (_images.length < 2) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("⚠ Please upload 2 images")),
// //       );
// //       return;
// //     }
// //
// //     setState(() {
// //       confirmedBreed = breed;
// //       activityLog.add({
// //         "animal_id": "TEMP${activityLog.length + 1}",
// //         "breed": breed,
// //         "images": _images.map((e) => e.path).toList(), // both images
// //         "timestamp": DateTime.now().toIso8601String(),
// //       });
// //       _images = [];
// //       _predictions = [];
// //     });
// //
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text("✅ Confirmed: $breed")),
// //     );
// //   }
// //
// //   void _editCattle(int index) {
// //     final controller = TextEditingController(
// //       text: activityLog[index]["breed"],
// //     );
// //
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: const Text("Edit Breed"),
// //         content: TextField(
// //           controller: controller,
// //           decoration: const InputDecoration(hintText: "Enter correct breed"),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               setState(() {
// //                 activityLog[index]["breed"] = controller.text;
// //               });
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(content: Text("Breed updated to: ${controller.text}")),
// //               );
// //             },
// //             child: const Text("Submit"),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _deleteCattle(int index) {
// //     setState(() {
// //       activityLog.removeAt(index);
// //     });
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Cattle Record Deleted")),
// //     );
// //   }
// //
// //   void _uploadtoserver(int index) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Data Successfully Uploaded")),
// //     );
// //   }
// //
// //   /// ---- View Uploaded Images ----
// //   void _viewUploadedImages(int index) {
// //     final images = activityLog[index]["images"] as List<String>;
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: Text("Uploaded Images"),
// //         content: SizedBox(
// //           height: 300,
// //           child: ListView.builder(
// //             itemCount: images.length,
// //             itemBuilder: (context, i) {
// //               return Column(
// //                 children: [
// //                   Image.file(File(images[i]), height: 150, fit: BoxFit.cover),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                     children: [
// //                       TextButton(
// //                         onPressed: () async {
// //                           final picked = await picker.pickImage(source: ImageSource.gallery);
// //                           if (picked != null) {
// //                             setState(() {
// //                               images[i] = picked.path;
// //                               activityLog[index]["images"] = images;
// //                             });
// //                           }
// //                         },
// //                         child: const Text("Update"),
// //                       ),
// //                       TextButton(
// //                         onPressed: () {
// //                           setState(() {
// //                             images.removeAt(i);
// //                             activityLog[index]["images"] = images;
// //                           });
// //                         },
// //                         child: const Text("Delete"),
// //                       ),
// //                     ],
// //                   ),
// //                   const Divider(),
// //                 ],
// //               );
// //             },
// //           ),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("Close"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   /// ---- UI Helpers ----
// //   Widget animatedIcon(IconData icon, {Color color = Colors.white, double size = 24}) {
// //     return AnimatedSwitcher(
// //       duration: const Duration(milliseconds: 300),
// //       transitionBuilder: (child, anim) => RotationTransition(
// //         turns: anim,
// //         child: ScaleTransition(scale: anim, child: child),
// //       ),
// //       child: Icon(icon, key: ValueKey(icon.codePoint), color: color, size: size),
// //     );
// //   }
// //
// //   Widget _previewImage() {
// //     if (_images.isEmpty) return const SizedBox();
// //     return Column(
// //       children: _images
// //           .map((imgFile) => kIsWeb
// //           ? Image.network(imgFile.path, height: 180, fit: BoxFit.cover)
// //           : Image.file(File(imgFile.path), height: 180, fit: BoxFit.cover))
// //           .toList(),
// //     );
// //   }
// //
// //   Widget _homeTab() {
// //     return FutureBuilder(
// //       future: Future.wait([
// //         t("Upload Image"),
// //         t("Capture Image"),
// //         t("Result"),
// //         t("No results found")
// //       ]),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData)
// //           return const Center(child: CircularProgressIndicator());
// //
// //         final texts = snapshot.data as List<String>;
// //
// //         return SingleChildScrollView(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             children: [
// //               _previewImage(),
// //               const SizedBox(height: 10),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   ElevatedButton.icon(
// //                     icon: animatedIcon(Icons.photo),
// //                     label: Text(texts[0], style: const TextStyle(color: Colors.white)),
// //                     onPressed: () => _pickImage(false),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.blueAccent,
// //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //                     ),
// //                   ),
// //                   ElevatedButton.icon(
// //                     icon: animatedIcon(Icons.camera_alt),
// //                     label: Text(texts[1], style: const TextStyle(color: Colors.white)),
// //                     onPressed: () => _pickImage(true),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.blueAccent,
// //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const Divider(),
// //               Text(texts[2], style: const TextStyle(fontSize: 18)),
// //               ..._predictions.map(
// //                     (p) => Card(
// //                   child: ListTile(
// //                     title: Text("${p['label']}"),
// //                     subtitle: LinearProgressIndicator(
// //                       value: p['confidence'],
// //                       color: Colors.green,
// //                       backgroundColor: Colors.white,
// //                     ),
// //                     trailing: Text("${(p['confidence'] * 100).toStringAsFixed(1)}%"),
// //                     onTap: () => _confirmPrediction(p['label']),
// //                   ),
// //                 ),
// //               ),
// //               if (_predictions.isEmpty)
// //                 Column(
// //                   children: [
// //                     const SizedBox(height: 20),
// //                     Image.asset(
// //                       "research.png",
// //                       width: 220,
// //                       height: 220,
// //                     ),
// //                   ],
// //                 ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _activityTab() {
// //     return FutureBuilder(
// //       future: Future.wait([
// //         t("Confirmed Breed:"),
// //         t("Correct Breed"),
// //         t("Payload ready for BPA:"),
// //         t("Edit"),
// //         t("Delete"),
// //         t("Upload"),
// //         t("No data found")
// //       ]),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
// //         final texts = snapshot.data as List<String>;
// //
// //         return Container(
// //           color: Colors.grey.shade200,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Text("${texts[0]} ${confirmedBreed ?? "None"}", style: const TextStyle(fontSize: 20)),
// //               const SizedBox(height: 20),
// //               Expanded(
// //                 child: activityLog.isEmpty
// //                     ? Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Image.asset("notfound.png", width: 200, height: 200),
// //                       Text(texts[6], style: TextStyle(fontSize: 16, color: Colors.grey.shade800)),
// //                     ],
// //                   ),
// //                 )
// //                     : ListView.builder(
// //                   itemCount: activityLog.length,
// //                   itemBuilder: (context, index) {
// //                     final item = activityLog[index];
// //                     return Card(
// //                       color: Colors.blueAccent,
// //                       child: ListTile(
// //                         title: Text("ID: ${item['animal_id']} | Breed: ${item['breed']}",
// //                             style: const TextStyle(color: Colors.white)),
// //                         subtitle: Text("Time: ${item['timestamp']}", style: const TextStyle(color: Colors.white)),
// //                         trailing: PopupMenuButton<String>(
// //                           icon: animatedIcon(CupertinoIcons.slider_horizontal_3),
// //                           onSelected: (value) {
// //                             if (value == "edit") _editCattle(index);
// //                             if (value == "delete") _deleteCattle(index);
// //                             if (value == "upload") _uploadtoserver(index);
// //                             if (value == "view_images") _viewUploadedImages(index);
// //                           },
// //                           itemBuilder: (context) => [
// //                             PopupMenuItem(value: "edit", child: Text(texts[3])),
// //                             PopupMenuItem(value: "delete", child: Text(texts[4])),
// //                             PopupMenuItem(value: "upload", child: Text(texts[5])),
// //                             PopupMenuItem(value: "view_images", child: Text("View Images")),
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final tabs = [_homeTab(), _activityTab()];
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade200,
// //       appBar: AppBar(
// //         backgroundColor: Colors.blueAccent,
// //         elevation: 0,
// //         title: FutureBuilder(
// //           future: t("Pashu Dhan"),
// //           builder: (context, snapshot) => Text(snapshot.data?.toString() ?? "PashuSaarthi",
// //               style: const TextStyle(color: Colors.white)),
// //         ),
// //         actions: [
// //           DropdownButton<String>(
// //             value: dropdownValue,
// //             dropdownColor: Colors.black87,
// //             underline: const SizedBox(),
// //             style: const TextStyle(color: Colors.white),
// //             icon: animatedIcon(Icons.arrow_drop_down),
// //             items: languages.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value,
// //                 style: const TextStyle(color: Colors.white)))).toList(),
// //             onChanged: (val) => setState(() => dropdownValue = val!),
// //           ),
// //           IconButton(
// //             onPressed: () {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => Login()),
// //               );
// //             },
// //             icon: animatedIcon(Icons.logout),
// //           ),
// //         ],
// //       ),
// //       body: tabs[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: (i) => setState(() => _selectedIndex = i),
// //         type: BottomNavigationBarType.fixed,
// //         backgroundColor: Colors.blueAccent,
// //         selectedItemColor: Colors.white,
// //         unselectedItemColor: Colors.white70,
// //         items: [
// //           BottomNavigationBarItem(icon: animatedIcon(CupertinoIcons.house_fill),
// //               label: dropdownValue == "en" ? "Home" : dropdownValue == "hi" ? "होम" : "ਘਰ"),
// //           BottomNavigationBarItem(icon: animatedIcon(CupertinoIcons.square_grid_4x3_fill),
// //               label: dropdownValue == "en" ? "Activity" : dropdownValue == "hi" ? "गतिविधि" : "ਗਤੀਵਿਧੀ"),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // ---------------------------
// // import 'dart:io';
// // import 'package:flutter/foundation.dart' show kIsWeb;
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:translator/translator.dart';
// // import 'package:tflite_flutter/tflite_flutter.dart';
// // import 'package:image/image.dart' as img;
// // import 'package:pashudhan/Authentication/Authentication.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// //
// // class MyIntro extends StatefulWidget {
// //   @override
// //   _MyIntroState createState() => _MyIntroState();
// // }
// //
// // class _MyIntroState extends State<MyIntro> {
// //   int _selectedIndex = 0;
// //
// //   /// ---- Shared state ----
// //   List<XFile> _images = [];
// //   List<Map<String, dynamic>> _predictions = [];
// //   final picker = ImagePicker();
// //
// //   final translator = GoogleTranslator();
// //   String dropdownValue = "en";
// //   final Map<String, String> languages = {
// //     "hi": "Hindi",
// //     "pa": "Punjabi",
// //     "en": "English",
// //   };
// //
// //   final Map<String, Map<String, String>> _translationCache = {};
// //   String? confirmedBreed;
// //
// //   /// ---- Activity ----
// //   List<Map<String, dynamic>> activityLog = [];
// //   List<Map<String, dynamic>> serverLog = [];
// //
// //   /// ---- TFLite ----
// //   late Interpreter _interpreter;
// //   late List<String> _labels;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadModel();
// //     _loadServerData();
// //   }
// //
// //   Future<void> _loadModel() async {
// //     _interpreter = await Interpreter.fromAsset('assets/best_float32.tflite');
// //     _labels = [
// //       "Alambadi","Amritmahal","Ayrshire","Banni","Bargur","Bhadawari","Brown_Swiss","Dangi","Deoni","Gir",
// //       "Guernsey","Hallikar","Hariana","Holstein_Friesian","Jaffrabadi","Jersey","Kangayam","Kankrej","Kasargod",
// //       "Kenkatha","Kherigarh","Khillari","Krishna_Valley","Malnad_gidda","Mehsana","Murrah","Nagori","Nagpuri",
// //       "Nili_Ravi","Nimari","Ongole","Pulikulam","Rathi","Red_Dane","Red_Sindhi","Sahiwal","Surti","Tharparkar",
// //       "Toda","Umblachery","Vechur"
// //     ];
// //   }
// //
// //   /// ---- Supabase load ----
// //   Future<void> _loadServerData() async {
// //     final supabase = Supabase.instance.client;
// //     final user = supabase.auth.currentUser;
// //     if (user == null) return;
// //
// //     final response = await supabase
// //         .from("cattle_data")
// //         .select()
// //         .eq("user_id", user.id)
// //         .order("timestamp", ascending: false);
// //
// //     setState(() {
// //       serverLog = List<Map<String, dynamic>>.from(response);
// //     });
// //   }
// //
// //   /// ---- Preprocess ----
// //   List<List<List<List<double>>>> _preprocess(XFile imageFile) {
// //     final bytes = File(imageFile.path).readAsBytesSync();
// //     img.Image image = img.decodeImage(bytes)!;
// //     image = img.copyResize(image, width: 224, height: 224);
// //
// //     return List.generate(
// //       1,
// //           (i) => List.generate(
// //         224,
// //             (y) => List.generate(
// //           224,
// //               (x) => List.generate(
// //             3,
// //                 (c) {
// //               int pixel = image.getPixel(x, y);
// //               int value = 0;
// //               if (c == 0) value = img.getRed(pixel);
// //               if (c == 1) value = img.getGreen(pixel);
// //               if (c == 2) value = img.getBlue(pixel);
// //               return value / 255.0;
// //             },
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// ---- Prediction ----
// //   Future<List<Map<String, dynamic>>> _predict(XFile imageFile) async {
// //     final input = _preprocess(imageFile);
// //     final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
// //     _interpreter.run(input, output);
// //
// //     List<Map<String, dynamic>> results = [];
// //     for (int i = 0; i < _labels.length; i++) {
// //       results.add({"label": _labels[i], "confidence": output[0][i]});
// //     }
// //
// //     results.sort((a, b) =>
// //         (b["confidence"] as double).compareTo(a["confidence"] as double));
// //     return results.take(3).toList();
// //   }
// //
// //   /// ---- Translation ----
// //   Future<String> t(String text) async {
// //     if (dropdownValue == "en") return text;
// //     if (_translationCache[text] != null &&
// //         _translationCache[text]![dropdownValue] != null) {
// //       return _translationCache[text]![dropdownValue]!;
// //     }
// //     final result = await translator.translate(text, to: dropdownValue);
// //     _translationCache[text] ??= {};
// //     _translationCache[text]![dropdownValue] = result.text;
// //     return result.text;
// //   }
// //
// //   /// ---- Pick Image ----
// //   Future<void> _pickImage(bool fromCamera) async {
// //     if (_images.length >= 2) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("⚠ Maximum 2 images allowed")),
// //       );
// //       return;
// //     }
// //
// //     final picked = await picker.pickImage(
// //         source: fromCamera ? ImageSource.camera : ImageSource.gallery);
// //
// //     if (picked != null) {
// //       setState(() {
// //         _images.add(picked);
// //       });
// //
// //       if (_images.length == 1) {
// //         final preds = await _predict(picked);
// //         setState(() {
// //           _predictions = preds;
// //         });
// //       }
// //     }
// //   }
// //
// //   /// ---- Confirm ----
// //   void _confirmPrediction(String breed) {
// //     if (_images.length < 2) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("⚠ Please upload 2 images")),
// //       );
// //       return;
// //     }
// //
// //     setState(() {
// //       confirmedBreed = breed;
// //       activityLog.add({
// //         "animal_id": "TEMP${activityLog.length + 1}",
// //         "breed": breed,
// //         "images": _images.map((e) => e.path).toList(),
// //         "timestamp": DateTime.now().toIso8601String(),
// //       });
// //       _images = [];
// //       _predictions = [];
// //     });
// //
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text("✅ Confirmed: $breed")),
// //     );
// //   }
// //
// //   /// ---- Edit/Delete ----
// //   void _editCattle(int index) {
// //     final controller =
// //     TextEditingController(text: activityLog[index]["breed"]);
// //
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: const Text("Edit Breed"),
// //         content: TextField(
// //           controller: controller,
// //           decoration: const InputDecoration(hintText: "Enter correct breed"),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               setState(() {
// //                 activityLog[index]["breed"] = controller.text;
// //               });
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(content: Text("Breed updated to: ${controller.text}")),
// //               );
// //             },
// //             child: const Text("Submit"),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _deleteCattle(int index) {
// //     setState(() {
// //       activityLog.removeAt(index);
// //     });
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Cattle Record Deleted")),
// //     );
// //   }
// //
// //   /// ---- Upload ----
// //   Future<void> _uploadtoserver(int index) async {
// //     final supabase = Supabase.instance.client;
// //
// //     try {
// //       final user = supabase.auth.currentUser;
// //       if (user == null) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("⚠ Please login first")),
// //         );
// //         return;
// //       }
// //
// //       final item = activityLog[index];
// //       final cattleId = item['animal_id'];
// //       final breed = item['breed'];
// //       final timestamp = item['timestamp'];
// //       final images = item['images'] as List<String>;
// //
// //       List<String> imageUrls = [];
// //       for (final imgPath in images) {
// //         final fileBytes = await File(imgPath).readAsBytes();
// //         final fileName =
// //             "${DateTime.now().millisecondsSinceEpoch}_${cattleId}.jpg";
// //
// //         final response = await supabase.storage
// //             .from('cattle-images')
// //             .uploadBinary(fileName, fileBytes);
// //
// //         if (response.isEmpty) throw Exception("Image upload failed");
// //
// //         final publicUrl =
// //         supabase.storage.from('cattle-images').getPublicUrl(fileName);
// //         imageUrls.add(publicUrl);
// //       }
// //
// //       await supabase.from('cattle_data').insert({
// //         'user_id': user.id,
// //         'cattle_id': cattleId,
// //         'breed': breed,
// //         'images': imageUrls,
// //         'timestamp': timestamp,
// //       });
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("✅ Data Successfully Uploaded")),
// //       );
// //
// //       _loadServerData();
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("❌ Upload failed: $e")),
// //       );
// //     }
// //   }
// //
// //   /// ---- View Images ----
// //   void _viewUploadedImages(int index, {bool fromServer = false}) {
// //     final images = (fromServer
// //         ? serverLog[index]["images"] as List<dynamic>
// //         : activityLog[index]["images"] as List<String>)
// //         .toList();
// //
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: const Text("Uploaded Images"),
// //         content: SizedBox(
// //           height: 300,
// //           child: ListView.builder(
// //             itemCount: images.length,
// //             itemBuilder: (context, i) {
// //               final imgPath = images[i];
// //
// //               return Column(
// //                 children: [
// //                   fromServer
// //                       ? Image.network(imgPath,
// //                       height: 150, fit: BoxFit.cover)
// //                       : Image.file(File(imgPath),
// //                       height: 150, fit: BoxFit.cover),
// //                   if (!fromServer)
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                       children: [
// //                         TextButton(
// //                           onPressed: () async {
// //                             final picked = await picker.pickImage(
// //                                 source: ImageSource.gallery);
// //                             if (picked != null) {
// //                               setState(() {
// //                                 images[i] = picked.path;
// //                                 activityLog[index]["images"] = images;
// //                               });
// //                             }
// //                           },
// //                           child: const Text("Update"),
// //                         ),
// //                         TextButton(
// //                           onPressed: () {
// //                             setState(() {
// //                               images.removeAt(i);
// //                               activityLog[index]["images"] = images;
// //                             });
// //                           },
// //                           child: const Text("Delete"),
// //                         ),
// //                       ],
// //                     ),
// //                   const Divider(),
// //                 ],
// //               );
// //             },
// //           ),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("Close"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   /// ---- UI Helpers ----
// //   Widget animatedIcon(IconData icon,
// //       {Color color = Colors.white, double size = 24}) {
// //     return AnimatedSwitcher(
// //       duration: const Duration(milliseconds: 300),
// //       transitionBuilder: (child, anim) => RotationTransition(
// //         turns: anim,
// //         child: ScaleTransition(scale: anim, child: child),
// //       ),
// //       child:
// //       Icon(icon, key: ValueKey(icon.codePoint), color: color, size: size),
// //     );
// //   }
// //
// //   Widget _previewImage() {
// //     if (_images.isEmpty) return const SizedBox();
// //     return Column(
// //       children: _images
// //           .map((imgFile) => kIsWeb
// //           ? Image.network(imgFile.path, height: 180, fit: BoxFit.cover)
// //           : Image.file(File(imgFile.path),
// //           height: 180, fit: BoxFit.cover))
// //           .toList(),
// //     );
// //   }
// //
// //   /// ---- Home Tab ----
// //   Widget _homeTab() {
// //     return FutureBuilder(
// //       future: Future.wait([
// //         t("Upload Image"),
// //         t("Capture Image"),
// //         t("Result"),
// //       ]),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData)
// //           return const Center(child: CircularProgressIndicator());
// //
// //         final texts = snapshot.data as List<String>;
// //
// //         return SingleChildScrollView(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             children: [
// //               _previewImage(),
// //               const SizedBox(height: 10),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   ElevatedButton.icon(
// //                     icon: animatedIcon(Icons.photo),
// //                     label: Text(texts[0],
// //                         style: const TextStyle(color: Colors.white)),
// //                     onPressed: () => _pickImage(false),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.blueAccent,
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 20, vertical: 16),
// //                       shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(20)),
// //                     ),
// //                   ),
// //                   ElevatedButton.icon(
// //                     icon: animatedIcon(Icons.camera_alt),
// //                     label: Text(texts[1],
// //                         style: const TextStyle(color: Colors.white)),
// //                     onPressed: () => _pickImage(true),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.blueAccent,
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 20, vertical: 16),
// //                       shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(20)),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const Divider(),
// //               Text(texts[2], style: const TextStyle(fontSize: 18)),
// //               ..._predictions.map(
// //                     (p) => Card(
// //                   child: ListTile(
// //                     title: Text("${p['label']}"),
// //                     subtitle: LinearProgressIndicator(
// //                       value: p['confidence'],
// //                       color: Colors.green,
// //                       backgroundColor: Colors.white,
// //                     ),
// //                     trailing: Text(
// //                         "${(p['confidence'] * 100).toStringAsFixed(1)}%"),
// //                     onTap: () => _confirmPrediction(p['label']),
// //                   ),
// //                 ),
// //               ),
// //               if (_predictions.isEmpty)
// //                 Column(
// //                   children: [
// //                     const SizedBox(height: 20),
// //                     Image.asset("research.png", width: 220, height: 220),
// //                   ],
// //                 ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   /// ---- Activity Tab ----
// //   Widget _activityTab() {
// //     return FutureBuilder(
// //       future: Future.wait([t("Edit"), t("Delete"), t("Upload")]),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData)
// //           return const Center(child: CircularProgressIndicator());
// //         final texts = snapshot.data as List<String>;
// //
// //         return Container(
// //           color: Colors.grey.shade200,
// //           child: Column(
// //             children: [
// //               const SizedBox(height: 10),
// //               Expanded(
// //                 child: ListView(
// //                   children: [
// //                     /// Local records
// //                     if (activityLog.isNotEmpty) ...[
// //                       const Padding(
// //                         padding: EdgeInsets.all(8),
// //                         child: Text("Local Records",
// //                             style: TextStyle(
// //                                 fontWeight: FontWeight.bold, fontSize: 16)),
// //                       ),
// //                       ...List.generate(activityLog.length, (index) {
// //                         final item = activityLog[index];
// //                         return Card(
// //                           color: Colors.blueAccent,
// //                           child: ListTile(
// //                             title: Text(
// //                                 "ID: ${item['animal_id']} | Breed: ${item['breed']}",
// //                                 style: const TextStyle(color: Colors.white)),
// //                             subtitle: Text("Time: ${item['timestamp']}",
// //                                 style:
// //                                 const TextStyle(color: Colors.white)),
// //                             trailing: PopupMenuButton<String>(
// //                               icon: animatedIcon(
// //                                   CupertinoIcons.slider_horizontal_3),
// //                               onSelected: (value) {
// //                                 if (value == "edit") _editCattle(index);
// //                                 if (value == "delete") _deleteCattle(index);
// //                                 if (value == "upload")
// //                                   _uploadtoserver(index);
// //                                 if (value == "view_images")
// //                                   _viewUploadedImages(index,
// //                                       fromServer: false);
// //                               },
// //                               itemBuilder: (context) => [
// //                                 PopupMenuItem(
// //                                     value: "edit", child: Text(texts[0])),
// //                                 PopupMenuItem(
// //                                     value: "delete", child: Text(texts[1])),
// //                                 PopupMenuItem(
// //                                     value: "upload", child: Text(texts[2])),
// //                                 const PopupMenuItem(
// //                                     value: "view_images",
// //                                     child: Text("View Images")),
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       }),
// //                     ],
// //
// //                     /// Server records
// //                     if (serverLog.isNotEmpty) ...[
// //                       const Padding(
// //                         padding: EdgeInsets.all(8),
// //                         child: Text("Synced Records",
// //                             style: TextStyle(
// //                                 fontWeight: FontWeight.bold, fontSize: 16)),
// //                       ),
// //                       ...List.generate(serverLog.length, (index) {
// //                         final item = serverLog[index];
// //                         return Card(
// //                           color: Colors.green,
// //                           child: ListTile(
// //                             title: Text(
// //                                 "ID: ${item['cattle_id']} | Breed: ${item['breed']}",
// //                                 style: const TextStyle(color: Colors.white)),
// //                             subtitle: Text("Time: ${item['timestamp']}",
// //                                 style:
// //                                 const TextStyle(color: Colors.white)),
// //                             trailing: PopupMenuButton<String>(
// //                               icon: animatedIcon(
// //                                   CupertinoIcons.slider_horizontal_3),
// //                               onSelected: (value) {
// //                                 if (value == "view_images")
// //                                   _viewUploadedImages(index,
// //                                       fromServer: true);
// //                               },
// //                               itemBuilder: (context) => [
// //                                 const PopupMenuItem(
// //                                     value: "view_images",
// //                                     child: Text("View Images")),
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       }),
// //                     ],
// //
// //                     if (activityLog.isEmpty && serverLog.isEmpty)
// //                       Center(
// //                         child: Column(
// //                           children: [
// //                             Image.asset("notfound.png",
// //                                 width: 200, height: 200),
// //                             const Text("No data found"),
// //                           ],
// //                         ),
// //                       )
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final tabs = [_homeTab(), _activityTab()];
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade200,
// //       appBar: AppBar(
// //         backgroundColor: Colors.blueAccent,
// //         elevation: 0,
// //         title: FutureBuilder(
// //           future: t("Pashu Dhan"),
// //           builder: (context, snapshot) => Text(
// //               snapshot.data?.toString() ?? "PashuSaarthi",
// //               style: const TextStyle(color: Colors.white)),
// //         ),
// //         actions: [
// //           DropdownButton<String>(
// //             value: dropdownValue,
// //             dropdownColor: Colors.black87,
// //             underline: const SizedBox(),
// //             style: const TextStyle(color: Colors.white),
// //             icon: animatedIcon(Icons.arrow_drop_down),
// //             items: languages.entries
// //                 .map((e) => DropdownMenuItem(
// //                 value: e.key,
// //                 child: Text(e.value,
// //                     style: const TextStyle(color: Colors.white))))
// //                 .toList(),
// //             onChanged: (val) => setState(() => dropdownValue = val!),
// //           ),
// //           IconButton(
// //             onPressed: () {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => Login()),
// //               );
// //             },
// //             icon: animatedIcon(Icons.logout),
// //           ),
// //         ],
// //       ),
// //       body: tabs[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: (i) => setState(() => _selectedIndex = i),
// //         type: BottomNavigationBarType.fixed,
// //         backgroundColor: Colors.blueAccent,
// //         selectedItemColor: Colors.white,
// //         unselectedItemColor: Colors.white70,
// //         items: [
// //           BottomNavigationBarItem(
// //               icon: animatedIcon(CupertinoIcons.house_fill),
// //               label: dropdownValue == "en"
// //                   ? "Home"
// //                   : dropdownValue == "hi"
// //                   ? "होम"
// //                   : "ਘਰ"),
// //           BottomNavigationBarItem(
// //               icon: animatedIcon(CupertinoIcons.square_grid_4x3_fill),
// //               label: dropdownValue == "en"
// //                   ? "Activity"
// //                   : dropdownValue == "hi"
// //                   ? "गतिविधि"
// //                   : "ਗਤੀਵਿਧੀ"),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // ----------
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:translator/translator.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;
// import 'package:pashudhan/Authentication/Authentication.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class MyIntro extends StatefulWidget {
//   @override
//   _MyIntroState createState() => _MyIntroState();
// }
//
// class _MyIntroState extends State<MyIntro> {
//   int _selectedIndex = 0;
//
//   /// ---- Shared state ----
//   List<XFile> _images = [];
//   List<Map<String, dynamic>> _predictions = [];
//   final picker = ImagePicker();
//
//   final translator = GoogleTranslator();
//   String dropdownValue = "en";
//   final Map<String, String> languages = {
//     "hi": "Hindi",
//     "pa": "Punjabi",
//     "en": "English",
//   };
//
//   final Map<String, Map<String, String>> _translationCache = {};
//   String? confirmedBreed;
//
//   /// ---- Activity ----
//   List<Map<String, dynamic>> activityLog = [];
//   List<Map<String, dynamic>> serverLog = [];
//
//   /// ---- TFLite ----
//   late Interpreter _interpreter;
//   late List<String> _labels;
//
//   /// ---- Supabase User ----
//   User? currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadModel();
//     _loadCurrentUser();
//     _loadServerData();
//   }
//
//   Future<void> _loadCurrentUser() async {
//     final supabase = Supabase.instance.client;
//     await supabase.auth.refreshSession();
//     setState(() {
//       currentUser = supabase.auth.currentUser;
//     });
//   }
//
//   Future<void> _loadModel() async {
//     _interpreter = await Interpreter.fromAsset('assets/best_float32.tflite');
//     _labels = [
//       "Alambadi","Amritmahal","Ayrshire","Banni","Bargur","Bhadawari","Brown_Swiss","Dangi","Deoni","Gir",
//       "Guernsey","Hallikar","Hariana","Holstein_Friesian","Jaffrabadi","Jersey","Kangayam","Kankrej","Kasargod",
//       "Kenkatha","Kherigarh","Khillari","Krishna_Valley","Malnad_gidda","Mehsana","Murrah","Nagori","Nagpuri",
//       "Nili_Ravi","Nimari","Ongole","Pulikulam","Rathi","Red_Dane","Red_Sindhi","Sahiwal","Surti","Tharparkar",
//       "Toda","Umblachery","Vechur"
//     ];
//   }
//
//   /// ---- Supabase load ----
//   Future<void> _loadServerData() async {
//     final supabase = Supabase.instance.client;
//     final user = supabase.auth.currentUser;
//     if (user == null) return;
//
//     final response = await supabase
//         .from("cattle_data")
//         .select()
//         .eq("user_id", user.id)
//         .order("timestamp", ascending: false);
//
//     setState(() {
//       serverLog = List<Map<String, dynamic>>.from(response);
//     });
//   }
//
//   /// ---- Preprocess ----
//   List<List<List<List<double>>>> _preprocess(XFile imageFile) {
//     final bytes = File(imageFile.path).readAsBytesSync();
//     img.Image image = img.decodeImage(bytes)!;
//     image = img.copyResize(image, width: 224, height: 224);
//
//     return List.generate(
//       1,
//           (i) => List.generate(
//         224,
//             (y) => List.generate(
//           224,
//               (x) => List.generate(
//             3,
//                 (c) {
//               int pixel = image.getPixel(x, y);
//               int value = 0;
//               if (c == 0) value = img.getRed(pixel);
//               if (c == 1) value = img.getGreen(pixel);
//               if (c == 2) value = img.getBlue(pixel);
//               return value / 255.0;
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// ---- Prediction ----
//   Future<List<Map<String, dynamic>>> _predict(XFile imageFile) async {
//     final input = _preprocess(imageFile);
//     final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
//     _interpreter.run(input, output);
//
//     List<Map<String, dynamic>> results = [];
//     for (int i = 0; i < _labels.length; i++) {
//       results.add({"label": _labels[i], "confidence": output[0][i]});
//     }
//
//     results.sort((a, b) =>
//         (b["confidence"] as double).compareTo(a["confidence"] as double));
//     return results.take(3).toList();
//   }
//
//   /// ---- Translation ----
//   Future<String> t(String text) async {
//     if (dropdownValue == "en") return text;
//     if (_translationCache[text] != null &&
//         _translationCache[text]![dropdownValue] != null) {
//       return _translationCache[text]![dropdownValue]!;
//     }
//     final result = await translator.translate(text, to: dropdownValue);
//     _translationCache[text] ??= {};
//     _translationCache[text]![dropdownValue] = result.text;
//     return result.text;
//   }
//
//   /// ---- Pick Image ----
//   Future<void> _pickImage(bool fromCamera) async {
//     if (_images.length >= 2) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠ Maximum 2 images allowed")),
//       );
//       return;
//     }
//
//     final picked = await picker.pickImage(
//         source: fromCamera ? ImageSource.camera : ImageSource.gallery);
//
//     if (picked != null) {
//       setState(() {
//         _images.add(picked);
//       });
//
//       if (_images.length == 1) {
//         final preds = await _predict(picked);
//         setState(() {
//           _predictions = preds;
//         });
//       }
//     }
//   }
//
//   /// ---- Confirm ----
//   void _confirmPrediction(String breed) {
//     if (_images.length < 2) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠ Please upload 2 images")),
//       );
//       return;
//     }
//
//     setState(() {
//       confirmedBreed = breed;
//       activityLog.add({
//         "animal_id": "TEMP${activityLog.length + 1}",
//         "breed": breed,
//         "images": _images.map((e) => e.path).toList(),
//         "timestamp": DateTime.now().toIso8601String(),
//       });
//       _images = [];
//       _predictions = [];
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("✅ Confirmed: $breed")),
//     );
//   }
//
//   /// ---- Edit/Delete ----
//   void _editCattle(int index) {
//     final controller =
//     TextEditingController(text: activityLog[index]["breed"]);
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Edit Breed"),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(hintText: "Enter correct breed"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               setState(() {
//                 activityLog[index]["breed"] = controller.text;
//               });
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Breed updated to: ${controller.text}")),
//               );
//             },
//             child: const Text("Submit"),
//           )
//         ],
//       ),
//     );
//   }
//
//   void _deleteCattle(int index) {
//     setState(() {
//       activityLog.removeAt(index);
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Cattle Record Deleted")),
//     );
//   }
//
//   /// ---- Upload ----
//   Future<void> _uploadtoserver(int index) async {
//     final supabase = Supabase.instance.client;
//
//     try {
//       final user = supabase.auth.currentUser;
//       if (user == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("⚠ Please login first")),
//         );
//         return;
//       }
//
//       final item = activityLog[index];
//       final cattleId = item['animal_id'];
//       final breed = item['breed'];
//       final timestamp = item['timestamp'];
//       final images = item['images'] as List<String>;
//
//       List<String> imageUrls = [];
//       for (final imgPath in images) {
//         final fileBytes = await File(imgPath).readAsBytes();
//         final fileName =
//             "${DateTime.now().millisecondsSinceEpoch}_${cattleId}.jpg";
//
//         final response = await supabase.storage
//             .from('cattle-images')
//             .uploadBinary(fileName, fileBytes);
//
//         if (response.isEmpty) throw Exception("Image upload failed");
//
//         final publicUrl =
//         supabase.storage.from('cattle-images').getPublicUrl(fileName);
//         imageUrls.add(publicUrl);
//       }
//
//       await supabase.from('cattle_data').insert({
//         'user_id': user.id,
//         'cattle_id': cattleId,
//         'breed': breed,
//         'images': imageUrls,
//         'timestamp': timestamp,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("✅ Data Successfully Uploaded")),
//       );
//
//       _loadServerData();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Upload failed: $e")),
//       );
//     }
//   }
//
//   /// ---- View Images ----
//   void _viewUploadedImages(int index, {bool fromServer = false}) {
//     final images = (fromServer
//         ? serverLog[index]["images"] as List<dynamic>
//         : activityLog[index]["images"] as List<String>)
//         .toList();
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Uploaded Images"),
//         content: SizedBox(
//           height: 300,
//           child: ListView.builder(
//             itemCount: images.length,
//             itemBuilder: (context, i) {
//               final imgPath = images[i];
//
//               return Column(
//                 children: [
//                   fromServer
//                       ? Image.network(imgPath,
//                       height: 150, fit: BoxFit.cover)
//                       : Image.file(File(imgPath),
//                       height: 150, fit: BoxFit.cover),
//                   if (!fromServer)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         TextButton(
//                           onPressed: () async {
//                             final picked = await picker.pickImage(
//                                 source: ImageSource.gallery);
//                             if (picked != null) {
//                               setState(() {
//                                 images[i] = picked.path;
//                                 activityLog[index]["images"] = images;
//                               });
//                             }
//                           },
//                           child: const Text("Update"),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             setState(() {
//                               images.removeAt(i);
//                               activityLog[index]["images"] = images;
//                             });
//                           },
//                           child: const Text("Delete"),
//                         ),
//                       ],
//                     ),
//                   const Divider(),
//                 ],
//               );
//             },
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Close"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// ---- UI Helpers ----
//   Widget animatedIcon(IconData icon,
//       {Color color = Colors.white, double size = 24}) {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 300),
//       transitionBuilder: (child, anim) => RotationTransition(
//         turns: anim,
//         child: ScaleTransition(scale: anim, child: child),
//       ),
//       child:
//       Icon(icon, key: ValueKey(icon.codePoint), color: color, size: size),
//     );
//   }
//
//   Widget _previewImage() {
//     if (_images.isEmpty) return const SizedBox();
//     return Column(
//       children: _images
//           .map((imgFile) => kIsWeb
//           ? Image.network(imgFile.path, height: 180, fit: BoxFit.cover)
//           : Image.file(File(imgFile.path),
//           height: 180, fit: BoxFit.cover))
//           .toList(),
//     );
//   }
//
//   /// ---- Home Tab ----
//   Widget _homeTab() {
//     return FutureBuilder(
//       future: Future.wait([
//         t("Upload Image"),
//         t("Capture Image"),
//         t("Result"),
//       ]),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData)
//           return const Center(child: CircularProgressIndicator());
//
//         final texts = snapshot.data as List<String>;
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               _previewImage(),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     icon: animatedIcon(Icons.photo),
//                     label: Text(texts[0],
//                         style: const TextStyle(color: Colors.white)),
//                     onPressed: () => _pickImage(false),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 16),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     icon: animatedIcon(Icons.camera_alt),
//                     label: Text(texts[1],
//                         style: const TextStyle(color: Colors.white)),
//                     onPressed: () => _pickImage(true),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 16),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(),
//               Text(texts[2], style: const TextStyle(fontSize: 18)),
//               ..._predictions.map(
//                     (p) => Card(
//                   child: ListTile(
//                     title: Text("${p['label']}"),
//                     subtitle: LinearProgressIndicator(
//                       value: p['confidence'],
//                       color: Colors.green,
//                       backgroundColor: Colors.white,
//                     ),
//                     trailing: Text(
//                         "${(p['confidence'] * 100).toStringAsFixed(1)}%"),
//                     onTap: () => _confirmPrediction(p['label']),
//                   ),
//                 ),
//               ),
//               if (_predictions.isEmpty)
//                 Column(
//                   children: [
//                     const SizedBox(height: 20),
//                     Image.asset("research.png", width: 220, height: 220),
//                   ],
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   /// ---- Activity Tab ----
//   Widget _activityTab() {
//     return FutureBuilder(
//       future: Future.wait([t("Edit"), t("Delete"), t("Upload")]),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData)
//           return const Center(child: CircularProgressIndicator());
//         final texts = snapshot.data as List<String>;
//
//         return Container(
//           color: Colors.grey.shade200,
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//
//               // User info
//               if (currentUser != null)
//                 Card(
//                   color: Colors.blueAccent,
//                   margin: const EdgeInsets.symmetric(horizontal: 8),
//                   child: ListTile(
//                     title: Text("User: ${currentUser!.email}",
//                         style: const TextStyle(color: Colors.white)),
//                     subtitle: Text("ID: ${currentUser!.id}",
//                         style: const TextStyle(color: Colors.white)),
//                   ),
//                 ),
//
//               Expanded(
//                 child: ListView(
//                   children: [
//                     /// Local records
//                     if (activityLog.isNotEmpty) ...[
//                       const Padding(
//                         padding: EdgeInsets.all(8),
//                         child: Text("Local Records",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16)),
//                       ),
//                       ...List.generate(activityLog.length, (index) {
//                         final item = activityLog[index];
//                         return Card(
//                           color: Colors.blueAccent,
//                           child: ListTile(
//                             title: Text(
//                                 "ID: ${item['animal_id']} | Breed: ${item['breed']}",
//                                 style: const TextStyle(color: Colors.white)),
//                             subtitle: Text("Time: ${item['timestamp']}",
//                                 style:
//                                 const TextStyle(color: Colors.white)),
//                             trailing: PopupMenuButton<String>(
//                               icon: animatedIcon(
//                                   CupertinoIcons.slider_horizontal_3),
//                               onSelected: (value) {
//                                 if (value == "edit") _editCattle(index);
//                                 if (value == "delete") _deleteCattle(index);
//                                 if (value == "upload")
//                                   _uploadtoserver(index);
//                                 if (value == "view_images")
//                                   _viewUploadedImages(index,
//                                       fromServer: false);
//                               },
//                               itemBuilder: (context) => [
//                                 PopupMenuItem(
//                                     value: "edit", child: Text(texts[0])),
//                                 PopupMenuItem(
//                                     value: "delete", child: Text(texts[1])),
//                                 PopupMenuItem(
//                                     value: "upload", child: Text(texts[2])),
//                                 const PopupMenuItem(
//                                     value: "view_images",
//                                     child: Text("View Images")),
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//
//                     /// Server records
//                     if (serverLog.isNotEmpty) ...[
//                       const Padding(
//                         padding: EdgeInsets.all(8),
//                         child: Text("Synced Records",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16)),
//                       ),
//                       ...List.generate(serverLog.length, (index) {
//                         final item = serverLog[index];
//                         return Card(
//                           color: Colors.green,
//                           child: ListTile(
//                             title: Text(
//                                 "ID: ${item['cattle_id']} | Breed: ${item['breed']}",
//                                 style: const TextStyle(color: Colors.white)),
//                             subtitle: Text("Time: ${item['timestamp']}",
//                                 style:
//                                 const TextStyle(color: Colors.white)),
//                             trailing: PopupMenuButton<String>(
//                               icon: animatedIcon(
//                                   CupertinoIcons.slider_horizontal_3),
//                               onSelected: (value) {
//                                 if (value == "view_images")
//                                   _viewUploadedImages(index,
//                                       fromServer: true);
//                               },
//                               itemBuilder: (context) => [
//                                 const PopupMenuItem(
//                                     value: "view_images",
//                                     child: Text("View Images")),
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//
//                     if (activityLog.isEmpty && serverLog.isEmpty)
//                       Center(
//                         child: Column(
//                           children: [
//                             Image.asset("notfound.png",
//                                 width: 200, height: 200),
//                             const Text("No data found"),
//                           ],
//                         ),
//                       )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final tabs = [_homeTab(), _activityTab()];
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//         title: FutureBuilder(
//           future: t("Pashu Dhan"),
//           builder: (context, snapshot) => Text(
//               snapshot.data?.toString() ?? "Pashu Dhan",
//               style: const TextStyle(color: Colors.white)),
//         ),
//         actions: [
//           DropdownButton<String>(
//             value: dropdownValue,
//             dropdownColor: Colors.black87,
//             underline: const SizedBox(),
//             style: const TextStyle(color: Colors.white),
//             icon: animatedIcon(Icons.arrow_drop_down),
//             items: languages.entries
//                 .map((e) => DropdownMenuItem(
//                 value: e.key,
//                 child: Text(e.value,
//                     style: const TextStyle(color: Colors.white))))
//                 .toList(),
//             onChanged: (val) => setState(() => dropdownValue = val!),
//           ),
//           IconButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => Login()),
//               );
//             },
//             icon: animatedIcon(Icons.logout),
//           ),
//         ],
//       ),
//       body: tabs[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (i) => setState(() => _selectedIndex = i),
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.blueAccent,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white70,
//         items: [
//           BottomNavigationBarItem(
//               icon: animatedIcon(CupertinoIcons.house_fill),
//               label: dropdownValue == "en"
//                   ? "Home"
//                   : dropdownValue == "hi"
//                   ? "होम"
//                   : "ਘਰ"),
//           BottomNavigationBarItem(
//               icon: animatedIcon(CupertinoIcons.square_grid_4x3_fill),
//               label: dropdownValue == "en"
//                   ? "Activity"
//                   : dropdownValue == "hi"
//                   ? "गतिविधि"
//                   : "ਗਤੀਵਿਧੀ"),
//         ],
//       ),
//     );
//   }
// }
// ------------------
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:pashudhan/Authentication/Authentication.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyIntro extends StatefulWidget {
  final String userEmail;
  final String userName;

  const MyIntro({super.key, required this.userEmail, required this.userName});

  @override
  _MyIntroState createState() => _MyIntroState();
}


class _MyIntroState extends State<MyIntro> {
  int _selectedIndex = 0;

  /// ---- Shared state ----
  List<XFile> _images = [];
  List<Map<String, dynamic>> _predictions = [];
  final picker = ImagePicker();

  final translator = GoogleTranslator();
  String dropdownValue = "en";
  final Map<String, String> languages = {
    "hi": "Hindi",
    "pa": "Punjabi",
    "en": "English",
  };

  final Map<String, Map<String, String>> _translationCache = {};
  String? confirmedBreed;

  /// ---- Activity ----
  List<Map<String, dynamic>> activityLog = [];
  List<Map<String, dynamic>> serverLog = [];

  late Interpreter _interpreter;
  late List<String> _labels;

  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadCurrentUser();
    _loadServerData();
  }

  Future<void> _loadCurrentUser() async {
    final supabase = Supabase.instance.client;
    await supabase.auth.refreshSession();
    setState(() {
      currentUser = supabase.auth.currentUser;
    });
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/best_float32.tflite');
    _labels = [
      "Alambadi","Amritmahal","Ayrshire","Banni","Bargur","Bhadawari","Brown_Swiss","Dangi","Deoni","Gir",
      "Guernsey","Hallikar","Hariana","Holstein_Friesian","Jaffrabadi","Jersey","Kangayam","Kankrej","Kasargod",
      "Kenkatha","Kherigarh","Khillari","Krishna_Valley","Malnad_gidda","Mehsana","Murrah","Nagori","Nagpuri",
      "Nili_Ravi","Nimari","Ongole","Pulikulam","Rathi","Red_Dane","Red_Sindhi","Sahiwal","Surti","Tharparkar",
      "Toda","Umblachery","Vechur"
    ];
  }

  /// ---- Supabase load ----
  Future<void> _loadServerData() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from("cattle_data")
        .select()
        .eq("email", user.email as Object)
        .order("timestamp", ascending: false);

    setState(() {
      serverLog = List<Map<String, dynamic>>.from(response);
    });
  }

  /// ---- Preprocess ----
  List<List<List<List<double>>>> _preprocess(XFile imageFile) {
    final bytes = File(imageFile.path).readAsBytesSync();
    img.Image image = img.decodeImage(bytes)!;
    image = img.copyResize(image, width: 224, height: 224);

    return List.generate(
      1,
          (i) => List.generate(
        224,
            (y) => List.generate(
          224,
              (x) => List.generate(
            3,
                (c) {
              int pixel = image.getPixel(x, y);
              int value = 0;
              if (c == 0) value = img.getRed(pixel);
              if (c == 1) value = img.getGreen(pixel);
              if (c == 2) value = img.getBlue(pixel);
              return value / 255.0;
            },
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _predict(XFile imageFile) async {
    final input = _preprocess(imageFile);
    final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
    _interpreter.run(input, output);

    List<Map<String, dynamic>> results = [];
    for (int i = 0; i < _labels.length; i++) {
      results.add({"label": _labels[i], "confidence": output[0][i]});
    }

    results.sort((a, b) =>
        (b["confidence"] as double).compareTo(a["confidence"] as double));
    return results.take(3).toList();
  }

  Future<String> t(String text) async {
    if (dropdownValue == "en") return text;
    if (_translationCache[text] != null &&
        _translationCache[text]![dropdownValue] != null) {
      return _translationCache[text]![dropdownValue]!;
    }
    final result = await translator.translate(text, to: dropdownValue);
    _translationCache[text] ??= {};
    _translationCache[text]![dropdownValue] = result.text;
    return result.text;
  }

  Future<void> _pickImage(bool fromCamera) async {
    if (_images.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maximum 2 images allowed")),
      );
      return;
    }

    final picked = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _images.add(picked);
      });

      if (_images.length == 1) {
        final preds = await _predict(picked);
        setState(() {
          _predictions = preds;
        });
      }
    }
  }

  void _confirmPrediction(String breed) {
    if (_images.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ Please upload 2 images")),
      );
      return;
    }

    setState(() {
      confirmedBreed = breed;
      activityLog.add({
        "animal_id": "TEMP${activityLog.length + 1}",
        "breed": breed,
        "images": _images.map((e) => e.path).toList(),
        "timestamp": DateTime.now().toIso8601String(),
      });
      _images = [];
      _predictions = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Confirmed: $breed")),
    );
  }

  void _editCattle(int index) {
    final controller = TextEditingController(text: activityLog[index]["breed"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Breed"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter correct breed"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                activityLog[index]["breed"] = controller.text;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Breed updated to: ${controller.text}")),
              );
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }

  void _deleteCattle(int index) {
    setState(() {
      activityLog.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cattle Record Deleted")),
    );
  }

  Future<void> _uploadtoserver(int index) async {
    final supabase = Supabase.instance.client;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠ Please login first")),
        );
        return;
      }

      final item = activityLog[index];
      final cattleId = item['animal_id'];
      final breed = item['breed'];
      final timestamp = item['timestamp'];
      final images = item['images'] as List<String>;

      List<String> imageUrls = [];
      for (final imgPath in images) {
        final fileBytes = await File(imgPath).readAsBytes();
        final fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${cattleId}.jpg";

        final response = await supabase.storage
            .from('cattle-images')
            .uploadBinary(fileName, fileBytes);

        if (response.isEmpty) throw Exception("Image upload failed");

        final publicUrl =
        supabase.storage.from('cattle-images').getPublicUrl(fileName);
        imageUrls.add(publicUrl);
      }

      await supabase.from('cattle_data').insert({
        'email': user.email,
        'cattle_id': cattleId,
        'breed': breed,
        'images': imageUrls,
        'timestamp': timestamp,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data Successfully Uploaded")),
      );

      _loadServerData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed:$e")),
      );
    }
  }

  /// ---- View Images ----
  void _viewUploadedImages(int index, {bool fromServer = false}) {
    final images = (fromServer
        ? serverLog[index]["images"] as List<dynamic>
        : activityLog[index]["images"] as List<String>)
        .toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Uploaded Images"),
        content: SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, i) {
              final imgPath = images[i];

              return Column(
                children: [
                  fromServer
                      ? Image.network(imgPath,
                      height: 150, fit: BoxFit.cover)
                      : Image.file(File(imgPath),
                      height: 150, fit: BoxFit.cover),
                  if (!fromServer)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final picked = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (picked != null) {
                              setState(() {
                                images[i] = picked.path;
                                activityLog[index]["images"] = images;
                              });
                            }
                          },
                          child: const Text("Update"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              images.removeAt(i);
                              activityLog[index]["images"] = images;
                            });
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  const Divider(),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget animatedIcon(IconData icon,
      {Color color = Colors.white, double size = 24}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => RotationTransition(
        turns: anim,
        child: ScaleTransition(scale: anim, child: child),
      ),
      child:
      Icon(icon, key: ValueKey(icon.codePoint), color: color, size: size),
    );
  }

  Widget _previewImage() {
    if (_images.isEmpty) return const SizedBox();
    return Column(
      children: _images
          .map((imgFile) => kIsWeb
          ? Image.network(imgFile.path, height: 180, fit: BoxFit.cover)
          : Image.file(File(imgFile.path),
          height: 180, fit: BoxFit.cover))
          .toList(),
    );
  }

  Widget _homeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          _previewImage(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: animatedIcon(Icons.photo),
                label: const Text("Upload Image",
                    style: TextStyle(color: Colors.white)),
                onPressed: () => _pickImage(false),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: 3.0,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              ElevatedButton.icon(
                icon: animatedIcon(Icons.camera_alt),
                label: const Text("Capture Image",
                    style: TextStyle(color: Colors.white)),
                onPressed: () => _pickImage(true),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: 3.0,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
          const Divider(),
          FutureBuilder(
            future: t("Result"),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? "Result",
                style: const TextStyle(fontSize: 18),
              );
            },
          ),
          ..._predictions.map(
                (p) => Card(
              child: ListTile(
                title: Text("${p['label']}"),
                subtitle: LinearProgressIndicator(
                  value: p['confidence'],
                  color: Colors.green,
                  backgroundColor: Colors.white,
                ),
                trailing: Text(
                    "${(p['confidence'] * 100).toStringAsFixed(1)}%"),
                onTap: () => _confirmPrediction(p['label']),
              ),
            ),
          ),
          if (_predictions.isEmpty)
            Column(
              children: [
                const SizedBox(height: 20),
                Image.asset("assets/images/research.png", width: double.infinity, height: 220),
              ],
            ),
        ],
      ),
    );
  }

  Widget _activityTab() {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          const SizedBox(height: 10),
          if (currentUser != null)
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black, // border color
                  width: 3,           // border thickness
                ),
              ),
              color: Colors.blueAccent,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                title: Text("User: ${currentUser!.email}",
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text("ID: ${currentUser!.id}",
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          Expanded(
            child: ListView(
              children: [
                SizedBox(height:10),
                if (activityLog.isNotEmpty)
                  ...List.generate(activityLog.length, (index) {
                    final item = activityLog[index];
                    return Card(
                      color: Colors.blueAccent,
                      child: ListTile(
                        title: Text(
                            "ID: ${item['animal_id']} | Breed: ${item['breed']}",
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text("Time: ${item['timestamp']}",
                            style: const TextStyle(color: Colors.white)),
                        trailing: PopupMenuButton<String>(
                          icon: animatedIcon(
                              CupertinoIcons.slider_horizontal_3),
                          onSelected: (value) {
                            if (value == "edit") _editCattle(index);
                            if (value == "delete") _deleteCattle(index);
                            if (value == "upload") _uploadtoserver(index);
                            if (value == "view_images")
                              _viewUploadedImages(index, fromServer: false);
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: "edit", child: Text("Edit")),
                            PopupMenuItem(value: "delete", child: Text("Delete")),
                            PopupMenuItem(value: "upload", child: Text("Upload")),
                            PopupMenuItem(value: "view_images", child: Text("View Images")),
                          ],
                        ),
                      ),
                    );
                  }),
                if (serverLog.isNotEmpty)
                  ...List.generate(serverLog.length, (index) {
                    final item = serverLog[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black, // border color
                          width: 3,           // border thickness
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.green,
                      child: ListTile(
                        title: Text(
                            "ID: ${item['cattle_id']} | Breed: ${item['breed']}",
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text("Time: ${item['timestamp']}",
                            style: const TextStyle(color: Colors.white)),
                        trailing: PopupMenuButton<String>(
                          icon: animatedIcon(
                              CupertinoIcons.slider_horizontal_3),
                          onSelected: (value) {
                            if (value == "view_images")
                              _viewUploadedImages(index, fromServer: true);
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                                value: "view_images",
                                child: Text("View Images")),
                          ],
                        ),
                      ),
                    );
                  }),
                if (activityLog.isEmpty && serverLog.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height:120),
                        Image.asset("assets/images/notfound.png", width: double.infinity, height: 200),
                        const Text("No data found"),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [_homeTab(), _activityTab()];
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // height of the line
          child: Container(
            color: Colors.black, // line color
            height: 4.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: FutureBuilder(
          future: t("Pashu Dhan"),
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? "Pashu Dhan",
              style: const TextStyle(color: Colors.white),
            );
          },
        ),
        actions: [
          DropdownButton<String>(
            value: dropdownValue,
            dropdownColor: Colors.black87,
            underline: const SizedBox(),
            style: const TextStyle(color: Colors.white),
            icon: animatedIcon(Icons.arrow_drop_down),
            items: languages.entries
                .map((e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.value,
                    style: const TextStyle(color: Colors.white))))
                .toList(),
            onChanged: (val) => setState(() => dropdownValue = val!),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            icon: animatedIcon(Icons.logout),
          ),
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black, // line color
              width: 4.0,         // line thickness
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blueAccent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: [
            BottomNavigationBarItem(
                icon: animatedIcon(CupertinoIcons.house_fill),
                label: dropdownValue == "en" ? "Home" : dropdownValue == "hi" ? "होम" : "ਘਰ"),
            BottomNavigationBarItem(
                icon: animatedIcon(CupertinoIcons.square_grid_4x3_fill),
                label: dropdownValue == "en" ? "Activity" : dropdownValue == "hi" ? "गतिविधि" : "ਗਤੀਵਿਧੀ"),
          ],
        ),
      ),
    );
  }
}
