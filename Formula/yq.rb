class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.4.0.tar.gz"
  sha256 "bd87dad46efbe333d0ed2da0b142e429833259d02d6310d97c95704ea0430a83"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa0e24c4577a96caadad725096c3df00867a208fcf29b7f2fc08086084ea530d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5619ac0ef0ad093218c393fc2ca52aea3839a136cc1bbf1b109c71f090a85393"
    sha256 cellar: :any_skip_relocation, catalina:       "d3e295cdef6093bca1e10b4ee734469679c88abe9321743a441174638222f4f7"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    (bash_completion/"yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read(bin/"yq", "shell-completion", "fish")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
