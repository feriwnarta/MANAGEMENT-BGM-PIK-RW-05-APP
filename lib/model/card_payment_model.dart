class CardPaymentModel {
  String noPayment, title, status;

  CardPaymentModel({this.noPayment, this.title, this.status});

  static List<CardPaymentModel> getPaymentHistory() {
    return [
      CardPaymentModel(
        noPayment: 'PY052201',
        title: 'Pembayaran tagihan airrrrrrrrrrrrrrr',
        status: 'confirmed'
      ),
      CardPaymentModel(
        noPayment: 'PY052202',
        title: 'Pembayaran tagihan keamanan',
        status: 'confirmed'
      ),
      CardPaymentModel(
        noPayment: 'PY052203',
        title: 'Pembayaran tagihan kebersihan',
        status: 'confirmed'
      ),
      CardPaymentModel(
        noPayment: 'PY052204',
        title: 'Pembayaran tagihan perawatan',
        status: 'listed'
      ),
    ];
  }
}