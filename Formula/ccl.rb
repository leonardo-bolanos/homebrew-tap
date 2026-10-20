class Ccl < Formula
  include Language::Python::Shebang

  desc "Lists every Claude Code session and jumps to the iTerm2 window running it"
  homepage "https://github.com/leonardo-bolanos/claude-session-switcher"
  url "https://github.com/leonardo-bolanos/claude-session-switcher/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "da3077a2818b330e7358be7b0c5df6d5d0734d9773a23329ab03862916683a14"
  license "MIT"
  head "https://github.com/leonardo-bolanos/claude-session-switcher.git", branch: "master"

  depends_on :macos
  depends_on "python@3.13"

  def install
    bin.install "ccl"
    # Reescribe `#!/usr/bin/env python3` por el Python de Homebrew. Sin esto `ccl` usa el
    # python3 que haya en el PATH: en un Mac sin las Command Line Tools eso es un stub que
    # abre un dialogo de instalacion, y con pyenv delante puede ser cualquier version.
    rewrite_shebang detected_python_shebang, bin/"ccl"
  end

  test do
    assert_match "ccl #{version}", shell_output("#{bin}/ccl --version")

    # En el entorno de test no existe `claude`, y eso tiene que dar un error claro con
    # salida 1 — no un "no hay sesiones activas", que mandaria a diagnosticar otra cosa.
    # Se fija el idioma: sin eso el test hereda el locale de quien lo corra.
    salida = shell_output("CCL_LANG=en #{bin}/ccl --list 2>&1", 1)
    assert_match "claude", salida
  end
end
