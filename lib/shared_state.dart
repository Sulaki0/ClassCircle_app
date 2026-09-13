// lib/shared_state.dart
//
// Shared, app-wide state for ClassCircle.
//
// Currently holds the user's profile photo so that ProfileScreen and
// HomeScreen stay in sync. On native (Android) we store a File; on web
// we store raw bytes. Exactly one of the two will be non-null when a
// photo is set; both are null when no photo is set.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show ValueNotifier, kIsWeb;

/// A simple container for the current profile photo.
class ProfileImage {
  final File? file;
  final Uint8List? bytes;

  const ProfileImage({this.file, this.bytes});

  /// True if either a native file or web bytes are present.
  bool get hasImage => file != null || bytes != null;

  /// Convenience: nothing selected.
  static const ProfileImage empty = ProfileImage();
}

/// Global notifier. Any screen can read `profileImageNotifier.value`,
/// and any screen can write `profileImageNotifier.value = ...`.
/// Widgets that wrap their avatar in a `ValueListenableBuilder` will
/// rebuild automatically when this changes.
final ValueNotifier<ProfileImage> profileImageNotifier =
ValueNotifier<ProfileImage>(ProfileImage.empty);

/// Helper to set a native (Android) image.
void setProfileImageFromFile(File file) {
  profileImageNotifier.value = ProfileImage(file: file);
}

/// Helper to set a web image (raw bytes).
void setProfileImageFromBytes(Uint8List bytes) {
  profileImageNotifier.value = ProfileImage(bytes: bytes);
}

/// Clear the image (used on logout, or when user removes photo).
void clearProfileImage() {
  profileImageNotifier.value = ProfileImage.empty;
}