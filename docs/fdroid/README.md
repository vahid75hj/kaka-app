# F-Droid

The store texts and icon are in `fastlane/metadata/android/{en-US,fa-IR}`, the layout F-Droid reads. Each release adds a
`changelogs/<versionCode>.txt` file.

`app.kaka.yml` is a draft recipe for [fdroiddata](https://gitlab.com/fdroid/fdroiddata). Before submitting it:

- Check that the `sqlite3` build hook (`source: sqlite3mc`) compiles from source in the F-Droid build server, with no
  prebuilt binaries.
- Make sure the dependency tree has no Google Play Services or Firebase. `flutter_secure_storage`, `local_auth`,
  `share_plus`, `file_picker` and `workmanager` (androidx.work) are all AOSP or Jetpack.
- F-Droid signs with its own key. To offer reproducible builds that keep our signature, follow the
  [reproducible builds guide](https://f-droid.org/docs/Reproducible_Builds/).

Anti-features: none expected. The app makes no network calls unless the user configures an AI endpoint.
