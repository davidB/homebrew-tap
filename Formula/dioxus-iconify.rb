class DioxusIconify < Formula
  desc "CLI tool for vendoring [Iconify](https://icon-sets.iconify.design/) icons (material, lucid, heroicons,....) in Dioxus projects"
  homepage "https://github.com/davidB/dioxus-iconify"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.2/dioxus-iconify-aarch64-apple-darwin.tar.xz"
      sha256 "65ab5b456ef90d994c81a3a65b5cbec6e3b36372bfaee251ec73194e067535b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.2/dioxus-iconify-x86_64-apple-darwin.tar.xz"
      sha256 "ec6930e3de74533792cef686fe3dab2975d7fd597bb805f04ea818282287f436"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.2/dioxus-iconify-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aad709875ddd19cfb4bc0581782c4b18c930ea85076b81eb325e04301b0d5f19"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.2.2/dioxus-iconify-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ef5c612d8fb13b7bf9c4c82083ee4eb4194b727919272f8d35f5254d3b1ff4a"
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
