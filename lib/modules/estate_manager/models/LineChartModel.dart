class LineChartModel {
  String title;
  List<dynamic> pic;
  List<dynamic> persentase;
  List<dynamic> persentaseSekarang;
  List<dynamic> dataChart;
  List<dynamic> dropdown;
  List<dynamic> status;

  LineChartModel.fromJson(
      {String title,
      List<dynamic> persentase,
      List<dynamic> pic,
      List<dynamic> dataChart,
      List<dynamic> dropdown,
      List<dynamic> status,
      List<dynamic> persentaseSekarang}) {
    this.title = title;
    this.persentase = persentase;
    this.dataChart = dataChart;
    this.dropdown = dropdown;
    this.pic = pic;
    this.status = status;
    this.persentaseSekarang = persentaseSekarang;
  }
}
