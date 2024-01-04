# FastGit Tool

The FastGit tool has a function that facilitates the execution of Git commands quickly and conveniently. The tool provides a function called "fastgit" that performs the following steps:

## Fastgit Function

1. **Check for the presence of a Git repository:**
   - The command checks if you are inside a Git repository or not.

2. **Add changes:**
   - If you are inside a Git repository, all staged changes are added using `git add .`

3. **Perform the commit operation:**
   - `git commit -a -m "$1"` is executed to commit the changes with the provided message as the commit message.

4. **Push changes:**
   - `git push` is executed to push the changes to the specified remote.

The purpose of this function is to simplify and expedite common Git operations so that you can easily execute them using the `fastgit` command automatically.

<body>

  <h2>Installation</h2>

  <h3>Clone</h3>
  <pre><code>git clone https://github.com/0xHemaSallam/fastgit.git</code></pre>
  <pre><code>cd fastgit</code></pre>

  <h3>Bash</h3>
  <pre><code>./install-fastgit.sh</code></pre>

  <h3>Zsh</h3>
  <pre><code>zsh install-fastgit.sh</code></pre>

  <h2>Using FastGit</h2>

  <p>To utilize the <code>fastgit</code> function, follow these simple steps:</p>

  <h3>1. Execute FastGit:</h3>

  <p>After installation, you can use the <code>fastgit</code> function by providing a commit message. For example:</p>

  <pre><code>fastgit "My commit message"</code></pre>

  <h2>Removal</h2>
  
  <pre><code>cd fastgit</code></pre>
  
  <h3>Bash</h3>
  <pre><code>./remove-fastgit.sh</code></pre>
  <pre><code>source ~/.bashrc</code></pre>
  
  <h3>Zsh</h3>
  <pre><code>zsh remove-fastgit.sh</code></pre>
  <pre><code>source ~/.zshrc</code></pre>
</body>


## New Features

### 1. Automatic Commit Message

If no commit message is provided, the script defaults to using the current date and time as the commit message.

### 2. Customizable Remote and Branch

You can specify the remote and branch for pushing changes, providing flexibility in managing repositories.

```bash
fastgit "Commit Message" [remote] [branch]
```

### 3. Fetch and Rebase

The script fetches remote commits before adding and committing local changes. It then rebases your local changes on top of the fetched commits, helping to resolve conflicts if any.

### 4. Loading Spinner Animation

The script includes a loading spinner animation during the fetch and rebase operations, providing visual feedback to the user.
