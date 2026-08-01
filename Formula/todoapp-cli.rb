class TodoappCli < Formula
  desc "Keyboard-first CLI + TUI for tda — capture, organize, and refine tasks, for humans and AI agents"
  homepage "https://github.com/davidB/todoapp"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.7.1/todoapp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5dea9b89a796e0f84b011248685d82262ed7490c9f471d9fb3e9a13a6e9f62f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.7.1/todoapp-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e68b131179b2932298944ca7f03d750309d7b0164440d1c81100fb67e08b5657"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.7.1/todoapp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e1b07c35f7c8753f807a5787bae540bb86138d89d2a1db3a5b9e6654979b6631"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.7.1/todoapp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d694a2f8a9ab9500e01197d4a86d8d88e58bd27ee1faf55d640f118a103b513"
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
