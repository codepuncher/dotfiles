# Git Workflow

Complete guide to branching, pull requests, code review, and deployment.

## Critical Pre-Push Requirements

**BEFORE PUSHING TO GITHUB:**
1. **ALWAYS run lint checks locally** - See [Code Standards](./code-standards.md) for language-specific commands
2. **ALWAYS verify checks pass** - Zero failures allowed
3. **NEVER push without local validation** - CI failures waste time and create noise

## Branch Protection

- **NEVER commit directly to the default branch** (usually `main`, `master`, or `develop`)
- **ALWAYS create a feature branch** for any changes
- **ALWAYS create a Pull Request** for review before merging

---

## Complete Workflow (Order of Operations)

When implementing a feature or fix:

1. **Create feature branch** - If on default branch, create and switch to feature branch first
2. **Push branch immediately** - `git push -u origin <branch>` for visibility
3. **Open draft PR early** - Include implementation plan, links to tickets
4. **Make changes & commit after each phase** - Use conventional commit format
5. **Push after each commit** - Enable real-time review on GitHub
6. **Mark PR as "Ready for Review"** - When all phases complete and tests pass
7. **Address code review feedback** - Validate accuracy, reply in threads, resolve when fixed
8. **Deploy to staging for testing** - `git push origin <branch>:staging --force`
9. **Verify changes on staging** - Test that the fix/feature works correctly
10. **Merge to default branch** - `gh pr checks <pr> --watch && gh pr merge <pr> -m -d --admin`
11. **Production deployment** - Happens automatically when default branch is pushed

**Key points:**
- Always verify on staging BEFORE merging to default branch
- Never merge to default branch without staging verification
- Merging to default branch triggers automatic production deployment

---

## Feature Branch Workflow

When implementing a feature with an implementation plan:

1. **Check current branch** - If on default branch, create and switch to a feature branch first
2. **Create feature branch** with naming based on ticket source:
   - **ClickUp**: `clickup/<task-id>/<description>` (e.g., `clickup/86bzphaee/landing-page-ammends`)
   - **FreshDesk**: `freshdesk/<ticket-id>/<description>` (e.g., `freshdesk/21170/intro-section-image-position`)
   - **GitHub Issues**: `issue/<number>/<description>` (e.g., `issue/123/fix-navigation-bug`)
   - **General** (no ticket): `feature/<description>` or `fix/<description>` (e.g., `feature/add-caching`, `fix/header-spacing`)
3. **Push branch immediately** to GitHub for visibility
4. **Open draft PR early** with:
   - Implementation plan in the description
   - Clear title describing the feature
   - Links to related tickets/documents
5. **Commit after each phase** with conventional commit messages
6. **Push after each commit** for real-time review on GitHub
7. **Update PR description** with progress checkpoints as you go
8. **Mark PR as "Ready for Review"** when all phases complete and tests pass

---

## Commits

- Write clear, descriptive commit messages
- Use conventional commit format when appropriate (feat:, fix:, docs:, test:, refactor:)
- Explain the "why" not just the "what" in commit messages
- Include context about what problem is being solved
- Commit frequently - after each logical phase or component completion
- Push commits regularly so work can be reviewed incrementally

---

## Pull Requests

- Create descriptive PR titles and descriptions
- Include "Overview", "Related Tickets & Documents" sections, "Changes", "Impact", "Testing", "Before/After"
- Prompt user for ClickUp, FreshDesk, GitHub, or Sentry links for the "Related Tickets & Documents" section
- Search for related PRs/issues yourself after asking the user
- Open PRs early as drafts to enable real-time review
- Run linting and tests before pushing

---

## Branch Deployment

- To deploy any branch to an environment: push that branch to the environment branch
  - **Staging deployment**: `git push origin <any-branch>:staging --force`
  - **Production deployment**: Happens automatically when default branch is pushed
- Works for feature branches, fix branches, or any other branch
- This triggers the CD workflow which deploys to the corresponding environment
- Verify changes on the target environment before proceeding

---

## Testing on Remote Environments

- **WP CLI aliases** are configured in `wp-cli.yml` for remote testing:
  - `@staging` - Staging environment
  - `@production` - Production environment
  - **⚠️ WARNING**: Use `@production` with caution. Prefer read-only commands (get, list) over write operations (set, update, delete)
- Use aliases to test WP CLI commands on remote servers:
  - Example: `wp @staging option get home`
  - Example: `wp @staging cli version`
- Always test on staging after deployment to verify fixes work correctly

---

## Code Review

### Getting PR Comments

Use `gh-pr-get-comments` script to retrieve all comments on a PR:
```bash
# Get all comments in pretty format
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number>

# Filter by author (e.g., Copilot bot)
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --author='github-advanced-security[bot]'

# Get unresolved review comments only
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false

# Get JSON output for parsing
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --format=json
```

### Addressing Review Feedback

1. Review all comments from code reviewers and validate their accuracy
2. Discuss false-positives or questionable feedback before making changes
3. Don't just make the minimal change - understand and fix the underlying issue
4. Reply to each comment individually in its thread using `gh-pr-reply-to-thread`:
   ```bash
   # Reply to a review thread (use thread-id from gh-pr-get-comments output)
   ~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr-number> \
     --thread-id='PRRT_kwDOABCDEF' \
     --message='Fixed in commit abc1234'
   
   # Reply and resolve thread in one command
   ~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr-number> \
     --thread-id='PRRT_kwDOABCDEF' \
     --message='Fixed in commit abc1234' \
     --resolve
   
   # Resolve thread without replying (e.g., false positive)
   ~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr-number> \
     --thread-id='PRRT_kwDOABCDEF' \
     --resolve-only
   ```
5. Include commit links when referencing fixes in replies
6. Resolve threads when issues are fixed, leave unresolved if dismissing/rejecting feedback
7. Re-run linting after addressing comments
8. Push changes promptly to unblock merging
9. After addressing all feedback and pushing, request a new review from Copilot:
   ```bash
   gh pr edit <pr-number> --add-reviewer @copilot
   ```

**Important:** Always use the utility scripts (`gh-pr-get-comments` and `gh-pr-reply-to-thread`) instead of raw `gh api` calls for PR comment management.

---

## Merging to Default Branch

- Before merging, ensure the most recent commit was deployed to staging and verified
- Use `gh pr checks <pr-number> --watch --interval 2 && gh pr merge <pr-number> -m -d --admin` to verify CI and merge PRs to the default branch
  - Or use the alias: `gh_check_merge <pr-number> --admin` (the alias handles check-and-merge pattern; add `--admin` flag to bypass branch protection)
  - The `--admin` flag bypasses branch protection rules
  - The `-m -d` flags merge and delete the branch after merging
- **Note**: This is only for merging to the default branch, NOT for deploying to staging

---

## After Pushing

1. Update the PR description with latest changes made
2. Verify CI checks are running successfully
3. Check for any new review comments or feedback
4. If all checks pass, move PR from draft to "Ready for Review" (if applicable)
