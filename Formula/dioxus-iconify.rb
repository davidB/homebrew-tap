class DioxusIconify < Formula
  desc "CLI tool for vendoring [Iconify](https://icon-sets.iconify.design/) icons (material, lucid, heroicons,....) in Dioxus projects"
  homepage "https://github.com/davidB/dioxus-iconify"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.0/dioxus-iconify-aarch64-apple-darwin.tar.xz"
      sha256 "df790849ec4d270a8a83252f873356423ed51dfa442587a94baa01e716a8d221"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.0/dioxus-iconify-x86_64-apple-darwin.tar.xz"
      sha256 "ded65f7e65dc3b4aa1f0314390489718b0aa3fe9feee2f2b8964b8adda370f8a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.0/dioxus-iconify-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0daf3727176acb7b6691dc21081fd672b39a352395974b0739f3de40204a652a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/dioxus-iconify/releases/download/0.4.0/dioxus-iconify-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a00c065c1b3e5ee816c72da202276abc42acf88e5aca6e1ff96814746dca88c"
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
