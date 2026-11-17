cask "torli-stats" do
  version "1.14.0"
  sha256 "fa4f60398b257f471a15e8fc9c54ed03a657fb44c0fc914fcc1d09d43d08828e"

  url "https://github.com/JamesLi-dev/torli-stats/releases/download/v#{version}/TorliStats-#{version}-macos-arm64.zip"
  name "Torli Stats"
  desc "Community edition system monitor for the macOS menu bar"
  homepage "https://github.com/JamesLi-dev/torli-stats"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "TorliStats.app"

  caveats <<~EOS
    This is the community edition, not Pro. Both editions use the same app
    identity and installation path, so do not install this over Pro unless you
    intend to replace it. They cannot run as separate identities.

    This app is ad-hoc signed and is not notarized by Apple; macOS may block
    its first launch or request permissions again after an update. The optional
    sensor helper is managed separately by the app and is not removed by
    uninstalling this cask.
  EOS
end
