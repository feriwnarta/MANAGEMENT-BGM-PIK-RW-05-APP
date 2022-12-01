class ReportModel {
  String urlImageReport,
      noTicket,
      description,
      additionalInformation,
      idReport,
      idUser,
      location,
      time,
      status,
      category,
      iconCategory,
      latitude,
      longitude,
      star,
      comment,
      statusWorking,
      photoProcess1,
      photoProcess2,
      photoComplete1,
      photoComplete2;
  List<dynamic> dataKlasifikasi;

  ReportModel(
      {this.urlImageReport,
      this.noTicket,
      this.description,
      this.location,
      this.idReport,
      this.idUser,
      this.time,
      this.status,
      this.additionalInformation,
      this.category,
      this.iconCategory,
      this.latitude,
      this.longitude,
      this.star,
      this.comment,
      this.dataKlasifikasi,
      this.photoComplete1,
      this.photoComplete2,
      this.photoProcess1,
      this.photoProcess2,
      this.statusWorking});
}
