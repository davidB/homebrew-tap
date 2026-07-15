class TodoappCli < Formula
  desc "Keyboard-first CLI + TUI for tda — capture, organize, and refine tasks, for humans and AI agents"
  homepage "https://github.com/davidB/todoapp"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.6.0/todoapp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d056c6c5b7f4bd8cebdbec1ac6ecd55e063b244c79f38a52d2802e55db96935b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.6.0/todoapp-cli-x86_64-apple-darwin.tar.xz"
      sha256 "adf9c1072b3f390206524c7c41467ecab96b387312c96d96a3688c50f236f09a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.6.0/todoapp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cab95fc5847f46c18b68e34e1e2cabedf626802180fbf57b02270c2c2bbc33e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.6.0/todoapp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4630bf84c89d5c56ffd3a503ba23e6ad01ac1ed65e979a58d534003dd1d6259f"
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
