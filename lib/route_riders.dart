import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_demo/BottomSheetProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteRidersPage extends StatefulWidget {
  const RouteRidersPage({super.key});

  @override
  State<RouteRidersPage> createState() => _RouteRidersPageState();
}

class _RouteRidersPageState extends State<RouteRidersPage> {

  final CollectionReference routeCollection = FirebaseFirestore.instance.collection("routes");
  Map received_data = {};


  Future editStatus(String newStatus, String doc_time, String route_id, String rider_uid) async{

    //check bypass
    bool bypass = Provider.of<BottomSheetProvider>(context, listen: false).bypassValue;
    if(!bypass){

      //if the time is constrained, return;
      DateTime currentTime = DateTime.now();

      // time=between 11:30pm & 7:30am for to_loc="Gate3/4"
      DateTime t1 = DateTime(currentTime.year, currentTime.month, currentTime.day, 23, 30); //hr, min, sec
      DateTime t2 = DateTime(currentTime.year, currentTime.month, currentTime.day, 7, 30); //hr, min, sec
      if(currentTime.isAfter(t1) && currentTime.isBefore(t2) && doc_time == "7:30 am"){
        if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Too late to accept riders."),));
        return;
      }

      // time=between 4:30pm & 5:30pm for to_loc!="Gate3/4"
      DateTime t3 = DateTime(currentTime.year, currentTime.month, currentTime.day, 4, 30); //hr, min, sec
      DateTime t4 = DateTime(currentTime.year, currentTime.month, currentTime.day, 5, 30); //hr, min, sec
      if(currentTime.isAfter(t1) && currentTime.isBefore(t2) && doc_time == "5:30 pm"){
        if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Too late to accept riders."),));
        return;
      }
    }

    final docRoute = await routeCollection
        .doc(route_id)
        .collection('riders')
        .doc(rider_uid)
        .update(
        {'status': newStatus});
    debugPrint('DocumentSnapshot STATUS edited}');

  }


  @override
  Widget build(BuildContext context) {

    received_data = ModalRoute.of(context)!.settings.arguments as Map;
    final doc_id = received_data['id'];
    final doc_time = received_data['time'];


    return Scaffold(
      appBar: AppBar(title: const Text("Route bookings", style: TextStyle(fontWeight: FontWeight.bold,)),),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          // color: Theme.of(context).primaryColorDark,
          child:
          ListView(
            // shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [

              Align(alignment: Alignment.center,child: Text("Bypass time constraint", style: TextStyle(fontWeight:FontWeight.bold),)),
              Switch(
                value: Provider.of<BottomSheetProvider>(context).bypassValue,
                onChanged: (bypass) => Provider.of<BottomSheetProvider>(context, listen: false).toggleBypass(bypass),
              ),
              StreamBuilder(
                  stream: routeCollection.doc(doc_id).collection('riders').snapshots(), //riders for this particular route
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      var documents = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: documents.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.lightBlue.shade100,
                            margin: EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text("${documents[index]['rider_name']}"),
                              isThreeLine: true,
                              subtitle: Wrap(
                                children: [

                                  Text("${documents[index]['rider_email']}"),

                                  documents[index]['status'] == "awaiting approval"
                                      ? Wrap(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          editStatus(
                                              "approved",
                                              doc_time,
                                              doc_id,
                                              documents[index]['rider_uid']);
                                          debugPrint("rider_uid: ${documents[index]['rider_uid']}, route_id: $doc_id");
                                        },
                                        child: Text("Accept"),
                                      ),
                                      SizedBox(width:10.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          editStatus(
                                              "rejected",
                                              doc_time,
                                              doc_id,
                                              documents[index]['rider_uid']);
                                          debugPrint("rider_uid: ${documents[index]['rider_uid']}, route_id: $doc_id");
                                        },
                                        child: Text("Reject"),
                                      ),
                                    ],
                                  )

                                      : Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text("${documents[index]['status']}",
                                      style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.orange),),
                                  )
                                ],
                              ),
                            ),
                          );
                        }, //list of listTiles


                      );

                    }
                    else if (snapshot.hasError){
                      return Text("${snapshot.error}");
                    }
                    else if (!snapshot.hasData){
                      return Text("No rider bookings.");
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                  }
              ),
            ],
          ),
        ),
      ),

    );
  }
}
