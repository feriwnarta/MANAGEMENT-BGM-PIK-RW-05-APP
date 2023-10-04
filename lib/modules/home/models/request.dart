class Request {
  String id,
      idUser,
      image,
      note,
      periode,
      status,
      createAt,
      type = 'Kantong Sampah',
      category = 'all';

  Request(
      {this.id,
      this.idUser,
      this.image,
      this.note,
      this.periode,
      this.status,
      this.createAt,
      this.type,
      this.category});
}
