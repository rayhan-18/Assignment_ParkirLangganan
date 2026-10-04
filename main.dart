enum Status {
  aktif, expired, tidakTerdaftar
}

class Member { 
  String plat; 
  Status status; 
  Member(this.plat, this.status);
} 

class Tiket { 
  String plat; 
  int masuk, keluar; 
  bool hilang; 
  Tiket(this.plat, this.masuk, this.keluar, [this.hilang = false]);
}