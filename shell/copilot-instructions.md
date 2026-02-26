# Copilot CLI Instructions for Itineris Development

## Table of Contents
- [Critical: Lint Checks Before Pushing](#️-critical-always-run-lint-checks-locally-before-pushing)
- [Language & Spelling](#language--spelling)
- [PHP & WordPress Best Practices](#php--wordpress-best-practices)
- [Git Workflow](#git-workflow)
  - [Complete Workflow](#complete-workflow-order-of-operations)
  - [Feature Branch Workflow](#feature-branch-workflow)
  - [Code Review](#code-review)
  - [Merging & Deployment](#merging-to-default-branch)
- [Development Workflow](#development-workflow)
  - [Before Committing](#before-committing)
  - [Testing GitHub Actions](#testing-github-actions-locally)
- [Performance Best Practices](#performance-best-practices)
- [WordPress Specific](#wordpress-specific)
- [Bash Scripting](#bash-scripting)
- [Communication](#communication)
- [Quick Reference](#quick-reference)

---

## ⚠️ CRITICAL: Always Run Lint Checks Locally Before Pushing

**NEVER push to GitHub without running local lint checks first.**

For Bash scripts, ALWAYS run before pushing (see detailed checklist at line 286):
```bash
git diff --check                                    # Check trailing whitespace
shfmt -w script-name && shfmt -d script-name       # Format
shellcheck --severity=style script-name             # Lint
```

For PHP, JavaScript, CSS: see "Before Committing" section (line 269 below) for specific commands.

**Zero tolerance policy**: Fix all issues locally. Do not rely on CI to catch problems.

**When to run lint checks:**
- Ideally: Before committing (catches issues early)
- Mandatory: Before pushing (prevents CI failures)
- Best practice: Set up pre-commit hooks to automate this

---

## Language & Spelling

- **Always use British English** for all code, comments, documentation, commit messages, and communication
- Common British English spellings to use:
  - "optimise" not "optimize"
  - "colour" not "color"
  - "behaviour" not "behavior"
  - "centre" not "center"
  - "licence" (noun) / "license" (verb)
  - "analyse" not "analyze"
- This applies to variable names, function names, comments, strings, and all written content

## PHP & WordPress Best Practices

### Variable Handling

- **NEVER use `global $post`** - Always use `get_post()` instead
- **Always check types properly** - Use `instanceof ClassName` instead of truthy checks
- Import classes with `use` statements at the top of files, not Fully Qualified Names (FQNs) inline

### Code Quality

- **Remove all trailing whitespace** - Code must be clean
- **Follow WordPress Coding Standards** strictly
- Use `printf()` or `sprintf()` for HTML construction instead of string concatenation with `echo`
- Escape all output appropriately:
  - `esc_url()` for URLs
  - `esc_attr()` for HTML attributes
  - `esc_html()` for HTML content
  - Do not mix `esc_xxx` functions with Blade `{{ }}`. Prefer using WordPress functions with unescaped Blade echo `{!! !!}`.
  - INCORRECT: `{{ esc_html($var) }}`
  - CORRECT: `{!! esc_html($var) !!}`
- Add phpcs ignore comments with explanations when escaping is already handled
- Do not use `get_posts` or `get_terms`. Use their related query classes `WP_Query` and `WP_Term_Query`

### Code Style

- Keep lines under 120 characters
- Add trailing commas to multi-line function calls (PHP 8.0+)
- Use descriptive function and variable names to avoid using comments for explanations.
- Use strict types instead of PHPDoc blocks unless required
- Only use PHPDoc blocks if function or variable names are not clear
- Extract duplicate code into helper functions or methods
- Use `PHP_EOL` for line breaks instead of `"\n"` for consistency

### Error Handling

- Always validate JSON decoding with `json_last_error()` and type checks
- Check if resources exist before using them
- Add early returns for guard clauses

### Compiler-Optimised Functions

- Always import internal PHP functions with `use function` at the top of the file
- Common functions to import: `strlen`, `count`, `is_array`, `in_array`, `array_key_exists`, etc.
- This enables compiler optimisations for better performance
- Example: `use function strlen; strlen($str)` instead of `strlen($str)` in namespaced code
- This is a micro-optimisation but matters when functions are called frequently

## Git Workflow

### Critical Pre-Push Requirements

**BEFORE PUSHING TO GITHUB:**
1. **ALWAYS run lint checks locally** - See "Before Committing" section below for specific commands
2. **ALWAYS verify checks pass** - Zero failures allowed
3. **NEVER push without local validation** - CI failures waste time and create noise

### Branch Protection

- **NEVER commit directly to the default branch** (usually `main`, `master`, or `develop`)
- **ALWAYS create a feature branch** for any changes
- **ALWAYS create a Pull Request** for review before merging

### Complete Workflow (Order of Operations)

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

### Feature Branch Workflow

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

### Commits

- Write clear, descriptive commit messages
- Use conventional commit format when appropriate (feat:, fix:, docs:, test:, refactor:)
- Explain the "why" not just the "what" in commit messages
- Include context about what problem is being solved
- Commit frequently - after each logical phase or component completion
- Push commits regularly so work can be reviewed incrementally

### Pull Requests

- Create descriptive PR titles and descriptions
- Include "Overview", "Related Tickets & Documents" sections, "Changes", "Impact", "Testing", "Before/After"
- Prompt user for ClickUp, FreshDesk, GitHub, or Sentry links for the "Related Tickets & Documents" section
- Search for related PRs/issues yourself after asking the user
- Open PRs early as drafts to enable real-time review
- Run linting and tests before pushing

### Branch Deployment

- To deploy any branch to an environment: push that branch to the environment branch
  - **Staging deployment**: `git push origin <any-branch>:staging --force`
  - **Production deployment**: Happens automatically when default branch is pushed
- Works for feature branches, fix branches, or any other branch
- This triggers the CD workflow which deploys to the corresponding environment
- Verify changes on the target environment before proceeding

### Testing on Remote Environments

- **WP CLI aliases** are configured in `wp-cli.yml` for remote testing:
  - `@staging` - Staging environment
  - `@production` - Production environment
  - **⚠️ WARNING**: Use `@production` with caution. Prefer read-only commands (get, list) over write operations (set, update, delete)
- Use aliases to test WP CLI commands on remote servers:
  - Example: `wp @staging option get home`
  - Example: `wp @staging cli version`
- Always test on staging after deployment to verify fixes work correctly

### Code Review

**Getting PR Comments:**
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

**Addressing Review Feedback:**
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

### Merging to Default Branch

- Before merging, ensure the most recent commit was deployed to staging and verified
- Use `gh pr checks <pr-number> --watch --interval 2 && gh pr merge <pr-number> -m -d --admin` to verify CI and merge PRs to the default branch
  - Or use the alias: `gh_check_merge <pr-number> --admin` (the alias handles check-and-merge pattern; add `--admin` flag to bypass branch protection)
  - The `--admin` flag bypasses branch protection rules
  - The `-m -d` flags merge and delete the branch after merging
- **Note**: This is only for merging to the default branch, NOT for deploying to staging

### Deploying to Staging

See the "Branch Deployment" section above for complete deployment instructions.

## Development Workflow

### API Queries

**GitHub PR Comments:**
- **Get comments**: Use `~/Code/misc/itineris-bin/gh-pr-get-comments` to retrieve PR comments
- **Reply to comments**: Use `~/Code/misc/itineris-bin/gh-pr-reply-to-thread` to reply and resolve threads
- See "Code Review" section for detailed usage examples

**Task/Ticket Management:**
- **ClickUp**: Use `~/Code/misc/itineris-bin/clickup-get-task` to query ClickUp tasks
- **FreshDesk**: Use `~/Code/misc/itineris-bin/freshdesk-get-ticket` to query FreshDesk tickets
- These scripts handle authentication and API interaction automatically
- Always use these dedicated scripts instead of making direct API calls

### Accessing Credentials

- Use 1Password CLI (`op` or `op.exe` on Windows/WSL) to retrieve credentials programmatically
- Example: `op item get "Item Name" --vault "Vault Name" --fields username,password`
- Check project documentation for specific vault and item names

### Before Committing

**CRITICAL: ALWAYS run lint checks locally BEFORE committing or pushing. Do not skip this step.**

#### For PHP Changes

1. Run PHP syntax check: `php -l <file>`
2. Run phpcs linting: `./vendor/bin/phpcs --standard=phpcs.xml <file>`
3. Auto-fix with phpcbf if needed: `./vendor/bin/phpcbf --standard=phpcs.xml <file>`

#### For JavaScript/CSS Changes

1. For JS changes, run linter with auto-fix if available:
   ```bash
   # Check package.json for project-specific commands
   npm run lint:js
   # Or if using eslint directly
   npx eslint --fix path/to/file.js
   ```

2. For CSS changes, run linter with auto-fix if available:
   ```bash
   # Check package.json for project-specific commands
   npm run lint:css
   # Or if using stylelint directly
   npx stylelint --fix path/to/file.css
   ```

**Note:** Specific commands vary by project. Check `package.json` scripts section for available lint commands.

#### For Bash Script Changes

**MANDATORY: Run ALL these checks before committing ANY Bash script changes:**

```bash
# 1. Remove trailing whitespace (REQUIRED)
sed -i 's/[[:space:]]*$//' script-name

# Verify no trailing whitespace in staged changes
git diff --check

# 2. Format with shfmt (REQUIRED)
shfmt -w script-name

# Verify formatting is correct
shfmt -d script-name

# 3. Run ShellCheck with CI-equivalent settings (REQUIRED)
# This must match the severity level used in CI (style severity)
shellcheck --format=gcc --severity=style script-name

# Or check all modified scripts in your branch
git diff main --name-only --diff-filter=ACMR | \
  xargs shellcheck --format=gcc --severity=style
```

**Important ShellCheck Notes:**
- Use `--severity=style` to match CI configuration (not `--severity=warning`)
- Some repositories use differential-shellcheck which checks at "style" level
- SC1091 (sourcing external files) and SC2016 (single quotes) may be acceptable depending on context
- **Zero tolerance policy**: If CI will fail, fix it locally first

**MANDATORY Pre-Commit Checklist for Bash Scripts:**
- ✅ Trailing whitespace removed (`git diff --check` shows nothing)
- ✅ Script formatted with shfmt (`shfmt -d script-name` shows no diff)
- ✅ ShellCheck passes at style severity (`shellcheck --severity=style`)
- ✅ All variables use `${VAR}` syntax (not `$VAR`)
- ✅ Script tested manually with `--help` flag (if applicable)
- ✅ Documentation updated (README, etc.)

#### General

1. Verify all tests pass (if applicable)

### Testing GitHub Actions Locally

Before pushing CI workflow changes, test them locally using the [act GitHub CLI extension](https://nektosact.com/installation/gh.html):

```bash
# Install act as a GitHub CLI extension
gh extension install https://github.com/nektos/gh-act

# Test workflows locally
gh act                              # Run all workflows
gh act -W .github/workflows/ci.yml  # Run specific workflow
gh act -j build-test                # Run specific job
gh act pull_request                 # Test PR event
gh act -l                           # List available workflows

# Use larger runner image for better compatibility (includes more tools/packages)
gh act -P ubuntu-latest=catthehacker/ubuntu:full-latest
```

**Benefits:**
- Catch errors before pushing to GitHub
- Iterate faster on CI fixes
- No need to spam PR with failed CI runs
- Test different event types locally

**Limitations:**
- Some features may not work identically (secrets, certain GitHub Actions features)
- Larger runner images can be slow to download first time

### After pushing

1. Update the PR description with latest changes made
2. Verify CI checks are running successfully
3. Check for any new review comments or feedback
4. If all checks pass, move PR from draft to "Ready for Review" (if applicable)

## Performance Best Practices

### Resource Loading

- Use `preload` for critical CSS/JS with `fetchpriority="high"`
- Add `dns-prefetch` and `preconnect` hints for external resources
- Make resource hints conditional - only add when actually needed
- Avoid render-blocking resources where possible

**Example:**
```php
// Only preload hero image on pages that use the hero block
add_action('wp_head', function() {
    if (has_block('acf/hero-banner')) {
        echo '<link rel="preload" as="image" href="' . esc_url(get_template_directory_uri() . '/assets/hero.webp') . '" fetchpriority="high">';
    }
});
```

### Conditional Loading

- Check if blocks/features exist before loading their assets
- Use WordPress's `has_block()` function to detect block usage in content
- Check if scripts are enqueued before adding related resources

**Example:**
```php
// Only load animations script when hero block is present
add_action('wp_enqueue_scripts', function() {
    if (has_block('acf/hero-banner')) {
        wp_enqueue_script('hero-animations', get_template_directory_uri() . '/dist/hero.js', [], '1.0', true);
    }
});
```

## WordPress Specific

### Hook Priorities

- Understand hook execution order (wp_enqueue_scripts before wp_head)
- Use appropriate priorities for different types of operations
- Document why specific priorities are chosen

### Asset Management

- Use proper asset handles and dependencies
- Defer non-critical JavaScript
- Load CSS appropriately (not everything needs to be async)
- Use manifest files for cache-busting built assets

## Communication

- Ask clarifying questions when requirements are ambiguous
- Provide concise explanations (3 sentences or less typically)
- Focus on doing the work, not explaining what you're about to do
- Let the code and commits speak for themselves

## Bash Scripting

### Variable References

- **Always use `${FOO}` syntax** instead of `$FOO` for variable references - provides consistency and safety
- **Use UPPERCASE for all variables** - Itineris standard: Both script-level and local function variables should be SCREAMING_SNAKE_CASE (note: this differs from typical Bash convention of lowercase for local variables)

### Formatting

- **Remove trailing whitespace** - Run `git diff --check` to verify, `sed -i 's/[[:space:]]*$//' <file>` to fix
- **Format with shfmt** - Run `shfmt -w <file>` for consistent indentation (tabs), `shfmt -d <file>` to verify
- **Lint with shellcheck** - Run `shellcheck --severity=style <file>` to match CI severity

See "Before Committing > For Bash Script Changes" section for complete pre-commit checklist.

## Quick Reference

### Common Git Commands
```bash
# Create and push feature branch
git checkout -b clickup/<task-id>/<description>
git push -u origin HEAD

# Open draft PR
gh pr create --draft --fill

# Deploy to staging
git push origin HEAD:staging --force

# Check CI and merge PR
gh pr checks <pr-number> --watch && gh pr merge <pr-number> -m -d --admin
```

### Linting Commands

**Bash:**
```bash
git diff --check                          # Check trailing whitespace
shfmt -w script.sh && shfmt -d script.sh  # Format
shellcheck --severity=style script.sh     # Lint
```

**PHP:**
```bash
php -l file.php                                    # Syntax check
./vendor/bin/phpcs --standard=phpcs.xml file.php   # Lint
./vendor/bin/phpcbf --standard=phpcs.xml file.php  # Auto-fix
```

**JavaScript/CSS:**
```bash
npm run lint:js    # or: npx eslint --fix file.js
npm run lint:css   # or: npx stylelint --fix file.css
```

### WP CLI Remote Testing
```bash
wp @staging option get home      # Test staging
wp @production cache flush       # ⚠️ Use with caution
```

### PR Comment Management
```bash
# Get PR comments
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number>

# Reply and resolve
~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr-number> \
  --thread-id='PRRT_xxx' \
  --message='Fixed in commit abc1234' \
  --resolve
```

### Branch Naming Conventions
- ClickUp: `clickup/<task-id>/<description>`
- FreshDesk: `freshdesk/<ticket-id>/<description>`
- GitHub: `issue/<number>/<description>`
- General: `feature/<description>` or `fix/<description>`
