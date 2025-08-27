import "dart:math";

class RngStrGen {
  // Random string generator with length
  static String generator(int length) {
    Random random = Random();
    String chars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
    String result = "";
    for(int i = 0; i < length; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return "";
  }
}