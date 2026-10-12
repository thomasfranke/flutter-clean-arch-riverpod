// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for managing user preferences, including loading, saving, and
/// updating individual preference fields.
///
/// The whole app is themed, sized and translated from this state, so once a
/// value is loaded it is never replaced by `loading` or `failure` again: a
/// frame drawn from either would fall back to the defaults. A failed save
/// leaves the state as it was and is returned to the caller, which is the
/// one that can tell the user.

@ProviderFor(PreferencesNotifier)
final preferencesProvider = PreferencesNotifierProvider._();

/// Notifier for managing user preferences, including loading, saving, and
/// updating individual preference fields.
///
/// The whole app is themed, sized and translated from this state, so once a
/// value is loaded it is never replaced by `loading` or `failure` again: a
/// frame drawn from either would fall back to the defaults. A failed save
/// leaves the state as it was and is returned to the caller, which is the
/// one that can tell the user.
final class PreferencesNotifierProvider
    extends $NotifierProvider<PreferencesNotifier, PreferencesState> {
  /// Notifier for managing user preferences, including loading, saving, and
  /// updating individual preference fields.
  ///
  /// The whole app is themed, sized and translated from this state, so once a
  /// value is loaded it is never replaced by `loading` or `failure` again: a
  /// frame drawn from either would fall back to the defaults. A failed save
  /// leaves the state as it was and is returned to the caller, which is the
  /// one that can tell the user.
  PreferencesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesNotifierHash();

  @$internal
  @override
  PreferencesNotifier create() => PreferencesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreferencesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreferencesState>(value),
    );
  }
}

String _$preferencesNotifierHash() =>
    r'7a5bbda57942bb8b2c3b61b853e7108f091e9821';

/// Notifier for managing user preferences, including loading, saving, and
/// updating individual preference fields.
///
/// The whole app is themed, sized and translated from this state, so once a
/// value is loaded it is never replaced by `loading` or `failure` again: a
/// frame drawn from either would fall back to the defaults. A failed save
/// leaves the state as it was and is returned to the caller, which is the
/// one that can tell the user.

abstract class _$PreferencesNotifier extends $Notifier<PreferencesState> {
  PreferencesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PreferencesState, PreferencesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PreferencesState, PreferencesState>,
              PreferencesState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
