class TodoappCli < Formula
  desc "Keyboard-free CLI for tda (M3) — JSON output for agents and scripts"
  homepage "https://github.com/davidB/todoapp"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.3.0/todoapp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3cfd7a177def44a53ebd41cd36b7699d6a18ec16de7e84cb824e9743cac0d962"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.3.0/todoapp-cli-x86_64-apple-darwin.tar.xz"
      sha256 "03ac3147f3bd9e759cc24282c6185fb65160aa7522819dbac6106354be1ca352"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.3.0/todoapp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e10fd92c69f7b5bafb9a67c1e49d43877440699de5353b78c688029799af35a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.3.0/todoapp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4bf31a0fee53e0a3a1ea01c0664f02e99dcd068189742d657f81eb622d9e3c8b"
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
