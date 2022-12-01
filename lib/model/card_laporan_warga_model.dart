class CardLaporanWargaModel {
  final String noTicket, judul, status, content;

  CardLaporanWargaModel({this.noTicket, this.judul, this.status, this.content});

  static List<CardLaporanWargaModel> getAllLaporan = [
    CardLaporanWargaModel(
      // 7 digit kode
      noTicket: '0522001',
      judul: 'Kehilangan kembang janda bolong',
      status: 'Clear',
      content: 'Kehilangan kembang janda bolong di daerah cluster'
    ),
    CardLaporanWargaModel(
      noTicket: '0522003',
      judul: 'Kehilangan motor',
      status: 'Noticed',
      content: 'Kehilangan Motor dekat rumah pak RT'
    ),
    CardLaporanWargaModel(
      noTicket: '0522009',
      judul: 'Orang tidak dikenal mondar mandir',
      status: 'Clear',
      content: 'Kehilangan Motor dekat rumah pak RT, mohon segera dilakukan pengecekan cctv.'
    ),
    CardLaporanWargaModel(
      noTicket: '0522010',
      judul: 'Sampah berantakannnnnnnnnnn',
      status: 'Noticed',
      content: 'Sampah Berantakan'
    ),
    CardLaporanWargaModel(
      noTicket: '0522016',
      judul: 'Selokan mampet diebony golf G2',
      status: 'Listed',
      content: 'Selokan Mampet'
    ),
  ];
}
