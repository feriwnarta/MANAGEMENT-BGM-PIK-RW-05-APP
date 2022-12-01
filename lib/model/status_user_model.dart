class StatusUserModel {
  final String urlProfile,
      userName,
      uploadTime,
      urlStatusImage,
      caption,
      numberOfLikes,
      idStatus,
      numberOfComments,
      likeCount,
      commentCount;
  int isLike;

  StatusUserModel(
      {this.userName,
      this.uploadTime,
      this.urlProfile,
      this.urlStatusImage,
      this.caption,
      this.idStatus,
      this.numberOfLikes,
      this.numberOfComments,
      this.commentCount,
      this.isLike,
      this.likeCount});
}
