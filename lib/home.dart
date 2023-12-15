import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_demo/DatabaseUserID.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<DocumentSnapshot> documents = [];
  final CollectionReference routeCollection = FirebaseFirestore.instance.collection("routes");

  List<String> statuses = ['accepting requests', 'in service', "completed", 'cancelled'];
  String dialogText = 'accepting requests';

  Future openDialog(String doc_id) => showDialog(context: context, builder: (context) =>
      AlertDialog(
        title: Text("Update ride status"),
        content: DropdownButtonFormField <String>(
          // hint:  Text("Select location"),
            value: dialogText,
            items: statuses.map((val) =>
                DropdownMenuItem<String>(
                    value: val,
                    child: Text(val, style: const TextStyle(fontSize:12,),)
                ))
                .toList(),
            onChanged: (newStatus) {setState(() {
              dialogText = newStatus.toString();
            });},
            onSaved: (newStatus) {setState(() {
              dialogText = newStatus.toString();
            });},
            decoration: InputDecoration(
                labelText: "Update status",
                labelStyle: TextStyle(fontSize:14,color: Theme.of(context).primaryColor)
            ),
            validator: (value) {
              if (value == "") {
                return ('Status required.');
              }
              return null;
            }
        ),

        actions: [
          ElevatedButton(onPressed: () async {

            final docRoute = await FirebaseFirestore.instance.collection('routes').doc(doc_id).update(
                {'status': dialogText}
            );
            debugPrint('DocumentSnapshot edited with ID: ${doc_id}. New status: ${dialogText}');
            if(context.mounted) Navigator.of(context).pop();

            }, child: Text("Update"))
        ],
      ),
  );


  @override
  Widget build(BuildContext context) {

    final mySQfLite = DatabaseUserID();

    return Scaffold(
        appBar: AppBar(
          title: const Text("My Profile", style: TextStyle(
              fontSize:20, fontWeight: FontWeight.bold),),
          actions: [
            Container(
              margin: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    debugPrint("Signing you out!");
                    await mySQfLite.ifExistDB();
                    setState(() {

                      debugPrint("current user listener updated, now DELETING local profile data...");
                      mySQfLite.removeDB();
                    });
                    await mySQfLite.ifExistDB();
                    if(context.mounted)Navigator.pushReplacementNamed(context, "/Login");
                  },
                  style: ElevatedButton.styleFrom(
                    //padding: EdgeInsets.symmetric(horizontal: 15.0),
                    elevation: 2.0,
                    shape: const RoundedRectangleBorder(
                      //eccentricity: 0.5                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  child: Text("Sign out", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,
                    color: Theme.of(context).primaryColorDark,),)
              ),
            ),
          ],
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
        ),
        body: ListView(
          children: [

            Card(
              margin: const EdgeInsetsDirectional.symmetric(vertical: 8.0, horizontal: 20.0),
              color: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                //eccentricity: 0.5
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                //margin: EdgeInsetsDirectional.symmetric(vertical: 2.0, horizontal: 2.0),


                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      "${FirebaseAuth.instance.currentUser!.displayName}\n"
                      "${FirebaseAuth.instance.currentUser!.email}"),
                // StreamBuilder(stream: authService.user, builder: (_, AsyncSnapshot<Rider?> snapshot){
                  //   if(snapshot.connectionState == ConnectionState.active){
                  //     final Rider? rider = snapshot.data;
                  //     return rider == null ? Text("Null rider") : Text('${rider.fullName!}\n${rider.email!}');
                  //   }
                  //   else{
                  //     return Center(child:CircularProgressIndicator(),);
                  //   }
                  // },)
              ),
            ),
            const Divider(thickness:0, height: 40, color: Colors.transparent,),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
              // color: Colors.grey.shade400,
              child: ElevatedButton.icon(
                onPressed: (){
                  Navigator.pushNamed(context, "/Add");
                },
                style: ElevatedButton.styleFrom(
                  //padding: EdgeInsets.symmetric(horizontal: 15.0),
                  // elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    //eccentricity: 0.5
                    borderRadius: BorderRadius.circular(10),
                    // side: BorderSide(width:1.0),
                  ),
                  backgroundColor: Colors.blueAccent.shade700,
                ),
                icon: Icon(Icons.add),
                label: Text("Add Ride", style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(20.0),
              color: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: StreamBuilder(
                stream: routeCollection.where("driver_email", isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: documents.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.white70,
                          margin: EdgeInsets.all(8.0),

                          child: ListTile(
                            title: Text(documents[index]['to_loc']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    Text("pickup: " + documents[index]['from_loc']),
                                    Text(" @ " + documents[index]['time']),
                                    Text("status: " + documents[index]['status'], style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        openDialog(documents[index].id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColorDark),
                                      child: Text("Update status", style: TextStyle(fontSize: 12),),
                                    ),

                                    SizedBox(width:10),

                                    ElevatedButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, "/RouteRiders", arguments: {"id": documents[index].id});

                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepOrange),
                                      child: Text("View riders", style: TextStyle(fontSize: 12),),)
                                  ],
                                )
                              ],
                            ),

                            // trailing: Column(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     ElevatedButton(
                            //       onPressed: (){},
                            //       child: Text("Update status", style: TextStyle(fontSize: 12),),
                            //     ),
                            //     ElevatedButton(
                            //       onPressed: () {
                            //         debugPrint("id: " + snapshot.data!.docs[index].id);
                            //         Navigator.pushNamed(context, "/RouteRiders", arguments: {"id": snapshot.data!.docs[index].id});
                            //       },
                            //       child: Text("View riders", style: TextStyle(fontSize: 12),),
                            //     ),
                            //   ],
                            // ),
                          ),
                        );
                      }, //list of listTiles


                    );
                  }
                  else if (snapshot.hasError){
                    return Text("${snapshot.error}");
                  }
                  else{
                    return CircularProgressIndicator();
                  }

                },

              ),
            ),

          ],

        )
    );
  }
}


