class CommentModel {
  String urlImage, userName, date, comment;

  CommentModel({this.urlImage, this.userName, this.date, this.comment});

  static List<CommentModel> getAllComment() {
    return [
      CommentModel(
          urlImage:
              'https://img.idxchannel.com/media/700/images/idx/2022/03/08/Kekayaan_Orang_Tua_Sisca_Kohl.jpg',
          userName: 'sisca',
          date: 'today 13.31',
          comment: 'jalanan rusak saat tergenang air sulit untuk dihindari'),
      CommentModel(
          urlImage:
              'https://awsimages.detik.net.id/community/media/visual/2022/03/14/muhammad-paeway-ebiem-kahar_169.jpeg?w=700&q=90',
          userName: 'Santiago',
          date: 'today 11.50',
          comment: 'jalanan rusak bikin orang mudah kecelakaan'),
      CommentModel(
          urlImage:
              'https://cdn-2.tstatic.net/tribunnews/foto/bank/images/seorang-petani-di-oku-timur-ditangkap-karena-menghilangkan-nyawa-orang.jpg',
          userName: 'Jaka sudarman',
          date: 'Yesterday 14.15',
          comment: 'kapan jalanan dibenerin'),
      CommentModel(
          urlImage:
              'https://awsimages.detik.net.id/community/media/visual/2019/09/25/24d37f7d-ba75-4cd1-93f7-d29a31d31d4f.jpeg?w=750&q=90',
          userName: 'Joko sudojo',
          date: 'Yesterday 13.20',
          comment: 'jalanan rusak tidak pernah dibenerin'),
    ];
  }
}
