import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;
  final GetUser getUser;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.getUser,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    await emit.forEach(
      getUser(),
      onData: (user) => user.fold(
        (failure) => AuthUnauthenticated(),
        (user) =>
            user != null ? AuthAuthenticated(user) : AuthUnauthenticated(),
      ),
      onError: (_, __) => AuthUnauthenticated(),
    );
  }

  Future<void> _onAuthSignInRequested(
      AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signIn(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError("Sign In Failed: ${failure.message}")),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onAuthSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUp(event.email, event.password, event.name);
    result.fold(
      (failure) => emit(AuthError("Sign Up Failed: ${failure.message}")),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onAuthSignOutRequested(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError("Sign Out Failed: ${e.toString()}"));
    }
  }
}
