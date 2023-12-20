import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_demo/services/AuthService.dart';
import 'package:driver_demo/services/BottomSheetProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  // Map received_data = {};
  @override
  Widget build(BuildContext context) {

    final addFormKey = GlobalKey<FormState>();
    final priceController = TextEditingController();

    // List <String> allLocations = Provider.of<BottomSheetProvider>(context).locations;
    List <String> pickupLocations = Provider.of<BottomSheetProvider>(context).pickupLocations;
    List <String> destinationLocations = Provider.of<BottomSheetProvider>(context).destinationLocations;
    List<String> rideTimes = Provider.of<BottomSheetProvider>(context).ridesTimes;


    // received_data = ModalRoute.of(context)!.settings.arguments as Map;
    final authService = Provider.of<AuthService>(context);


    Future createRoute(routeObj) async{

      try {
        final docRoute = await FirebaseFirestore.instance.collection('routes')
            .add(
            routeObj
        )
            .then((DocumentReference doc) {
          debugPrint('DocumentSnapshot added with ID: ${doc.id}');
          if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ride created successfully!"),));

            });
            // if(context.mounted)Navigator.of(context).pop(););
      }
      on Exception catch (error){
        debugPrint("Some internal error happened:${error.toString()}");
        final snackBar = SnackBar(content: Text("Some internal error happened:${error.toString()}"),);
        if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Create a Route", style: TextStyle(fontWeight: FontWeight.bold,)),),

      body: Form(
        key: addFormKey,
        child: SingleChildScrollView(
            child: Container(
                // color: Colors.orange.shade100,
                // margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(30.0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    RadioListTile(
                      activeColor: Colors.orangeAccent,


                      value: rideTimes[0],
                      groupValue: Provider.of<BottomSheetProvider>(context).selectedTime,
                      onChanged: (value) => Provider.of<BottomSheetProvider>(context, listen: false).toggleTime(value),

                      title: const Text("7:30 am", style: TextStyle(fontSize: 16),),
                      subtitle: const Text("ride to ASUENG", style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    RadioListTile(
                      activeColor: Colors.orangeAccent,


                      value: rideTimes[1],
                      groupValue: Provider.of<BottomSheetProvider>(context).selectedTime,
                      onChanged: (value) => Provider.of<BottomSheetProvider>(context, listen: false).toggleTime(value),

                      title: const Text("5:30 pm", style: TextStyle(fontSize: 16),),
                      subtitle: const Text("ride to somewhere else in Cairo", style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    const SizedBox(height:10),


                    SizedBox(
                      // width: 100,
                      child: DropdownButtonFormField <String>(
                        // hint:  Text("Select location"),
                        value: Provider.of<BottomSheetProvider>(context).selectedPickupLoc,
                        items: pickupLocations.map((loc) =>
                            DropdownMenuItem<String>(
                                value: loc,
                                child: Text(loc, style: const TextStyle(fontSize:14,),)
                            ))
                            .toList(),
                        onChanged: (loc) => Provider.of<BottomSheetProvider>(context, listen: false).changePickup(loc),
                        decoration: InputDecoration(
                            labelText: "Choose your pickup point",
                            labelStyle: TextStyle(fontSize:14,color: Theme.of(context).primaryColor)
                        ),
                        validator: (value) {
                          if (value == "<None>") {
                            return ('Pickup location required.');
                          }
                          return null;
                        }
                      ),),
                    SizedBox(
                      // width: 100,
                      child: DropdownButtonFormField <String>(
                        // hint:  Text("Select location"),
                        value: Provider.of<BottomSheetProvider>(context).selectedDestinationLoc,
                        items: destinationLocations.map((loc) =>
                            DropdownMenuItem<String>(
                                value: loc,
                                child: Text(loc, style: const TextStyle(fontSize:14,))
                            ))
                            .toList(),
                        onChanged: (loc) => Provider.of<BottomSheetProvider>(context, listen: false).changeDestination(loc),
                        decoration: InputDecoration(
                            labelText: "Choose your destination point",
                            labelStyle: TextStyle(fontSize:14,color: Theme.of(context).primaryColor)
                        ),
                          validator: (value) {
                            if (value == "<None>") {
                              return ('Destination location required.');
                            }
                            return null;
                          }
                      ),
                    ),
                    const SizedBox(height:20),

                    //TODO stop implementation

                    //price
                    TextFormField(controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Price in EGP",
                          //hintText: "<your_ID_here>@eng.asu.edu.eg",
                          //floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10)),
                              borderSide: BorderSide(
                                width: 1,)),
                          // prefixIcon: Icon(I),
                        ),
                        validator: (valid) {
                          if (valid == null || valid.isEmpty) {
                            return ('Price required.');
                          }
                          return null;
                        }),
                    const SizedBox(height:10),
                    ElevatedButton(
                        onPressed: (){
                          //add to db
                          if(Provider.of<BottomSheetProvider>(context, listen: false).selectedTime == "<None>"){
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select a time for your ride'),));
                            return;
                          }
                          else if(addFormKey.currentState!.validate()){
                            debugPrint("OK add to DB.");
                            final route = {
                              'from_loc' : Provider.of<BottomSheetProvider>(context, listen: false).selectedPickupLoc,
                              'to_loc' : Provider.of<BottomSheetProvider>(context, listen: false).selectedDestinationLoc,
                              'time' : Provider.of<BottomSheetProvider>(context, listen: false).selectedTime,
                              'price' : priceController.text,
                              'driver_email' : authService.getUserEmail(),
                              'driver_name' : authService.getDisplayName(),
                              'status' : 'accepting requests'
                              // 'stop' : googleAPI
                            };

                            createRoute(route);
                            Navigator.of(context).pop(context);
                          }
                        },
                        child: const Text("Create"))

                  ],)
            )
        ),
      ),


    );
  }
}

