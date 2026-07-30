class ClaudeCodeTokenBar < Formula
  desc "Render Claude Code token usage, limits, cost, and Git state"
  homepage "https://github.com/muzafferkadir/claude-code-token-bar"
  url "https://github.com/muzafferkadir/claude-code-token-bar/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a5bb00114986137bc735371403a297a547d393cc1602e4104ed6cee4d43db788"
  license "MIT"

  depends_on "jq"

  def install
    bin.install "claude-code-token-bar"
  end

  test do
    input = <<~JSON
      {
        "workspace": {"current_dir": "/tmp/project"},
        "cost": {"total_cost_usd": 1.17},
        "rate_limits": {
          "five_hour": {"used_percentage": 36, "resets_at": 0},
          "seven_day": {"used_percentage": 70, "resets_at": 0}
        },
        "model": {"display_name": "Sonnet 4"},
        "context_window": {
          "total_input_tokens": 89000,
          "context_window_size": 1000000
        },
        "effort": {"level": "high"},
        "fast_mode": true
      }
    JSON

    output = pipe_output(bin/"claude-code-token-bar", input)
    plain = output.gsub(/\e\[[0-9;]*m/, "")

    assert_equal(
      "📁project │ 💰$1.17 │ 5h ████░░░░░░36% ⏰0m │ " \
      "7d ███████░░░70% ⏰0m │ Sonnet 4 89k/1.0M high⚡",
      plain,
    )
  end
end
