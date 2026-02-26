# Copilot CLI Instructions for Itineris Development

## 📋 Table of Contents

**Critical Rules (Read First):**
- [Scope & When These Apply](#scope--when-these-apply)
- [Critical: Lint Checks](#️-critical-always-run-lint-checks-locally-before-pushing)
- [What NOT to Do](#-what-not-to-do)
- [Common Mistakes](#-common-mistakes-to-avoid)

**Workflows & Patterns:**
- [Quick Reference Commands](#quick-reference-commands) - Copy-paste ready commands
- [Common Task Patterns](#common-task-patterns) - Full workflow examples
- [Git Workflow](#git-workflow) - Branching, PRs, deployment

**Code Standards:**
- [Language & Spelling](#language--spelling)
- [PHP & WordPress](#php--wordpress-best-practices)
- [JavaScript & CSS](#javascriptcss-changes)
- [Bash Scripting](#bash-scripting-standards)
- [Before Committing](#before-committing) - Pre-commit checklists

**Reference:**
- [Performance Best Practices](#performance-best-practices)
- [WordPress Specific](#wordpress-specific)
- [Project Information](#project-information)

---

## Scope & When These Apply

**These instructions apply to:**
- ✅ All Itineris client projects (WordPress sites in `~/Code/wordpress/`)
- ✅ Internal Itineris tools and utilities
- ✅ Projects using Itineris workflows (ClickUp, FreshDesk, custom scripts)

**These instructions may NOT apply to:**
- ❌ Personal projects outside `~/Code/wordpress/`
- ❌ Open source contributions to non-Itineris projects
- ❌ Non-WordPress projects (ignore PHP/WordPress sections)

**Project structure:**
- WordPress projects: `~/Code/wordpress/<client-name>/bedrock`
- Utilities and scripts: `~/Code/misc/itineris-bin/`
- Default branch: Usually `main`, `master`, or `develop` (check with `git symbolic-ref refs/remotes/origin/HEAD`)

---

## ⚠️ CRITICAL: Always Run Lint Checks Locally Before Pushing

**NEVER push to GitHub without running local lint checks first.**

For Bash scripts, ALWAYS run before pushing:
```bash
# 1. Check and remove trailing whitespace
git diff --check && sed -i 's/[[:space:]]*$//' script-name

# 2. Format with shfmt
shfmt -w script-name && shfmt -d script-name

# 3. Run ShellCheck at style severity (matches CI)
shellcheck --format=gcc --severity=style script-name
```

For PHP, JavaScript, CSS: see "Before Committing" section (line 269 below) for specific commands.

**Zero tolerance policy**: Fix all issues locally. Do not rely on CI to catch problems.

**When to run lint checks:**
- Ideally: Before committing (catches issues early)
- Mandatory: Before pushing (prevents CI failures)
- Best practice: Set up pre-commit hooks to automate this

---

## ❌ What NOT to Do

**NEVER do these things - they violate core workflows:**

### Git & Deployment
- ❌ **NEVER commit directly to the default branch** - Always create a feature branch first
- ❌ **NEVER merge without staging verification** - Deploy to staging and test before merging
- ❌ **NEVER push without running lints locally** - Zero tolerance for CI failures
- ❌ **NEVER force push to default branch** - Can break production

### Code Review & PRs
- ❌ **NEVER use `gh api` directly for PR comments** - Always use `~/Code/misc/itineris-bin/gh-pr-get-comments` and `gh-pr-reply-to-thread`
- ❌ **NEVER use combined short flags** - Use `-m -d` not `-md` (gh doesn't support combined short flags)
- ❌ **NEVER skip staging deployment** - Always verify changes on staging before merging

### Code Standards
- ❌ **NEVER use `global $post`** in PHP - Use `get_post()` instead
- ❌ **NEVER use `get_posts()` or `get_terms()`** - Use `WP_Query` and `WP_Term_Query` instead
- ❌ **NEVER mix escaping with Blade `{{ }}`** - Use `{!! esc_html($var) !!}` not `{{ esc_html($var) }}`
- ❌ **NEVER use American English** - Use British English (colour, optimise, behaviour, etc.)

### Testing & Production
- ❌ **NEVER test on production first** - Always test on staging
- ❌ **NEVER use `@production` for write operations** without explicit approval - Prefer read-only commands
- ❌ **NEVER skip the CI checks** - Wait for `gh pr checks` to pass before merging

---

## 🚨 Common Mistakes to Avoid

**These are mistakes Copilot has made in the past - don't repeat them:**

### 1. Committing Directly to Default Branch
**Mistake:** Making changes and committing without checking current branch  
**Fix:** Always check `git branch` and create feature branch if on default branch
```bash
# Check current branch first
git branch --show-current

# If on default branch (main/master/develop), create feature branch
git checkout -b clickup/task-id/description
```

### 2. Using Wrong gh Command Flags
**Mistake:** Using `gh pr merge <pr> -md` (combined short flags)  
**Fix:** Use separate flags: `gh pr merge <pr> -m -d`

### 3. Forgetting to Run Lints Locally
**Mistake:** Pushing code and letting CI catch linting errors  
**Fix:** ALWAYS run lints before pushing (see "Before Committing" section)

### 4. Using `gh api` Instead of Custom Scripts
**Mistake:** Using `gh api graphql -f query='...'` for PR comments  
**Fix:** Use `~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number>`

### 5. Merging Without Staging Verification
**Mistake:** Merging PR after CI passes without testing on staging  
**Fix:** Always deploy to staging first: `git push origin <branch>:staging --force`, then test

### 6. Using Wrong ShellCheck Severity
**Mistake:** Running `shellcheck script.sh` (defaults to warning level)  
**Fix:** Use `shellcheck --severity=style script.sh` to match CI

### 7. Creating Multi-File Instructions
**Mistake:** Splitting instructions into multiple linked files  
**Fix:** Keep everything in ONE file - Copilot CLI doesn't follow relative links

### 8. Forgetting Branch Naming Convention
**Mistake:** Using generic names like `feature/fix` without ticket reference  
**Fix:** Include ticket source: `clickup/<task-id>/description` or `freshdesk/<ticket-id>/description`

---

## Common Task Patterns

**Full workflow examples for common scenarios:**

### Pattern 1: Fix a Bug from FreshDesk Ticket

**Scenario:** You receive a FreshDesk ticket #21170 reporting broken image positioning on the intro section.

**Complete workflow:**
```bash
# 1. Check current branch and create feature branch
git branch --show-current
git checkout -b freshdesk/21170/intro-section-image-position

# 2. Push branch immediately for visibility
git push -u origin HEAD

# 3. Open draft PR early
gh pr create --draft --fill
# In description: Add ticket link, describe issue, outline fix approach

# 4. Make the fix, test locally
# ... edit files ...

# 5. Run lints before committing
./vendor/bin/phpcs --standard=phpcs.xml path/to/changed-file.php
./vendor/bin/phpcbf --standard=phpcs.xml path/to/changed-file.php  # auto-fix if needed
npm run lint:css  # if CSS was changed

# 6. Commit with clear message
git add -A
git commit -m "fix: correct intro section image positioning

Image was overlapping text on mobile due to incorrect z-index
and positioning. Updated CSS to use relative positioning with
proper stacking context.

Fixes FreshDesk ticket #21170"

# 7. Push commit
git push

# 8. Deploy to staging and test
git push origin HEAD:staging --force
# Test on staging environment
wp @staging cache flush
# Visit staging site and verify fix

# 9. Mark PR as ready for review
gh pr ready

# 10. Wait for CI and merge
gh pr checks <pr-number> --watch && gh pr merge <pr-number> -m -d --admin
```

### Pattern 2: Address PR Code Review Comments

**Scenario:** You have a PR with 10 unresolved review comments from GitHub Advanced Security bot and human reviewers.

**Complete workflow:**
```bash
# 1. Get all unresolved comments (note the thread IDs)
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false

# 2. For each comment, fix the issue
# ... make code changes ...

# 3. Run lints after each fix
./vendor/bin/phpcs --standard=phpcs.xml file.php

# 4. Commit the fix
git commit -am "fix: address security vulnerability in user input handling

Added proper sanitization and validation for user-submitted data.
Addresses review comment thread PRRT_xxx."

# 5. Reply to the specific thread and resolve it
~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr-number> \
  --thread-id='PRRT_xxx' \
  --message='Fixed in commit abc1234' \
  --resolve

# 6. Repeat steps 2-5 for each comment

# 7. After all comments addressed, push all commits
git push

# 8. Request new review
gh pr edit <pr-number> --add-reviewer @copilot

# 9. Deploy to staging to verify all fixes
git push origin HEAD:staging --force

# 10. After re-approval, merge
gh pr checks <pr-number> --watch && gh pr merge <pr-number> -m -d --admin
```

### Pattern 3: Implement New Feature from ClickUp

**Scenario:** ClickUp task 86bzphaee asks for landing page amendments - new hero section with CTA.

**Complete workflow:**
```bash
# 1. Create feature branch
git checkout -b clickup/86bzphaee/landing-page-amendments

# 2. Push and create draft PR with implementation plan
git push -u origin HEAD
gh pr create --draft --fill
# Add in PR description:
# - Link to ClickUp task
# - Implementation plan with phases
# - Expected timeline
# - Screenshots/mockups if available

# 3. Implement in phases, committing after each
# Phase 1: Create hero block
# ... create ACF fields, templates ...
git commit -am "feat: add hero section ACF block"
git push

# Phase 2: Style the hero
# ... add CSS ...
git commit -am "style: add hero section styles with mobile responsive layout"
git push

# Phase 3: Add CTA functionality
# ... add JS if needed ...
git commit -am "feat: add CTA tracking and form handling"
git push

# 4. Run all lints before marking ready
./vendor/bin/phpcs --standard=phpcs.xml web/app/themes/*/
npm run lint:js
npm run lint:css

# 5. Deploy to staging for client review
git push origin HEAD:staging --force

# 6. Update PR description with:
# - Before/After screenshots
# - Testing notes
# - Staging URL for review

# 7. Mark ready and get review
gh pr ready

# 8. After approval, merge
gh pr checks <pr-number> --watch && gh pr merge <pr-number> -m -d --admin

# 9. Verify production deployment
# (happens automatically when default branch is pushed)
```

### Pattern 4: Emergency Hotfix

**Scenario:** Production site is down, need immediate fix.

**Fast workflow:**
```bash
# 1. Create hotfix branch from default
git checkout main  # or master/develop
git pull
git checkout -b hotfix/critical-issue-description

# 2. Make minimal fix only
# ... edit only what's necessary ...

# 3. Test locally FIRST
# ... verify fix works ...

# 4. Quick lint check
./vendor/bin/phpcs --standard=phpcs.xml changed-file.php

# 5. Commit and push
git commit -am "hotfix: resolve critical production issue

[Describe issue and fix]"
git push -u origin HEAD

# 6. Create PR and deploy to staging IMMEDIATELY
gh pr create --fill
git push origin HEAD:staging --force

# 7. Test on staging quickly
wp @staging cache flush
# Verify fix works

# 8. If verified, merge immediately
gh pr merge <pr-number> -m -d --admin

# 9. Monitor production
# Watch logs, verify issue is resolved
```

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
1. **ALWAYS run lint checks locally** - See "Before Committing" section for language-specific commands
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

### After Pushing

1. Update the PR description with latest changes made
2. Verify CI checks are running successfully
3. Check for any new review comments or feedback
4. If all checks pass, move PR from draft to "Ready for Review" (if applicable)

## Before Committing

**CRITICAL: ALWAYS run lint checks locally BEFORE committing or pushing. Do not skip this step.**

### PHP Changes

1. Run PHP syntax check: `php -l <file>`
2. Run phpcs linting: `./vendor/bin/phpcs --standard=phpcs.xml <file>`
3. Auto-fix with phpcbf if needed: `./vendor/bin/phpcbf --standard=phpcs.xml <file>`

### JavaScript/CSS Changes

1. For JS changes:
   ```bash
   # Check package.json for project-specific commands
   npm run lint:js
   # Or if using eslint directly
   npx eslint --fix path/to/file.js
   ```

2. For CSS changes:
   ```bash
   # Check package.json for project-specific commands
   npm run lint:css
   # Or if using stylelint directly
   npx stylelint --fix path/to/file.css
   ```

**Note:** Specific commands vary by project. Check `package.json` scripts section for available lint commands.

### Bash Script Changes

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

### General

1. Verify all tests pass (if applicable)

## Bash Scripting Standards

### Variable References

- **Always use `${FOO}` syntax** instead of `$FOO` for variable references - provides consistency and safety
- **Use UPPERCASE for all variables** - Itineris standard: Both script-level and local function variables should be SCREAMING_SNAKE_CASE (note: this differs from typical Bash convention of lowercase for local variables)

### Formatting Requirements

- **Remove trailing whitespace** - Run `git diff --check` to verify, `sed -i 's/[[:space:]]*$//' <file>` to fix
- **Format with shfmt** - Run `shfmt -w <file>` for consistent indentation (tabs), `shfmt -d <file>` to verify
- **Lint with shellcheck** - Run `shellcheck --severity=style <file>` to match CI severity

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

## Quick Reference Commands

### Git Commands

```bash
# Create feature branch based on ticket source
git checkout -b clickup/<task-id>/<description>      # ClickUp
git checkout -b freshdesk/<ticket-id>/<description>  # FreshDesk
git checkout -b issue/<number>/<description>         # GitHub Issues
git checkout -b feature/<description>                # No ticket

# Push and track
git push -u origin HEAD

# Open draft PR
gh pr create --draft --fill

# Check CI status and merge
gh pr checks <pr-number> --watch && gh pr merge <pr-number> -m -d --admin

# Or use alias
gh_check_merge <pr-number> --admin

# Deploy any branch to staging
git push origin <branch-name>:staging --force
```

### Linting Commands

**Bash Scripts:**
```bash
git diff --check                           # Check trailing whitespace
sed -i 's/[[:space:]]*$//' script.sh       # Remove trailing whitespace
shfmt -w script.sh                         # Format
shfmt -d script.sh                         # Verify formatting
shellcheck --severity=style script.sh      # Lint
```

**PHP:**
```bash
php -l file.php                                    # Syntax check
./vendor/bin/phpcs --standard=phpcs.xml file.php   # Lint
./vendor/bin/phpcbf --standard=phpcs.xml file.php  # Auto-fix
```

**JavaScript:**
```bash
npm run lint:js                  # Project-specific (check package.json)
npx eslint --fix path/to/file.js # Or using eslint directly
```

**CSS:**
```bash
npm run lint:css                     # Project-specific (check package.json)
npx stylelint --fix path/to/file.css # Or using stylelint directly
```

### WP CLI Remote Testing

```bash
# Staging environment
wp @staging option get home
wp @staging cli version
wp @staging cache flush

# Production environment (⚠️ USE WITH CAUTION)
wp @production option get home     # Read-only: safe
wp @production cache flush         # Write operation: be careful
```

**Warning:** Prefer read-only commands (get, list) on @production. Write operations (set, update, delete) should be rare and deliberate.

### PR Comment Management

**Workflow:** Get comments first (to find thread IDs), then reply/resolve using those IDs.

**Get Comments:**
```bash
# Step 1: Get all comments (includes thread IDs in output)
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number>

# Filter by author
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> \
  --author='github-advanced-security[bot]'

# Unresolved comments only
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false

# JSON output
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --format=json
```

**Reply to Comments:**
```bash
# Step 2: Reply using thread-id from step 1
~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr-number> \
  --thread-id='PRRT_xxx' \
  --message='Fixed in commit abc1234'

# Reply and resolve
~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr-number> \
  --thread-id='PRRT_kwDOABCDEF' \
  --message='Fixed in commit abc1234' \
  --resolve

# Resolve without reply
~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr-number> \
  --thread-id='PRRT_kwDOABCDEF' \
  --resolve-only

# Request new review after fixes
gh pr edit <pr-number> --add-reviewer @copilot
```

### Task/Ticket Management

```bash
# ClickUp
~/Code/misc/itineris-bin/clickup-get-task <task-id>

# FreshDesk
~/Code/misc/itineris-bin/freshdesk-get-ticket <ticket-id>
```

### GitHub Actions Testing

```bash
# Install act (one-time)
gh extension install https://github.com/nektos/gh-act

# Test workflows locally
gh act                              # Run all workflows
gh act -W .github/workflows/ci.yml  # Specific workflow
gh act -j build-test                # Specific job
gh act pull_request                 # Test PR event
gh act -l                           # List workflows

# Use larger runner image
gh act -P ubuntu-latest=catthehacker/ubuntu:full-latest
```

### Credentials Access

```bash
# 1Password CLI
op item get "Item Name" --vault "Vault Name" --fields username,password

# Or on Windows/WSL
op.exe item get "Item Name" --vault "Vault Name" --fields username,password
```

### Branch Naming Conventions

| Ticket Source | Format | Example |
|--------------|--------|---------|
| ClickUp | `clickup/<task-id>/<description>` | `clickup/86bzphaee/landing-page-ammends` |
| FreshDesk | `freshdesk/<ticket-id>/<description>` | `freshdesk/21170/intro-section-image-position` |
| GitHub Issues | `issue/<number>/<description>` | `issue/123/fix-navigation-bug` |
| No ticket | `feature/<description>` or `fix/<description>` | `feature/add-caching`, `fix/header-spacing` |

---

## Project Information

**Project locations:**
- WordPress projects: `~/Code/wordpress/<client-name>/bedrock`
- Utility scripts: `~/Code/misc/itineris-bin/`

**Common default branches:**
- Usually `main`, `master`, or `develop`
- Check with: `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`

**Environments:**
- **Staging:** Accessed via `@staging` WP CLI alias, deployed by pushing to `staging` branch
- **Production:** Deployed automatically when default branch is updated

**CI/CD:**
- GitHub Actions runs on all PRs
- Tests include: PHPUnit, PHPCS, ShellCheck, ESLint, Stylelint (varies by project)
- Must pass before merging

**Key tools:**
- WP CLI with remote aliases configured in `wp-cli.yml`
- Custom PR management scripts in `~/Code/misc/itineris-bin/`
- 1Password CLI for credentials (`op` command)
- GitHub Actions local testing with `act` (`gh act`)

**Support:**
- ClickUp for task management: `~/Code/misc/itineris-bin/clickup-get-task <id>`
- FreshDesk for support tickets: `~/Code/misc/itineris-bin/freshdesk-get-ticket <id>`
- Sentry for error tracking (check project documentation for URL)

**Credentials:**
- Stored in 1Password, accessed via CLI: `op item get "Item Name" --vault "Vault Name"`
- Never commit credentials to repos
