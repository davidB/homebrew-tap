class DioxusIconify < Formula
  desc "CLI tool for importing/vendoring icons from [Iconify](https://icon-sets.iconify.design/) (material, lucid, heroicons,....) or from local SVG files in Dioxus projects"
  homepage "https://github.com/davidB/dioxus-iconify"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.1/dioxus-iconify-aarch64-apple-darwin.tar.xz"
      sha256 "c6cedac051a3b2de8d52e7ff08cb8083a654ac29286d950c31e0d36d2546399b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.1/dioxus-iconify-x86_64-apple-darwin.tar.xz"
      sha256 "97eee372a0ef4f8f660dba3823079ba733a784da82e866d0d039fa9b915e3351"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.1/dioxus-iconify-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "458020ed3c76984de6f824d54edb0779a09e69825cfc1d35c7a1b85dd49aa959"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.1/dioxus-iconify-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3058ce3e0bd2ec49288c340bf936398e349de1820c88f509f37d9d799733ccf6"
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
