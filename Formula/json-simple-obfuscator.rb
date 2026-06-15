class JsonSimpleObfuscator < Formula
  desc "A tool to partially hide json value (using unsecure pseudonimize / obfuscate algo)."
  homepage "https://github.com/davidB/json-simple-obfuscator"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.5.0/json-simple-obfuscator-aarch64-apple-darwin.tar.xz"
      sha256 "8e75ff08aaf8075859665ec29eb6f4690240dd64ee4333cc8e5813e391bb5eab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.5.0/json-simple-obfuscator-x86_64-apple-darwin.tar.xz"
      sha256 "61b0787761b1f8fc2a17d01aacd1ee9a52b423e2819f034d4a30e531b1d2736e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.5.0/json-simple-obfuscator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ef3feb1efad0b7f47a4faecc987b2b61d62ac82af06598053a4208f0e0a6cdae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.5.0/json-simple-obfuscator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "86b020a48886527e451e65214d40843a812c0cd9ce4c948d71a9c968b6f9602e"
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
    bin.install "json-simple-obfuscator" if OS.mac? && Hardware::CPU.arm?
    bin.install "json-simple-obfuscator" if OS.mac? && Hardware::CPU.intel?
    bin.install "json-simple-obfuscator" if OS.linux? && Hardware::CPU.arm?
    bin.install "json-simple-obfuscator" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
