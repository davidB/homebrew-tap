class JsonSimpleObfuscator < Formula
  desc "A tool to partially hide json value (using unsecure pseudonimize / obfuscate algo)."
  homepage "https://github.com/davidB/json-simple-obfuscator"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.5.1/json-simple-obfuscator-aarch64-apple-darwin.tar.xz"
      sha256 "39fa55d27fb787b1a037f8834c590a0c1c1d4dfee3534fff25de786e27b26278"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.5.1/json-simple-obfuscator-x86_64-apple-darwin.tar.xz"
      sha256 "6a9b7ff8ae5b21ca913fbb01a5537c8417dfca973211c63abc2a253f12d00dc2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.5.1/json-simple-obfuscator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "141da2e7e607098187ab2459564e54e50cf0c6d176867d37358cf26728c7b62d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.5.1/json-simple-obfuscator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0355315ebb3016979f944c6512e3b394d0343d10cd5bdc3c29e44058f4326e1b"
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
