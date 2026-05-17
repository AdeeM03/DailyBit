import 'package:firebase_auth/firebase_auth.dart';

/// Maps FirebaseAuthException codes to user-friendly Indonesian messages.
String mapAuthError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
        return 'Email atau password salah';
      case 'user-not-found':
        return 'Akun tidak ditemukan';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan login';
      case 'weak-password':
        return 'Password terlalu lemah. Minimal 6 karakter';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet';
      case 'operation-not-allowed':
        return 'Metode login tidak tersedia';
      default:
        return 'Terjadi kesalahan: ${error.message ?? error.code}';
    }
  }
  final msg = error.toString();
  // Handle wrapped exceptions like "[firebase_auth/invalid-credential] ..."
  if (msg.contains('invalid-credential') || msg.contains('wrong-password')) {
    return 'Email atau password salah';
  }
  if (msg.contains('user-not-found')) return 'Akun tidak ditemukan';
  if (msg.contains('too-many-requests')) return 'Terlalu banyak percobaan. Coba lagi nanti';
  if (msg.contains('email-already-in-use')) return 'Email sudah terdaftar. Silakan login';
  if (msg.contains('network-request-failed')) return 'Tidak ada koneksi internet';
  return 'Terjadi kesalahan. Coba lagi';
}
