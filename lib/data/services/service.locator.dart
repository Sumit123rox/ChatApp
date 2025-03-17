import 'package:chat_app/data/repositories/auth_repository.dart';
import 'package:chat_app/data/repositories/chat_repository.dart';
import 'package:chat_app/data/repositories/contact_repository.dart';
import 'package:chat_app/logic/cubits/auth/auth_cubit.dart';
import 'package:chat_app/logic/cubits/chat/chat_cubit.dart';
import 'package:chat_app/router/app_rounter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register services as singletons
  locator.registerLazySingleton(() => AppRouter());
  locator.registerLazySingleton(() => FirebaseFirestore.instance);
  locator.registerLazySingleton(() => FirebaseAuth.instance);
  locator.registerLazySingleton(() => AuthRepository());
  locator.registerLazySingleton(() => ContactRepository());
  locator.registerLazySingleton(() => ChatRepository());
  locator.registerLazySingleton(
    () => AuthCubit(authRepository: AuthRepository()),
  );
  locator.registerFactory(
    () => ChatCubit(
      chatRepository: ChatRepository(),
      currentUserId: locator<FirebaseAuth>().currentUser!.uid,
    ),
  );
}
