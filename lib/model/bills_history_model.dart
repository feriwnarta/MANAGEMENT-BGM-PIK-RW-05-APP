class BillsHistoryModel {
  String date, month, year, total, description, price;
  bool isExpanded;
  
  BillsHistoryModel({this.date, this.month, this.year, this.total, this.description, this.price, this.billsHistoryBody, this.isExpanded});

  List<BillsHistoryModel> billsHistoryBody = [];

  // body builder list tile
  static List<BillsHistoryModel> getBillsHistoryBody() {
    return[
      BillsHistoryModel(
        date: '2',
        month: '02',
        year: '2022',
        price: '225.000',
        description: 'Tagihan Keamanan',
      ),
      BillsHistoryModel(
        date: '5',
        month: '02',
        year: '2022',
        price: '322.000',
        description: 'Tagihan Air'
      ),
      BillsHistoryModel(
        date: '12',
        month: '02',
        year: '2022',
        price: '75.000',
        description: 'Tagihan Kebersihan'
      ),
      BillsHistoryModel(
        date: '17',
        month: '02',
        year: '2022',
        price: '220.000',
        description: 'Tagihan Perawatan'
      ),
    ];
  }

  // header builder list tile
  static List<BillsHistoryModel> getBillsHistory() {
    return [
      BillsHistoryModel(
        month: 'February',
        year: '2022',
        total: '250.000',
        billsHistoryBody: getBillsHistoryBody(),
        isExpanded: false
      ),
      BillsHistoryModel(
        month: 'January',
        year: '2022',
        total: '150.000',
        billsHistoryBody: getBillsHistoryBody(),
        isExpanded: false
      ),
      BillsHistoryModel(
        month: 'December',
        year: '2021',
        total: '320.000',
        billsHistoryBody: getBillsHistoryBody(),
        isExpanded: false
      ),
      BillsHistoryModel(
        month: 'November',
        year: '2021',
        total: '180.000',
        billsHistoryBody: getBillsHistoryBody(),
        isExpanded: false
      ),
      BillsHistoryModel(
        month: 'October',
        year: '2021',
        total: '310.000',
        billsHistoryBody: getBillsHistoryBody(),
        isExpanded: false
      ),
    ];
  }
}
