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

// Membuat daftar list untuk menyimpan semua data member
var listMember = [
  Member('B 1234 ABC', Status.aktif),
  Member('B 5678 DEF', Status.expired)
];

int hitungDurasi(int m, int k ) => (k - m) > 0 ? (k - m) : 1; 