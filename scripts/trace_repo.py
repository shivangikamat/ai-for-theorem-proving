from lean_dojo import LeanGitRepo, trace

repo = LeanGitRepo(
    "https://github.com/shivangikamat/ai-for-theorem-proving",
    "main"
)

trace(repo, dst_dir="traced_repo")