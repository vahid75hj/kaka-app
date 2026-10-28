# Security Policy

Kaka stores personal financial data **only on the device**: an encrypted SQLite database
(SQLite3MultipleCiphers, with a key in the Android Keystore through secure storage) and encrypted `.kaka` backups
(Argon2id + XChaCha20-Poly1305).

## Reporting a vulnerability

Please **do not** open a public issue. Use GitHub's private
[security advisory](https://github.com/vahid75hj/kaka-app/security/advisories/new) form instead.
Include the version, the device or Android version, steps to reproduce and the impact. Expect a first reply within 7 days.

## In scope
- Data leaving the device without the user's action (Kaka must not make any network call unless
  BYO-AI is configured)
- Weaknesses in backup encryption or the database key, and key handling
- Unmasked card or IBAN numbers sent to an AI provider
- SMS parsing that could be abused (for example, regex denial of service from a crafted SMS)
- APKs not signed with the published certificate

## Permissions
- `INTERNET`: used only by the optional bring-your-own-AI chat, to reach the endpoint you configure. With AI set to "none", nothing uses it.
- `READ_SMS` / `RECEIVE_SMS`: requested only when you turn on automatic SMS reading.
- `POST_NOTIFICATIONS`: requested only when you turn on background SMS reading.
- Bank SMS received while Kaka is closed wait in app-private storage (excluded from device backups), encrypted with AES-256-GCM under a non-exportable Android Keystore key, until Kaka moves them into the encrypted ledger.
- `USE_BIOMETRIC`: the app lock.

## Release signing certificate
SHA-256: `8f:f0:2c:bd:66:51:24:b4:4d:1c:78:b4:e5:f5:d9:b3:dd:ac:12:24:95:4e:2c:60:ee:ef:fd:5c:ef:c4:18:9e`

Verify it with `apksigner verify --print-certs kaka-*.apk`.
