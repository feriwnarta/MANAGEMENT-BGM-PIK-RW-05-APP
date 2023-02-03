class ManagerContractorModel {
  String idReport,
      urlImage,
      title,
      description,
      time,
      address,
      latitude,
      statusComplaint,
      longitude,
      processTime;
  List<String> categoryDetail;

  List<Map<String, dynamic>> kepalaContratorPhone;

  ManagerContractorModel(
      {this.idReport,
      this.urlImage,
      this.title,
      this.description,
      this.time,
      this.address,
      this.latitude,
      this.statusComplaint,
      this.categoryDetail,
      this.longitude,
      this.processTime,
      this.kepalaContratorPhone});
}
