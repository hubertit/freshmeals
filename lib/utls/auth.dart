// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:dio/dio.dart';
//
// class GoogleAuthService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email', 'profile'],
//   );
//
//   Future<GoogleSignInAccount?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       return googleUser;
//     } catch (e) {
//       print("Google Sign-In Error: $e");
//       return null;
//     }
//   }
//
//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//   }
// }
//
//
// class AuthRepository {
//   final Dio _dio = Dio();
//
//   Future<Map<String, dynamic>?> authenticateUser(String idToken) async {
//     try {
//       final response = await _dio.post(
//         "https://your-backend.com/api/auth/google",
//         data: {"id_token": idToken},
//       );
//       return response.data;
//     } catch (e) {
//       print("Backend Authentication Error: $e");
//       return null;
//     }
//   }
// }
