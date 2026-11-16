# Torli Stats Homebrew Tap

Community edition for Apple Silicon Macs running macOS 15 or later:

```sh
brew tap torli-dev/torli-stats
brew install --cask torli-dev/torli-stats/torli-stats
```

The Cask installs the Community edition, not Pro. Both editions share an application identity and installation path. The app is ad-hoc signed and not notarized; macOS may block its first launch or request permissions again after an update. Removing the Cask does not remove the optional sensor helper; use the app's sensor settings to uninstall it.

The tap checks the latest public [Community release](https://github.com/JamesLi-dev/torli-stats/releases/latest) hourly and can also be updated using the **Sync Community Cask** workflow's manual trigger. It downloads the arm64 ZIP and calculates its SHA256 before updating the Cask. No Pro packages or credentials are stored here.