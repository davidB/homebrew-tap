class TodoappCli < Formula
  desc "Keyboard-first CLI + TUI for tda — capture, organize, and refine tasks, for humans and AI agents"
  homepage "https://github.com/davidB/todoapp"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.7.2/todoapp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2579820ca7702206fcc4d4d8a63b3123b3e9691d0262632c55156f0154a8ef61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.7.2/todoapp-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e5f075eeed16f40bf86ea000c9227f1140fd737aaa3652fab495229f8175e3c2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.7.2/todoapp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "565b743c881c4f16c59691b58be6fe714c2c5f3b6d85593a909a90e039562fcd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.7.2/todoapp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "91905eb4c69b6ac599d25c7c18d0745d27d9b3f103b8e88891fae55c09257c98"
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
