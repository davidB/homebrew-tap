class TodoappCli < Formula
  desc "Keyboard-first CLI + TUI for tda — capture, organize, and refine tasks, for humans and AI agents"
  homepage "https://github.com/davidB/todoapp"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.7.0/todoapp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8f42a9d6f6ce48a9aec61e1769d98b2001b146ca070444a3955efec6a1ad20dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.7.0/todoapp-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d5c6ca28a3c1b1accff9ce53b9dd1df4107c61b60606250b1b71f91a7667ce3e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/todoapp/releases/download/0.7.0/todoapp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0514839885360af70837c10174865a1574aaa943651b0576a3fc36155d695f4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/todoapp/releases/download/0.7.0/todoapp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6e9c7f7811e21dd12fd2599543a43b956caa0f14ef1a2bb0cb084d24c7d6cbf5"
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
