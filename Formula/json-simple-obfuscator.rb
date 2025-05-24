class JsonSimpleObfuscator < Formula
  desc "A tool to partially hide json value (using unsecure pseudonimize / obfuscate algo)."
  homepage "https://github.com/davidB/json-simple-obfuscator"
  version "0.2.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.2.4/json-simple-obfuscator-aarch64-apple-darwin.tar.xz"
    sha256 "6bb585a810e7cebfa583a7dc4df3f12fd352f0d3e66fbe419fb5f3a75d638636"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.2.4/json-simple-obfuscator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bfde8f213226700877ceee397efacdf9269c19a39aa223c054ff007f4ea6b23c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davidB/json-simple-obfuscator/releases/download/0.2.4/json-simple-obfuscator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ae866f574fb19faaa32a3344c1e31c221114ca46b05595e1f129f9640f7a6428"
    end
  end
  license "CC0-1.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
