# GitOps for Agent

A collection of git scripts for software development agents like manus, claude, codex etc can use to predictably manage the repo using git

## Lock Changes

This is a bash script to "lock changes" in a Git repository. It's designed for AI agents (like Manus) to commit and push ongoing changes to GitHub before starting a new task. This ensures a clean state for each change request.

The script:
- Verifies the provided folder is a valid Git repository.
- Checks for a valid remote (e.g., `origin`).
- Stages all changes, commits them (with an optional custom message or a random timestamped one), and pushes to the remote `main` branch.
- For the very first run (no commits yet and no remote set): Skips the commit/push and prints a message indicating setup is needed. The next lock will handle the initial commit.

## Requirements
- Git installed on the system.
- GitHub SSH keys configured for seamless pushes (as per your setup).
- `openssl` for random string generation (fallback to `$RANDOM` if unavailable).
- Repository branch assumed to be `main` (edit script if using another, e.g., `master`).

## Installation
Install the script directly from GitHub using bash (no cloning required):

```bash
# Download the script
curl -s https://raw.githubusercontent.com/gndps/gitops_for_agent/main/lock_changes.sh -o lock_changes.sh

# Make it executable
chmod +x lock_changes.sh

# Optional: Move to a directory in your PATH (e.g., /usr/local/bin)
# sudo mv lock_changes.sh /usr/local/bin/
```

To update the script later:
```bash
curl -s https://raw.githubusercontent.com/gndps/gitops_for_agent/main/lock_changes.sh -o lock_changes.sh
```

## Usage
Trigger the script from your AI agent (e.g., Manus) by passing the repository folder path. Optionally pass a relevant commit message for the upcoming change.

```bash
./lock_changes.sh /path/to/your/repo "Optional: Implementing user authentication feature"
```

### Example Outputs
- **Normal run with changes:**
  ```
  Changes locked, committed, and pushed to remote with message: 'Implementing user authentication feature'
  ```

- **No changes:**
  ```
  No changes detected in '/path/to/your/repo'. Nothing to lock.
  ```

- **Initial setup (no commits, no remote):**
  ```
  Initial setup detected: Repository has no commits and no remote configured.
  Skipping commit and push. Lock changes will be performed before the next change.
  Consider setting up remote with: git remote add origin <your-repo-url>
  ```

- **Has commits but no remote:**
  ```
  Warning: No remote configured. Changes committed locally but not pushed.
  Changes locked locally with message: 'Lock changes - a1b2c3d4 - 2025-10-17 14:30:45'
  ```

### Integration with Manus Agent
- Before each new change request, invoke: `./lock_changes.sh /path/to/repo "About to implement: [brief description]"`
- If it's the first run on a fresh repo, the agent should handle GitHub repo creation/SSH setup externally, then call the script again for the initial commit.
- Ensure the agent's virtual machine has the script in its PATH or provide the full path.

## Troubleshooting
- **Push fails:** Verify SSH keys with `ssh -T git@github.com` and ensure the remote is set (`git remote -v`).
- **Branch mismatch:** Edit `git push origin main` in the script to match your default branch.
- **Permissions:** Run `chmod +x lock_changes.sh` if execution is denied.
- **No openssl:** The script falls back to `$RANDOM` for the random string.

## License
MIT License – feel free to use and modify.

For issues or contributions, open a pull request on [GitHub](https://github.com/gndps/gitops_for_agent).
