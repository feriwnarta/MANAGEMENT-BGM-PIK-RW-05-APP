class StatusPeduliEmModel {
  String title, status, image, address, lat, long, waktu, idReport;
  List<Map<String, dynamic>> cordinatorPhone;

  StatusPeduliEmModel({
    this.title,
    this.status,
    this.image,
    this.address,
    this.idReport,
    this.lat,
    this.long,
    this.waktu,
    this.cordinatorPhone,
  });
}
