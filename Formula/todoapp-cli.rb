class TodoappCli < Formula
  desc "Keyboard-free CLI for tda (M3) — JSON output for agents and scripts"
  homepage "https://github.com/davidB/todoapp"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.4.0/todoapp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e7ba87116e13cae4b2f782a71d1c95ea5ac0d689efaa1b9166533ecde4c14fca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.4.0/todoapp-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9eb69c15b6b09d4baae24e0ee58c29aba56867a69814de4ad683b088842b2d6b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.4.0/todoapp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7137451a9de9e0de7e888323dfb30743baa61f021698ce55dfaeeeef46de4276"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.4.0/todoapp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dc0a15ad1aa2baffc46b977776802df70d2983d27d072bc61c5809259f219266"
    end
  end
  license "Apache-2.0"

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
    bin.install "tda" if OS.mac? && Hardware::CPU.arm?
    bin.install "tda" if OS.mac? && Hardware::CPU.intel?
    bin.install "tda" if OS.linux? && Hardware::CPU.arm?
    bin.install "tda" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
