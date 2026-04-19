from lean_dojo import LeanGitRepo, trace
import subprocess

# get the current git commit hash of your repo
commit = subprocess.check_output(["git", "rev-parse", "HEAD"]).decode().strip()

repo = LeanGitRepo(".", commit)
trace(repo, dst_dir="traced_repo")