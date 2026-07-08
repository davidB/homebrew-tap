class TodoappCli < Formula
  desc "Keyboard-free CLI for tda (M3) — JSON output for agents and scripts"
  homepage "https://github.com/davidB/todoapp"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.2.0/todoapp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "098844891c3c76d91406ad3f6376f6f392fcab466a011c8032fbe1a2726bf8b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.2.0/todoapp-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ea10be54b5dc73f9d421408c75c1a7ae114e07e0d4e93766db479b49363b08eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.2.0/todoapp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4a721fd5daee86ce294ba14ae76d12083acdec416776300d6636773b5ff613c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.2.0/todoapp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "98a015444a01495b9ba3cd36faa77ec922861a70ea23e475832d6bd6ad4e12be"
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
