class DetailLaporanSelesaiModel {
  String imageProcess1, imageProcess2;
  String imageComplete1, imageComplete2;
  List<Map<String, dynamic>> processReport;
  String star, duration;
  String location;
  List<String> complaint;

  DetailLaporanSelesaiModel({
    this.imageProcess1,
    this.imageProcess2,
    this.imageComplete1,
    this.imageComplete2,
    this.processReport,
    this.star,
    this.location,
    this.complaint,
    this.duration,
  });
}
