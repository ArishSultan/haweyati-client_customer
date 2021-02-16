import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/rest/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati_client_data_models/models/products/delivery-vehicle_model.dart';

class SelectVehicle extends StatefulWidget {
  final List<DeliveryVehicle> vehicles;
  final DeliveryVehicle selectedVehicle;
  SelectVehicle(this.vehicles,this.selectedVehicle);
  @override
  _SelectVehicleState createState() => _SelectVehicleState();
}

class _SelectVehicleState extends State<SelectVehicle> {
  DeliveryVehicle selectedVehicle;

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.selectedVehicle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: RaisedActionButton(
          icon: Icon(CupertinoIcons.checkmark_circle),
          label: 'Proceed',
          onPressed: selectedVehicle == null ? null : () {
            Navigator.pop(context,selectedVehicle);
          },
        ),
        body: ListView.builder(
                  itemCount: widget.vehicles.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var _driver = widget.vehicles[index];
                    return RadioListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      value: _driver,
                      groupValue: selectedVehicle,
                      onChanged: (val) {
                        setState(() {
                          selectedVehicle = val;
                        });
                      },
                      secondary: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: _driver.image !=null ? NetworkImage(
                          HaweyatiService.resolveImage(_driver.image?.name)
                      ) : AssetImage("assets/images/icon.png"),
                    ),
                      title: Text(_driver.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Volumetric Weight : " + _driver.volumetricWeight.toString()),
                        ],
                      ),
                    );
            }),
    );
  }
}
