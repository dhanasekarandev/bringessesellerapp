class BankHelper {
  static final Map<String, String> bankMap = {
    "SBIN": "State Bank of India",
    "HDFC": "HDFC Bank",
    "ICIC": "ICICI Bank",
    "UTIB": "Axis Bank",
    "KKBK": "Kotak Mahindra Bank",
    "PUNB": "Punjab National Bank",
    "BARB": "Bank of Baroda",
    "CNRB": "Canara Bank",
    "UBIN": "Union Bank of India",
    "MAHB": "Bank of Maharashtra",
    "IDFB": "IDFC First Bank",
    "YESB": "Yes Bank",
    "INDB": "IndusInd Bank",
    "SCBL": "Standard Chartered Bank",
    "CITI": "Citibank",
    "HSBC": "HSBC Bank",
    "DEUT": "Deutsche Bank",
    "IOBA": "Indian Overseas Bank",
    "BKID": "Bank of India",
    "CORP": "Corporation Bank",
    "CLBL": "Central Bank of India",
    "IDIB": "Indian Bank",
    "ESFB": "Equitas Small Finance Bank",
    "ESAF": "ESAF Small Finance Bank",
    "UJVN": "Ujjivan Small Finance Bank",
    "SURY": "Suryoday Small Finance Bank",
    "JANA": "Jana Small Finance Bank",
    "AUBL": "AU Small Finance Bank",
    "APGV": "AP Grameena Vikas Bank",
    "FINO": "Fino Payments Bank",
    "PAYT": "PayTM Payments Bank",
    "AIRP": "Airtel Payments Bank",
    "IPOS": "India Post Payments Bank",
    "RATN": "RBL Bank",
    "SVCB": "SVC Co-Operative Bank",
    "NKGS": "NKGSB Co-operative Bank",
    "KARB": "Karnataka Bank",
    "SRCB": "Saraswat Bank",
    "SIBL": "South Indian Bank",
    "DCBL": "DCB Bank",
    "TMBL": "Tamilnad Mercantile Bank",
    "KDCB": "Kalupur Commercial Co-operative Bank",
  };

  /// Fetch bank name using IFSC
  static String getBankName(String ifsc) {
    if (ifsc.isEmpty || ifsc.length < 4) return "Unknown Bank";

    String prefix = ifsc.substring(0, 4).toUpperCase();
    return bankMap[prefix] ?? "Unknown Bank";
  }
}
