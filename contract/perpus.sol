//SPDX-License-Identifier: UNLICENSE

pragma solidity 0.8.20;

// Import library SafeMath dari OpenZeppelin
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Perpustakaan {
    using SafeMath for uint256; // Menggunakan SafeMath untuk operasi uint256

    // Struktur data untuk menyimpan informasi buku
    struct Buku {
        string ISBN;
        string judul;
        uint256 tahunDibuat;
        string penulis;
    }

    // Mapping untuk menghubungkan ISBN dengan data buku
    mapping(string => Buku) public bukuMapping;

    // Alamat admin
    address public admin;

    // Modifier untuk membatasi akses hanya untuk admin
    modifier hanyaAdmin() {
        require(
            msg.sender == admin, "Akses ditolak. Hanya admin yang dapat mengakses."
            );
        _;
    }

    // Constructor untuk menginisialisasi kontrak dengan alamat admin
    constructor() {
        admin = msg.sender;
    }

    // Fungsi untuk menambahkan buku baru
    function tambahBuku(string memory ISBN, string memory judul, uint256 tahunDibuat, string memory penulis) public hanyaAdmin {
        // Pastikan ISBN unik sebelum menambahkan buku
        require(
            bukuMapping[ISBN].tahunDibuat == 0, "ISBN sudah digunakan."
            );

        Buku memory bukuBaru = Buku(ISBN, judul, tahunDibuat, penulis);
        bukuMapping[ISBN] = bukuBaru;
    }

    // Fungsi untuk mengupdate buku
    function updateBuku(string memory ISBN, string memory judul, uint256 tahunDibuat, string memory penulis) public hanyaAdmin {
        // Pastikan buku dengan ISBN tertentu sudah ada sebelum mengupdate
        require(
            bukuMapping[ISBN].tahunDibuat != 0, "Buku tidak ditemukan."
            );

        Buku memory bukuUpdate = Buku(ISBN, judul, tahunDibuat, penulis);
        bukuMapping[ISBN] = bukuUpdate;
    }

    // Fungsi untuk menghapus buku
    function hapusBuku(string memory ISBN) public hanyaAdmin {
        // Pastikan buku dengan ISBN tertentu sudah ada sebelum menghapus
        require(
            bukuMapping[ISBN].tahunDibuat != 0, "Buku tidak ditemukan."
            );

        delete bukuMapping[ISBN];
    }

    // Fungsi untuk mendapatkan data buku berdasarkan ISBN
    function getDataBuku(string memory ISBN) public view returns (string memory, string memory, uint256, string memory) {
        Buku memory buku = bukuMapping[ISBN];
        require(
            buku.tahunDibuat != 0, "Buku tidak ditemukan."
            );

        return (buku.ISBN, buku.judul, buku.tahunDibuat, buku.penulis);
    }
}
