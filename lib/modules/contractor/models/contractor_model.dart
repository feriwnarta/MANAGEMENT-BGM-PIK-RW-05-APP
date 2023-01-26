class ContractorModel {
  String idReport,
      urlImage,
      title,
      description,
      time,
      address,
      latitude,
      statusComplaint,
      longitude;
  List<String> categoryDetail;

  ContractorModel(
      {this.idReport,
      this.urlImage,
      this.title,
      this.description,
      this.time,
      this.address,
      this.latitude,
      this.statusComplaint,
      this.categoryDetail,
      this.longitude});
}