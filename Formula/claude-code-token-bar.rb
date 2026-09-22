class ClaudeCodeTokenBar < Formula
  desc "Render Claude Code token usage, limits, cost, cache warmth, and Git state"
  homepage "https://github.com/muzafferkadir/claude-code-token-bar"
  url "https://github.com/muzafferkadir/claude-code-token-bar/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "56ef3c537ea0c8968f7c41eee59332159d13c5071d0635cb49e8f1d3e624b705"
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
