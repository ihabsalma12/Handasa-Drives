import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RouteRidersPage extends StatefulWidget {
  const RouteRidersPage({super.key});

  @override
  State<RouteRidersPage> createState() => _RouteRidersPageState();
}

class _RouteRidersPageState extends State<RouteRidersPage> {

  // Stream getDoc(){
  //
  // }
  final CollectionReference routeCollection = FirebaseFirestore.instance.collection("routes");
  Map received_data = {};

  @override
  Widget build(BuildContext context) {

    received_data = ModalRoute.of(context)!.settings.arguments as Map;
    final doc_id = received_data['id'];


    return Scaffold(
      appBar: AppBar(title: const Text("Route bookings", style: TextStyle(fontWeight: FontWeight.bold,)),),
      body: Center(
        child: Container(
            margin: const EdgeInsets.all(20.0),
            // color: Theme.of(context).primaryColorDark,
            child: Text("TODO"),//StreamBuilder(
            //   stream: routeCollection.doc(doc_id).snapshots(),
            //   builder: (context, snapshot){
            //     if (snapshot.hasData){
            //       final ridersInfo = snapshot.data!['riders'] as Map;
            //       debugPrint(ridersInfo.toString());
            //       List ridersID = ridersInfo.entries.map( (entry) => Weight(entry.key, entry.value)).toList();
            //       List ridersStatus = mapData.entries.map( (entry) => Weight(entry.key, entry.value)).toList();
            //       final ridersID = ridersInfo['id'];
            //       final ridersStatus = ridersInfo['status'];
            //
            //       return ListView.builder(
            //         itemCount: ridersID.length,
            //         shrinkWrap: true,
            //         physics: NeverScrollableScrollPhysics(),
            //         itemBuilder: (context, index) {
            //           return Card(
            //             color: Colors.lightBlue.shade100,
            //             margin: EdgeInsets.all(8.0),
            //             child: ListTile(
            //               title: Text("${ridersID}"),
            //               subtitle: Text("${ridersStatus}"),
            //               trailing: ElevatedButton(
            //                 onPressed: () {
            //                   debugPrint("this is the route we're talking about: " + doc_id);
            //                   // Navigator.pushNamed(context, "/RouteRiders");
            //                 },
            //                 child: Text("Accept"),
            //               ),
            //             ),
            //           );
            //         }, //list of listTiles
            //
            //
            //       );
            //     }
            //     else if (snapshot.hasError){
            //       return Text("${snapshot.error}");
            //     }
            //     else if (!snapshot.hasData){
            //       return Text("No rider bookings.");
            //     }
            //     else{
            //       return CircularProgressIndicator();
            //     }
            //
            //   },
            //
            // ),
          ),
      ),

    );
  }
}
