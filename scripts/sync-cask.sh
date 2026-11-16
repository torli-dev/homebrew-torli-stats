#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CASK="$ROOT/Casks/torli-stats.rb"
REPO="JamesLi-dev/torli-stats"
TAG="$(gh release view --repo "$REPO" --json tagName --jq .tagName)"
[[ "$TAG" =~ ^v([0-9]+\.[0-9]+\.[0-9]+)$ ]] || { echo "Unsupported release tag: $TAG" >&2; exit 1; }
VERSION="${BASH_REMATCH[1]}"
CURRENT="$(ruby -e 's=File.read(ARGV[0]); m=s.scan(/^  version "([0-9]+\.[0-9]+\.[0-9]+)"$/); abort "Invalid cask version" unless m.size == 1; puts m[0][0]' "$CASK")"
if [[ "$CURRENT" == "$VERSION" ]]; then
  echo "Cask is already at $VERSION."
  exit 0
fi
ruby -e 'require "rubygems/version"; abort "Refusing to downgrade cask" if Gem::Version.new(ARGV[0]) < Gem::Version.new(ARGV[1])' "$VERSION" "$CURRENT"
TEMP="$(mktemp -d)"
trap 'rm -rf "$TEMP"' EXIT
ARCHIVE="TorliStats-$VERSION-macos-arm64.zip"
gh release download "$TAG" --repo "$REPO" --pattern "$ARCHIVE" --dir "$TEMP"
SHA256="$(shasum -a 256 "$TEMP/$ARCHIVE" | cut -d ' ' -f 1)"
export VERSION SHA256
ruby -e '
  path = ARGV.fetch(0)
  cask = File.read(path)
  abort "Expected one version" unless cask.scan(/^  version "[0-9]+\.[0-9]+\.[0-9]+"$/).size == 1
  abort "Expected one SHA256" unless cask.scan(/^  sha256 "[0-9a-f]{64}"$/).size == 1
  cask.sub!(/^  version "[0-9]+\.[0-9]+\.[0-9]+"$/, "  version \"#{ENV.fetch("VERSION")}\"")
  cask.sub!(/^  sha256 "[0-9a-f]{64}"$/, "  sha256 \"#{ENV.fetch("SHA256")}\"")
  File.write(path, cask)
' "$CASK"
echo "Updated cask to $VERSION ($SHA256)."
