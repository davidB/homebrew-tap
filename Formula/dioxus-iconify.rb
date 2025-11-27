class DioxusIconify < Formula
  desc "CLI tool for vendoring [Iconify](https://icon-sets.iconify.design/) icons (material, lucid, heroicons,....) in Dioxus projects"
  homepage "https://github.com/davidB/dioxus-iconify"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.3.0/dioxus-iconify-aarch64-apple-darwin.tar.xz"
      sha256 "2f0675f6d0da611df0fd7f00a658bac24f90bbdc372493fdcc082300faaead66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.3.0/dioxus-iconify-x86_64-apple-darwin.tar.xz"
      sha256 "1749baa0bea2b3c3f3286f3a9df4835d992460827a211df5c326a983182b2e88"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.3.0/dioxus-iconify-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "99f2da5e2876ec7d324a3f1a017d9227b89a25b07c53e65230ca3690e8cb9cc1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.3.0/dioxus-iconify-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51847f3b8bb57c38bd15bb6fe6d707e860b02548e252c34a9c3c12ebe64cca57"
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
