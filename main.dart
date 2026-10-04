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

Status cekStatus(String plat) {
  for ( var member in listMember)
    if (member.plat == plat) return member.status;
    return Status.tidakTerdaftar;
}

int tarifDasar(int durasi) => durasi <= 1 ? 3000 : 3000 + (durasi - 1) * 2000;

int hitungTotal(Tiket t ) {
  int denda = t.hilang ? 20000 : 0;
  if (cekStatus(t.plat) == Status.aktif) return 0 + denda;
  return tarifDasar(hitungDurasi(t.masuk, t.keluar)) + denda; // // Kalau statusnya non-member atau kadaluarsa, hitung biaya durasi parkirnya ditambah denda
}