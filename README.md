# X:/Passwd

This is a simple, local, and open-source password manager built with the Flutter SDK for Android devices.

#### How does it work?

When you create a vault, the password is symmetrically encrypted with AES-128, and the key is asymmetrically encrypted with RSA and securely stored on the device's KeyStore. When passwords are added to the vault, they, along with any additional details, are encrypted with AES-256-CTR, using a hash of the vault password as the encryption key (the hash is generated using PBKDF2 and a different salt every time).

#### What features does it have?

- AES-256-CTR encryption.

- Biometric authentication.

- Import vaults.

- Export vaults.

- Change vault password.

- Encrypted notes.

- Light theme.

- Dark theme.

#### How much does it cost?

It's available for purchase on the Play Store, and it costs £0.59. Of course you can build it for free by downloading the source code and compiling it, but if you like the app, then consider buying it (though I'd rather support and encourage open-source development over making some extra money).
