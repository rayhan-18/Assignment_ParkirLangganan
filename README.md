# Latihan Pertemuan 2
**Use Case:** Parkir Langganan
**Nama:** Muhamad Rayhan
**NIM:** [1124160206]

---

## BAGIAN A: DOKUMEN ANALISIS

### 1. Problem Statement
Sistem parkir membutuhkan program untuk menghitung tarif kendaraan berdasarkan status keanggotaannya. Sistem harus membedakan tarif antara `Member` (gratis) dan non-member (tarif progresif per jam), serta menambahkan denda jika status tiket dinyatakan hilang.

### 2. Actor
- **Sistem / Petugas Parkir:** Memasukkan data tiket (plat, jam masuk, jam keluar, status hilang) dan melihat total tagihan.

### 3. Input & Output
- **Input:** 
  - `plat` (String)
  - `masuk` (Integer, format jam)
  - `keluar` (Integer, format jam)
  - `hilang` (Boolean, default: false)
- **Output:** 
  - Total pembayaran parkir (Integer).

### 4. Functional Requirement
- **FR-01:** Sistem dapat memverifikasi status keanggotaan berdasarkan data `listMember`.
- **FR-02:** Sistem dapat menghitung durasi parkir (selisih jam keluar dan masuk).
- **FR-03:** Sistem dapat menghitung tarif dasar progresif (khusus non-member).
- **FR-04:** Sistem dapat menambahkan denda pada total tagihan jika tiket hilang.

### 5. Business Rules (BR)
- **BR-01:** Member dengan status `aktif` mendapatkan layanan parkir gratis (Rp 0).
- **BR-02:** Tarif non-member bersifat progresif: 1 jam pertama Rp 3.000, jam berikutnya ditambah Rp 2.000/jam. Minimal durasi dihitung 1 jam.
- **BR-03:** Jika tiket hilang, dikenakan denda mutlak sebesar Rp 20.000.
- **BR-04:** Member dengan status `expired` dikenakan tarif yang sama dengan non-member.

### 6. Decomposition
Masalah dipecah menjadi 4 fungsi (*function*) agar lebih fokus dan modular:
1. `hitungDurasi(m, k)` : Menghitung selisih waktu (`k - m`). Jika hasil <= 0, dibulatkan jadi 1.
2. `cekStatus(plat)` : Mencari plat nomor di `listMember` untuk mengembalikan statusnya.
3. `tarifDasar(durasi)` : Menghitung biaya parkir berdasarkan rumus progresif.
4. `hitungTotal(t)` : Menentukan nilai denda, mengecek status, dan menggabungkan semua kalkulasi menjadi total bayar.

### 7. Pattern Recognition
- **Pencarian Data:** Menggunakan perulangan `for (var member in listMember)` untuk menemukan status berdasarkan kecocokan plat nomor.
- **Pengkondisian Singkat (Ternary):** Menggunakan pola `kondisi ? nilai_jika_benar : nilai_jika_salah` secara berulang untuk menentukan denda, durasi, dan tarif progresif.

### 8. Abstraction
Sistem hanya mengambil atribut yang relevan untuk perhitungan:
- **Enum `Status`**: Hanya berisi nilai `aktif`, `expired`, dan `tidakTerdaftar`.
- **Class `Member`**: Atribut yang disimpan hanya `plat` dan `status`.
- **Class `Tiket`**: Atribut yang diproses hanya `plat`, `masuk`, `keluar`, dan `hilang`.

### 9. Algorithm (Langkah-Langkah Proses)

**Algoritma Pengecekan Status Member (cekStatus)**
1. Menerima input `plat` kendaraan.
2. Lakukan perulangan untuk memeriksa data di dalam `listMember`.
3. Periksa apakah `plat` yang diinput cocok dengan plat yang ada di data member. Jika cocok, kembalikan status member tersebut (aktif/expired).
4. Jika sampai akhir perulangan plat tidak ditemukan, kembalikan status `tidakTerdaftar`.

**Algoritma Perhitungan Durasi Parkir (hitungDurasi)**
1. Menerima input jam masuk (`m`) dan jam keluar (`k`).
2. Hitung durasi dengan mengurangi jam keluar dengan jam masuk (`k - m`).
3. Jika hasil perhitungan lebih dari 0, maka nilai durasi adalah hasil pengurangan tersebut.
4. Jika hasil perhitungan kurang dari atau sama dengan 0, maka durasi otomatis dibulatkan menjadi 1.
5. Kembalikan nilai durasi.

**Algoritma Perhitungan Tarif Dasar Non-Member (tarifDasar)**
1. Menerima input `durasi` parkir (dalam jam).
2. Periksa apakah `durasi` kurang dari atau sama dengan 1. Jika ya, tetapkan tarif sebesar Rp 3.000.
3. Jika `durasi` lebih dari 1 jam, hitung tarif dengan rumus: 3000 + ((durasi - 1) * 2000).
4. Kembalikan nilai tarif yang sudah dihitung.

