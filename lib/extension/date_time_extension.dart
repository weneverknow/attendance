extension DateTimeExtension on DateTime {
  String infoDate() {
    return "${this.getDay()} ${this.shortMonth()} ${this.year}, ${this.getHour()}:${this.getMinute()} WIB";
  }

  String getHour() {
    if (this.hour < 10) {
      return "0${this.hour}";
    }
    return "${this.hour}";
  }

  String getMinute() {
    if (this.minute < 10) {
      return "0${this.minute}";
    }
    return "${this.minute}";
  }

  String shortMonth() {
    switch (this.month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
      default:
        return 'Desember';
    }
  }

  String getMonth() {
    if (this.month > 9) {
      return "${this.month}";
    }
    return "0${this.month}";
  }

  String getDay() {
    if (this.day > 9) {
      return "${this.day}";
    }
    return "0${this.day}";
  }
}
