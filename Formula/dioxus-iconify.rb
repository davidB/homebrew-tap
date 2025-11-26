class DioxusIconify < Formula
  desc "CLI tool for vendoring [Iconify](https://icon-sets.iconify.design/) icons (material, lucid, heroicons,....) in Dioxus projects"
  homepage "https://github.com/davidB/dioxus-iconify"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.0/dioxus-iconify-aarch64-apple-darwin.tar.xz"
      sha256 "7e4b26478feb1be0e139a77a19ea86d9a77f39cb702244c508be58f0ab1ebbe2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.0/dioxus-iconify-x86_64-apple-darwin.tar.xz"
      sha256 "d08203d62df7a8126c09b2eed2b9f3c343ca0c8194c586a7a9a64f658027354b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.0/dioxus-iconify-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41c9eeb2594d9c8477dade82f7d54494bdca6424fd15ba8829fb3080a0718916"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.0/dioxus-iconify-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a367b318b6097d81f520f7ccc1ee770d3358073d45538c6dcf95a4e2cc88a5c0"
    end
  end
  license "CC0-1.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dioxus-iconify" if OS.mac? && Hardware::CPU.arm?
    bin.install "dioxus-iconify" if OS.mac? && Hardware::CPU.intel?
    bin.install "dioxus-iconify" if OS.linux? && Hardware::CPU.arm?
    bin.install "dioxus-iconify" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
