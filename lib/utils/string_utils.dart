class StringUtils {
  static String replaceCountryNumberPhone(String phone) {
    var phoneNum = phone.substring(1);

    String code = '+62';

    code += phoneNum;

    print(code);

    return code;
  }
}
