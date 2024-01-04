<body>

  <h1>FastGit Tool</h1>

  <p>The FastGit tool has a function that facilitates the execution of Git commands quickly and conveniently. The tool provides a function called "fastgit" that performs the following steps:</p>

  <h2>Fastgit Function</h2>

  <ol>
    <li>
      <strong>Check for the presence of a Git repository:</strong>
      <ul>
        <li>The command checks if you are inside a Git repository or not.</li>
      </ul>
    </li>
    <li>
      <strong>Add changes:</strong>
      <ul>
        <li>If you are inside a Git repository, all staged changes are added using <code>git add .</code></li>
      </ul>
    </li>
    <li>
      <strong>Perform the commit operation:</strong>
      <ul>
        <li><code>git commit -a -m "$1"</code> is executed to commit the changes with the provided message as the commit message.</li>
      </ul>
    </li>
    <li>
      <strong>Push changes:</strong>
      <ul>
        <li><code>git push</code> is executed to push the changes to the specified remote.</li>
      </ul>
    </li>
  </ol>

  <p>The purpose of this function is to simplify and expedite common Git operations so that you can easily execute them using the <code>fastgit</code> command automatically.</p>

  <h2>Installation</h2>

  <h3>Clone</h3>
  <pre><code>git clone https://github.com/2Hasan2/fastgit.git</code></pre>
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

  <h2>New Features</h2>

  <h3>1. Automatic Commit Message</h3>

  <p>If no commit message is provided, the script defaults to using the current date and time as the commit message.</p>

  <h3>2. Customizable Remote and Branch</h3>

  <p>You can specify the remote and branch for pushing changes, providing flexibility in managing repositories.</p>

  <pre><code>fastgit "Commit Message" [remote] [branch]</code></pre>

  <h3>3. Fetch and Rebase</h3>

  <p>The script fetches remote commits before adding and committing local changes. It then rebases your local changes on top of the fetched commits, helping to resolve conflicts if any.</p>

  <h3>4. Loading Spinner Animation</h3>

  <p>The script includes a loading spinner animation during the fetch and rebase operations, providing visual feedback to the user.</p>

</body>