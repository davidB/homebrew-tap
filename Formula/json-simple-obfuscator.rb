class JsonSimpleObfuscator < Formula
  desc "A tool to partially hide json value (using unsecure pseudonimize / obfuscate algo)."
  homepage "https://github.com/davidB/json-simple-obfuscator"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.4.1/json-simple-obfuscator-aarch64-apple-darwin.tar.xz"
      sha256 "eee8f2cc9002889e3b63ccaf3ef8971f30b1281e7f7a9788b2078f4fe7adb758"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.4.1/json-simple-obfuscator-x86_64-apple-darwin.tar.xz"
      sha256 "5f97ad10e1af3fe79d17f0ff206ea736d020a8d452a0643c2f6368d992f27657"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.4.1/json-simple-obfuscator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49efe79ffde9efe1dc4a2a7039eb376013f16ba467e655ee161155203d79f2ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.4.1/json-simple-obfuscator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d7ac76974d8c8e40a1e1fff64bad83db09f227907824513364ef5c53237d6f78"
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
