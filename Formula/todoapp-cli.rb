class TodoappCli < Formula
  desc "Keyboard-first CLI + TUI for tda — capture, organize, and refine tasks, for humans and AI agents"
  homepage "https://github.com/davidB/todoapp"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.4.1/todoapp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "95282fdc96e292b16504f71f458459b635a3fa06746d19a0fb23478821454f0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.4.1/todoapp-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f5a49b1c475b5733f3ddd24a545f5ad8f71c6677c7c7434493fb2ea672c39981"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.4.1/todoapp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c0209dcd22fc2ba0560796f06f262e46f32c966f2bb836d4ef5e04f93cdcfb9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.4.1/todoapp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c2c23e16885f8a9552b4f45a44b0ccd2e054af0e66eee27dbea29dcee4d6ddec"
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
