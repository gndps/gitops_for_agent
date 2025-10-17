Before processing each user request, you should execute the lock_changes.sh script to ensure that all the changes have been pushed to git.
Before executing lock_changes.sh script, you should ensure that all the file containing sensitive data and any other redundant files are added to gitignore of the repo.

The lock_changes.sh script can be installed like this:
```
# Download the script
curl -s https://raw.githubusercontent.com/gndps/gitops_for_agent/main/lock_changes.sh -o lock_changes.sh
# Make it executable
chmod +x lock_changes.sh
# Optional: Move to a directory in your PATH (e.g., /usr/local/bin)
# sudo mv lock_changes.sh /usr/local/bin/
```

The lock_changes.sh script can be used like this:
```
./lock_changes.sh /path/to/your/repo "Optional: Implementing user authentication feature"
```
