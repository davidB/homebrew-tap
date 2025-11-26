class DioxusIconify < Formula
  desc "CLI tool for vendoring [Iconify](https://icon-sets.iconify.design/) icons (material, lucid, heroicons,....) in Dioxus projects"
  homepage "https://github.com/davidB/dioxus-iconify"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.1/dioxus-iconify-aarch64-apple-darwin.tar.xz"
      sha256 "9d06a5fcd5862f80cce067ed86c10cce2a3a984c78091d587998c637decc178b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.1/dioxus-iconify-x86_64-apple-darwin.tar.xz"
      sha256 "50f332c2794251275dc62f6c4e78d47ff5a22de91cc9aa9f30b32f3e539d67e9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.1/dioxus-iconify-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d46d8d4ef33c8b59271f4738b24f321eeebf4faac8d4ee4bd69573730bef5e81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.1/dioxus-iconify-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "29e4377fbee653d6a4d7f6106b8f6276a8894524e8a35bcd4dc44e5a9ca9e55d"
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
