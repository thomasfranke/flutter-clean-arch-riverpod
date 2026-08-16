/// Function signature used to trigger the access token refresh process.
typedef RefreshTokenFn = Future<bool> Function();

/// Function signature used to perform user logout and clear auth state.
typedef LogoutFn = Future<void> Function();
