extension StringExtension on String {
  String toCamelCase() {
    var name = this.trim().split(' ');
    var temp = '';
    if (name.length > 1) {
      for (var n in name) {
        temp += n.split('')[0].toUpperCase() + (n.substring(1)) + ' ';
      }
    } else {
      print("extension" + name.length.toString());
      temp =
          this.trim().split('')[0].toUpperCase() + (this.trim().substring(1));
    }

    return temp;
  }
}
