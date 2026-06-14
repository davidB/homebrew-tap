class JsonSimpleObfuscator < Formula
  desc "A tool to partially hide json value (using unsecure pseudonimize / obfuscate algo)."
  homepage "https://github.com/davidB/json-simple-obfuscator"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.4.0/json-simple-obfuscator-aarch64-apple-darwin.tar.xz"
      sha256 "521f125c662e83b91130d09263055bb8f6500d50e1ddeb264efbf4716e8a9fe0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.4.0/json-simple-obfuscator-x86_64-apple-darwin.tar.xz"
      sha256 "c93c1a951dfe9f9c98867c4c600d097602b3f3abf6bf232ead770abf9bfc09e8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.4.0/json-simple-obfuscator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "14e2ce745721a030da03539f628cb896bafb9c2bb69c0b219517dc59193fd6ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.4.0/json-simple-obfuscator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bad0d98ec322c8e5b6815f58084b37e09df608e42c1051ad9c2ab77e9684e87d"
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
