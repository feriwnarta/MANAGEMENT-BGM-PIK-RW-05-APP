class InformasiModel {
  String idNews,
      urlImageNews,
      caption,
      content,
      time,
      writter,
      updateAt,
      updateBy;

  InformasiModel.fromJson(Map<String, dynamic> fromJson)
      : idNews = fromJson['id_news'],
        urlImageNews = fromJson['url_news_image'],
        caption = fromJson['caption'],
        content = fromJson['content'],
        time = fromJson['time'],
        writter = fromJson['writter'],
        updateAt = fromJson['update_at'],
        updateBy = fromJson['updateBy'];
}

class InformasiUmumModel {
  String idNews,
      urlImageNews,
      caption,
      content,
      time,
      writter,
      updateAt,
      updateBy;

  InformasiUmumModel.fromJson(Map<String, dynamic> fromJson)
      : idNews = fromJson['id_informasi_umum'],
        urlImageNews = fromJson['url_news_image'],
        caption = fromJson['caption'],
        content = fromJson['content'],
        time = fromJson['time'],
        writter = fromJson['writter'],
        updateAt = fromJson['update_at'],
        updateBy = fromJson['updateBy'];
}
