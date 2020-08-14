class AvailableServices {
  List<String> services;

  AvailableServices({this.services});

  AvailableServices.fromJson(Map<String, dynamic> json) {
    services = json['services'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['services'] = this.services;
    return data;
  }
}