**Algoritma Utama Perhitungan Total Bayar (hitungTotal)**
1. Menerima input objek tiket (`t`) yang berisi plat, jam masuk, jam keluar, dan status tiket hilang.
2. Periksa apakah tiket hilang. Jika `t.hilang` adalah true, maka set `denda` = 20000. Jika tidak hilang, set `denda` = 0.
3. Panggil algoritma pengecekan status member berdasarkan `t.plat`.
4. Jika status member adalah `aktif`, maka tarif parkir ditetapkan Rp 0. Total bayar adalah 0 ditambah `denda`. Kembalikan nilai total bayar (BR-01).
5. Jika status member bukan `aktif` (yaitu `expired` atau `tidakTerdaftar`), maka:
   - Panggil algoritma perhitungan durasi berdasarkan jam masuk dan jam keluar.
   - Panggil algoritma perhitungan tarif dasar berdasarkan durasi yang didapat.
   - Total bayar adalah nilai tarif dasar ditambah `denda`.
6. Kembalikan nilai total bayar (BR-02, BR-03, BR-04).

### 10. Flowchart

```text
                 [ START ]
                     │
                     ▼
             Input Object Tiket (t)
                     │
                     ▼
        ┌─────────────────────────┐
        │ Apakah t.hilang == true?│
        └───────┬─────────┬───────┘
             YA │         │ TIDAK
                ▼         ▼
         denda = 20000   denda = 0
                │         │
                └────┬────┘
                     │
                     ▼
        ┌─────────────────────────┐
        │     Cek Status Member   │
        │    ( cekStatus(t.plat)) │
        └───────┬─────────┬───────┘
                │         │
           [AKTIF]   [EXPIRED / TIDAK TERDAFTAR]
                │         │
                ▼         ▼
           tarif = 0   durasi = hitungDurasi(t.masuk, t.keluar)
                       tarif = tarifDasar(durasi)
                │         │
                └────┬────┘
                     │
                     ▼
          Hitung: Total = tarif + denda
                     │
                     ▼
                Return Total
                     │
                     ▼
                  [ END ]
```

### 11. Pseudocode

```
PROCEDURE hitungDurasi(m, k)

    IF (k - m) > 0 THEN
        RETURN k - m
    ELSE
        RETURN 1
    END IF

END PROCEDURE


PROCEDURE cekStatus(plat)

    FOR EACH member IN listMember
        IF member.plat == plat THEN
            RETURN member.status
        END IF
    END FOR

    RETURN "tidakTerdaftar"

END PROCEDURE


PROCEDURE tarifDasar(durasi)

    IF durasi <= 1 THEN
        RETURN 3000
    ELSE
        RETURN 3000 + ((durasi - 1) * 2000)
    END IF

END PROCEDURE


PROCEDURE hitungTotal(t)

    IF t.hilang == TRUE THEN
        denda = 20000
    ELSE
        denda = 0
    END IF

    statusMember = CALL cekStatus(t.plat)

    IF statusMember == "aktif" THEN
        RETURN 0 + denda
    ELSE
        durasi = CALL hitungDurasi(t.masuk, t.keluar)
        tarif = CALL tarifDasar(durasi)

        RETURN tarif + denda
    END IF

END PROCEDURE
```

### 12. Tabel Traceability

| ID          | Requirement                                                             | Business Rule | Fungsi Terkait       | Hasil yang Diharapkan                                                                       |
| ----------- | ----------------------------------------------------------------------- | ------------- | -------------------- | ------------------------------------------------------------------------------------------- |
| FR-01       | Sistem dapat memverifikasi status keanggotaan berdasarkan `listMember`. | BR-01, BR-04  | `cekStatus(plat)`    | Sistem dapat menentukan status kendaraan sebagai `aktif`, `expired`, atau `tidakTerdaftar`. |
| FR-02       | Sistem dapat menghitung durasi parkir.                                  | BR-02         | `hitungDurasi(m, k)` | Durasi dihitung dari `jam keluar - jam masuk` dengan minimal 1 jam.                         |
| FR-03       | Sistem dapat menghitung tarif dasar progresif untuk non-member.         | BR-02, BR-04  | `tarifDasar(durasi)` | Tarif jam pertama Rp 3.000 dan setiap jam berikutnya bertambah Rp 2.000.                    |
| FR-04       | Sistem dapat menambahkan denda jika tiket hilang.                       | BR-03         | `hitungTotal(t)`     | Sistem menambahkan denda sebesar Rp 20.000 jika `hilang = true`.                            |
| FR-01–FR-04 | Sistem menghasilkan total pembayaran parkir.                            | BR-01–BR-04   | `hitungTotal(t)`     | Total pembayaran dihitung berdasarkan status member, durasi, tarif, dan denda.              |
