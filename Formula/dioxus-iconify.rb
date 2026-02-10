class DioxusIconify < Formula
  desc "CLI tool for importing/vendoring icons from [Iconify](https://icon-sets.iconify.design/) (material, lucid, heroicons,....) or from local SVG files in Dioxus projects"
  homepage "https://github.com/davidB/dioxus-iconify"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.2/dioxus-iconify-aarch64-apple-darwin.tar.xz"
      sha256 "e9ffc94c464f5d94f84426bd6e007a1dc835526b8dfb4be0d57f1554a700a7ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.2/dioxus-iconify-x86_64-apple-darwin.tar.xz"
      sha256 "a731ff289ceb2bae2aaf4f3f36f46b8ab44a4961577c1cad417bbff46196d1b5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.2/dioxus-iconify-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "496a338907b58639a23421424575d0bcccf0df5fc8e3272ed759ea81b9f8d26d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.2/dioxus-iconify-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "357a7b254e34676e1c339ceaa39a8673ed7a2ba3743bf6afad26bd4d0095bc25"
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
