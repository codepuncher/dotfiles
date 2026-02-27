# Copilot CLI Instructions for Itineris Development

## 📋 Table of Contents

**Critical Rules (Read First):**
- [Scope & When These Apply](#scope--when-these-apply)
- [Communication Guidelines](#communication-guidelines) - When to ask vs. proceed
- [Critical: Lint Checks](#️-critical-always-run-lint-checks-locally-before-pushing)
- [What NOT to Do](#-what-not-to-do)
- [Common Mistakes](#-common-mistakes-to-avoid)

**Workflows & Patterns:**
- [Quick Reference Commands](#quick-reference-commands) - Copy-paste ready commands
- [Common Task Patterns](#common-task-patterns) - Full workflow examples
- [Git Workflow](#git-workflow) - Branching, PRs, deployment, conflicts

**Code Standards:**
- [Language & Spelling](#language--spelling)
- [PHP & WordPress](#php--wordpress-best-practices) - Security included
- [JavaScript & CSS](#javascriptcss-changes)
- [Bash Scripting](#bash-scripting-standards)
- [Before Committing](#before-committing) - Pre-commit checklists

**Operations & Troubleshooting:**
- [Database Operations](#database-operations) - Migrations, backups, safety
- [Rollback Procedures](#rollback-procedures) - Emergency recovery
- [Troubleshooting](#troubleshooting) - Common issues and solutions

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

## Working with Tickets and Tasks

**When given a ticket/task URL or ID, use the appropriate script:**

### FreshDesk Tickets
**URLs:** `https://itineris.freshdesk.com/a/tickets/<ticket-id>` or `https://itineris.freshdesk.com/helpdesk/tickets/<ticket-id>`

```bash
# Use the freshdesk-get-ticket script (NOT web_fetch)
~/Code/misc/itineris-bin/freshdesk-get-ticket <ticket-id>

# Example
~/Code/misc/itineris-bin/freshdesk-get-ticket 21062
```

**Why use the script:**
- Authenticated access with API credentials
- Returns structured data (title, description, requester, status)
- Works with private tickets that web_fetch cannot access
- Faster and more reliable than web scraping

### ClickUp Tasks
**URLs:** `https://app.clickup.com/t/<task-id>`

```bash
# Use the clickup-get-task script
~/Code/misc/itineris-bin/clickup-get-task <task-id>

# Example
~/Code/misc/itineris-bin/clickup-get-task 86bzphaee
```

### When User Provides URL
1. **Extract the ticket/task ID from the URL**
2. **Use the appropriate script** (don't use web_fetch for FreshDesk/ClickUp)
3. **Create feature branch** with correct naming: `freshdesk/<id>/<desc>` or `clickup/<id>/<desc>`

**Example:**
```
User: "Do this task: https://itineris.freshdesk.com/a/tickets/21062"

# Extract ID: 21062
# Use script:
~/Code/misc/itineris-bin/freshdesk-get-ticket 21062

# Create branch:
git checkout -b freshdesk/21062/description-from-ticket
```

---

## Communication Guidelines

**When to ask the user vs. proceed autonomously:**

### Always Ask When:
- **Requirements are ambiguous** - Multiple valid interpretations exist
- **Scope is unclear** - Don't know what's in/out of scope
- **Destructive operations** - About to delete/modify critical data
- **Security implications** - Change could affect security posture
- **Breaking changes** - Will break existing functionality
- **Multiple valid approaches** - Need to choose between different architectures
- **User preference matters** - Styling, naming, organizational choices

### Proceed Autonomously When:
- **Requirements are clear** - User specified exact behavior
- **Standard patterns apply** - Following established conventions
- **Safe operations** - No risk of data loss or breaking changes
- **Single correct approach** - Only one way to solve the problem
- **Fixing obvious bugs** - Clear error, clear fix

### How to Report Progress:
**DO:**
- Be concise (3 sentences or less typically)
- Focus on outcomes, not process
- Report completion, not intentions
- Let code and commits speak

**DON'T:**
- Explain every step before doing it
- Ask permission for standard operations
- Over-communicate routine tasks
- Describe what you're about to do in detail

### Examples:

**Good:**
```
User: "Fix the broken image positioning"
You: [Makes fix, commits, pushes]
     "Fixed image positioning using relative positioning with z-index adjustment.
     Deployed to staging for review."
```

**Bad:**
```
User: "Fix the broken image positioning"
You: "I'm going to investigate the CSS file to identify the positioning issue.
     Then I'll create a feature branch and make the necessary changes.
     After that I'll run the linters and commit the fix.
     Finally I'll push and deploy to staging.
     Does this approach sound good to you?"
```

**When uncertain:**
```
User: "Add a contact form"
You: "Should the form send to a specific email address or integrate with
     an existing service (e.g., Gravity Forms, Contact Form 7)?"
```

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
- ❌ **NEVER merge PR before Copilot review completes** - Wait for `@copilot` review, not just CI checks

### Code Review & PRs
- ❌ **NEVER use `gh api` directly for PR comments** - Always use `~/Code/misc/itineris-bin/gh-pr-get-comments` and `gh-pr-reply-to-thread`
- ❌ **NEVER use combined short flags** - Use `-m -d` not `-md` (gh doesn't support combined short flags)
- ❌ **NEVER skip staging deployment** - Always verify changes on staging before merging
- ❌ **NEVER merge immediately after CI passes** - Wait for human/Copilot reviews to complete

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

### 5. Using web_fetch for FreshDesk/ClickUp
**Mistake:** Using `web_fetch` to access FreshDesk or ClickUp URLs  
**Fix:** Use dedicated scripts with authentication:
```bash
# FreshDesk tickets
~/Code/misc/itineris-bin/freshdesk-get-ticket <ticket-id>

# ClickUp tasks
~/Code/misc/itineris-bin/clickup-get-task <task-id>
```
**Why:** These scripts have proper API authentication, return structured data, and work with private tickets that web_fetch cannot access.

### 6. Merging Without Staging Verification
**Mistake:** Merging PR after CI passes without testing on staging  
**Fix:** Always deploy to staging first: `git push origin <branch>:staging --force`, then test

### 7. Using Wrong ShellCheck Severity
**Mistake:** Running `shellcheck script.sh` (defaults to warning level)  
**Fix:** Use `shellcheck --severity=style script.sh` to match CI

### 8. Creating Multi-File Instructions
**Mistake:** Splitting instructions into multiple linked files  
**Fix:** Keep everything in ONE file - Copilot CLI doesn't follow relative links

### 9. Forgetting Branch Naming Convention
**Mistake:** Using generic names like `feature/fix` without ticket reference  
**Fix:** Include ticket source: `clickup/<task-id>/description` or `freshdesk/<ticket-id>/description`

### 10. Merging Before Copilot Review Completes
**Mistake:** Running `gh pr checks --watch && gh pr merge` immediately after CI passes, before Copilot review workflow finishes  
**Fix:** Wait for both CI checks AND Copilot review workflow to complete

```bash
# 1. Wait for CI checks
gh pr checks <pr-number> --watch

# 2. Wait for Copilot review workflow to complete
PR_NUM=$(gh pr view <pr-number> --json number -q .number)
while true; do
    STATUS=$(gh run list --workflow="Copilot code review" --json headBranch,status \
      --jq ".[] | select(.headBranch == \"refs/pull/${PR_NUM}/head\") | .status")
    if [ "$STATUS" = "completed" ]; then
        echo "✓ Copilot review workflow complete"
        break
    fi
    echo "⏳ Copilot review workflow status: $STATUS (checking again in 30s)"
    sleep 30
done

# 3. Check for review comments that need addressing
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false

# 4. If there are unresolved comments, address them first (see Pattern 2)
# If no comments or all addressed, then merge
gh pr merge <pr-number> -m -d --admin
```

**Why this matters:** Copilot review runs as a GitHub Actions workflow that takes 1-3 minutes after CI passes. Merging immediately misses critical review comments and bugs.

**Real example:** PR #147 merged at 43s, review workflow completed at 2m24s - too late. PR #149 merged at 1m51s, review completed at 3m2s.

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

# 10. Wait for CI to pass
gh pr checks <pr-number> --watch

# 11. Wait for Copilot review workflow to complete (DON'T SKIP THIS)
PR_NUM=$(gh pr view <pr-number> --json number -q .number)
while true; do
    STATUS=$(gh run list --workflow="Copilot code review" --json headBranch,status \
      --jq ".[] | select(.headBranch == \"refs/pull/${PR_NUM}/head\") | .status")
    if [ "$STATUS" = "completed" ]; then
        break
    fi
    sleep 30
done

# 12. Check for review comments
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false

# 13. If unresolved comments exist, address them (see Pattern 2)
# If no comments or all addressed, merge
gh pr merge <pr-number> -m -d --admin
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

# 8. After all comments addressed, request new review
gh pr edit <pr-number> --add-reviewer @copilot

# 9. Deploy to staging to verify all fixes
git push origin HEAD:staging --force

# 10. Wait for CI checks to pass
gh pr checks <pr-number> --watch

# 11. Wait for Copilot review workflow to complete
PR_NUM=$(gh pr view <pr-number> --json number -q .number)
while true; do
    STATUS=$(gh run list --workflow="Copilot code review" --json headBranch,status \
      --jq ".[] | select(.headBranch == \"refs/pull/${PR_NUM}/head\") | .status")
    if [ "$STATUS" = "completed" ]; then
        break
    fi
    sleep 30
done

# 12. Check for review comments
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false

# 13. If unresolved comments exist, address them first
# If no comments or all addressed, merge
gh pr merge <pr-number> -m -d --admin
```

### How to Handle Copilot Review Comments

**When Copilot review posts comments, evaluate each one carefully:**

#### 1. Prioritize Comments by Severity
- **Security vulnerabilities** (SQL injection, XSS, etc.) - Fix immediately
- **Bugs/Logic errors** - Fix immediately  
- **Performance issues** - Fix if significant impact
- **Code quality** (complexity, duplication) - Fix if reasonable
- **Style/formatting** - Fix if violates project standards
- **Nitpicks** - Use judgment, may skip if trivial

#### 2. Validate Comment Accuracy
Not all Copilot comments are correct. Validate before changing:

```bash
# Get the comment
~/Code/misc/itineris-bin/gh-pr-get-comments <pr> --resolved=false

# Research the issue
# - Check if vulnerability exists in your context
# - Review if logic error is actually wrong
# - Test the suggested fix
```

**When comment is a false positive:**
```bash
# Reply explaining why it doesn't apply
~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr> \
  --thread-id='PRRT_xxx' \
  --message="This is a false positive because [explanation]. The code is correct as-is." \
  --resolve
```

#### 3. When to Address Automatically vs Ask User

**Address automatically:**
- Security vulnerabilities with clear fixes
- Obvious bugs (typos, wrong variable names)
- Missing input validation/escaping
- Clear performance improvements
- Lint/formatting issues

**Ask user first:**
- Architectural changes
- Business logic modifications
- Breaking changes to APIs
- Comments suggesting different approach
- When fix has trade-offs

#### 4. Addressing Multiple Comments

**Workflow for multiple comments:**
```bash
# 1. Categorize comments by severity
~/Code/misc/itineris-bin/gh-pr-get-comments <pr> --resolved=false > review.txt

# 2. Fix all security issues first (separate commit)
git commit -m "security: fix SQL injection vulnerability"

# 3. Fix bugs (separate commit)  
git commit -m "fix: correct calculation in total_price"

# 4. Fix quality issues (can combine)
git commit -m "refactor: reduce complexity and improve readability"

# 5. Push all fixes
git push

# 6. Reply to each thread individually
~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr> --thread-id='...' --message='...' --resolve
```

#### 5. When Comments Conflict with Requirements

If Copilot suggests changes that conflict with user requirements:
1. **Prioritize user requirements** - They know the business context
2. **Reply to comment** - Explain why requirement takes precedence
3. **Suggest compromise** - If there's a way to address both

**Example:**
```bash
~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr> \
  --thread-id='PRRT_xxx' \
  --message="User specifically requested this approach due to [business reason]. 
  I've added validation to mitigate the concern you raised." \
  --resolve
```

---

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

# 8. Wait for CI to pass
gh pr checks <pr-number> --watch

# 9. Wait for Copilot review workflow to complete (REQUIRED)
PR_NUM=$(gh pr view <pr-number> --json number -q .number)
while true; do
    STATUS=$(gh run list --workflow="Copilot code review" --json headBranch,status \
      --jq ".[] | select(.headBranch == \"refs/pull/${PR_NUM}/head\") | .status")
    if [ "$STATUS" = "completed" ]; then
        break
    fi
    sleep 30
done

# 10. Check for review comments
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false

# 11. If unresolved comments exist, address them first
# If no comments or all addressed, merge
gh pr merge <pr-number> -m -d --admin

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

### Incident Communication for Hotfixes

**When deploying emergency hotfixes:**

#### 1. Before Starting
**Assess severity:**
- Is site completely down? (P0 - Critical)
- Is key functionality broken? (P1 - High)
- Is minor feature broken? (P2 - Medium)

**For P0/P1 incidents, notify stakeholders:**
```
User: "Site is down - critical issue"

Agent: I'm deploying an emergency hotfix for [issue]. 
       I'll notify you when:
       1. Fix is deployed to staging
       2. Fix is deployed to production
       3. Verification is complete
```

#### 2. During Incident
**Keep user informed of progress:**
- "Identified root cause: [brief explanation]"
- "Hotfix deployed to staging, testing now"
- "Staging verified, deploying to production"

**Don't wait for permission on P0 incidents:**
- Fix first, discuss later
- Document decisions in PR
- Notify as you work, don't block on approval

#### 3. After Resolution
**Provide incident summary:**
```
Incident resolved ✓

Root cause: [What caused the issue]
Fix applied: [What was changed]
Deployed: [Timestamp]
Verification: [What was tested]

Monitoring for 10 minutes to ensure stability.
```

#### 4. Post-Mortem (for major incidents)
**Document for learning:**
- What happened?
- What was the impact?
- What was the root cause?
- What was the fix?
- How can we prevent this?

**Ask user:**
"Should I create a post-mortem document for this incident?"

#### 5. Who to Notify
**Ask user at start of incident:**
- "Should I notify anyone else about this incident?"
- "Are there any communication channels I should post to?"

**Typical stakeholders:**
- Project manager
- Client (for client sites)
- Team lead
- On-call engineer

**Remember:**
- For P0 (site down): Communicate every 5-10 minutes
- For P1 (major feature down): Communicate at key milestones
- For P2 (minor issue): Standard workflow is fine

### Post-Merge Production Verification

**After merging to default branch, deployment happens automatically. Verify it succeeded:**

#### 1. Wait for Deployment to Complete
```bash
# Check recent workflow runs
gh run list --limit 5

# If deploy workflow exists, wait for it
gh run watch
```

#### 2. Verify Deployment Artifacts
```bash
# Check latest commit is deployed
git log origin/main -1 --oneline
# Note the commit SHA

# If deployment creates tags/releases
gh release list --limit 5
```

#### 3. Basic Smoke Tests
```bash
# Test production site is responding
curl -I https://production-site.com

# Check for PHP errors (if wp-cli available)
wp @production cli version

# Check error logs for new errors
# (Project-specific - check documentation for log location)
```

#### 4. Monitor for Errors
**For first 5-10 minutes after deployment:**
- Check Sentry for new errors (if configured)
- Monitor server logs
- Check site performance/responsiveness
- Test the specific feature you deployed

#### 5. If Issues Detected
```bash
# Option 1: Quick fix
git checkout -b hotfix/production-issue
# Make minimal fix
git commit -am "hotfix: fix production issue"
git push -u origin HEAD
gh pr create --fill
# Fast-track review and merge

# Option 2: Rollback (see Rollback Procedures section)
git revert HEAD
git push origin main
```

**When to verify:**
- Always for hotfixes
- Always for breaking changes
- Always for database migrations
- For major features (user-facing changes)
- When deployment changes infrastructure

**When verification can be lighter:**
- Minor copy changes
- Internal tooling updates
- Documentation changes

---

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

### Security Best Practices

**Input Sanitization:**
- **ALWAYS sanitize user input** - Never trust any user-supplied data
- Use WordPress sanitization functions:
  - `sanitize_text_field()` - for text inputs
  - `sanitize_email()` - for email addresses
  - `sanitize_url()` - for URLs
  - `absint()` - for positive integers
  - `sanitize_key()` - for keys/slugs
- Validate before sanitizing - check format, length, allowed values

**Output Escaping:**
- **ALWAYS escape output** - Already covered in Code Quality section
- `esc_html()`, `esc_attr()`, `esc_url()`, `esc_js()`
- Use context-appropriate escaping

**SQL Injection Prevention:**
- **NEVER use raw SQL with user input** - Always use prepared statements
- Use `$wpdb->prepare()` for all queries with variables:
  ```php
  $wpdb->get_results($wpdb->prepare(
      "SELECT * FROM {$wpdb->posts} WHERE post_author = %d AND post_status = %s",
      $author_id,
      $status
  ));
  ```
- Use WP_Query with parameters instead of raw queries when possible

**Nonce Verification:**
- **ALWAYS verify nonces for forms and AJAX** - Prevent CSRF attacks
  ```php
  // Generate nonce
  wp_nonce_field('my_action', 'my_nonce');
  
  // Verify nonce
  if (!isset($_POST['my_nonce']) || !wp_verify_nonce($_POST['my_nonce'], 'my_action')) {
      wp_die('Security check failed');
  }
  ```

**Capability Checks:**
- **ALWAYS check user capabilities** - Never trust user roles
  ```php
  if (!current_user_can('edit_posts')) {
      wp_die('Permission denied');
  }
  ```

**Never Log Credentials:**
- ❌ Never log passwords, API keys, tokens
- ❌ Never commit credentials to repos
- ❌ Never echo sensitive data for debugging
- ✅ Use 1Password CLI for credentials
- ✅ Store secrets in environment variables

**File Upload Security:**
- Validate file types and sizes
- Use `wp_check_filetype()` for MIME type verification
- Store uploads outside webroot if possible
- Never execute uploaded files

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
10. **Wait for CI checks to pass** - `gh pr checks <pr> --watch`
11. **Wait for Copilot review workflow to complete** - Check `gh run list --workflow="Copilot code review"` until status is "completed"
12. **Check for review comments** - Use `gh-pr-get-comments <pr> --resolved=false` to see unresolved comments
13. **Address any review comments** - Fix issues, reply to threads, resolve when fixed
14. **Merge to default branch** - `gh pr merge <pr> -m -d --admin` (only after all review comments addressed)
15. **Production deployment** - Happens automatically when default branch is pushed

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

### Squashing and Cleaning Commit History

**During development:** Commit frequently for incremental review

**Before merging:** Consider cleaning up commit history

#### When to Squash:
- Multiple "fix typo" or "address review comments" commits
- WIP commits that don't add value to history
- Commits that should logically be one change
- When PR has >10 commits for a small feature

#### How to Squash:

**Option 1: Use squash merge (simplest)**
```bash
# When merging PR, use squash flag
gh pr merge <pr-number> --squash -d
```

**Option 2: Manual squash before merge**
```bash
# Squash last N commits
git rebase -i HEAD~N

# In editor, change "pick" to "squash" for commits to combine
# Edit commit message to summarize all changes

# Force push (safe because it's your feature branch)
git push --force-with-lease
```

**Option 3: Reset and re-commit**
```bash
# Soft reset to default branch
git reset --soft $(git merge-base HEAD origin/main)

# All changes now staged, create single commit
git commit -m "feat: implement feature XYZ

Detailed description of all changes"

# Force push
git push --force-with-lease
```

**When NOT to squash:**
- Each commit represents a distinct, logical change
- Commits are already clean and well-organized
- Large PRs where history helps understand progression
- When commit separation aids in future debugging

**Default approach:** Use squash merge (`gh pr merge --squash`) unless there's a reason to preserve individual commits.

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

**🚨 CRITICAL: NEVER merge until BOTH CI passes AND Copilot review workflow completes**

**The Problem:** Copilot review runs as a GitHub Actions workflow that takes 1-3 minutes. If you merge before it completes, you'll miss critical bugs.

**How Copilot Review Works:**
- Triggered automatically when PR is created/updated
- Runs as "Copilot code review" GitHub Actions workflow
- Takes 1-3 minutes to analyze code and post review
- Must wait for workflow to complete, not just CI checks

**Required Workflow:**

```bash
# 1. Wait for CI checks (Lint, etc.)
gh pr checks <pr-number> --watch

# 2. Wait for Copilot review workflow to complete (REQUIRED - don't skip!)
PR_NUM=$(gh pr view <pr-number> --json number -q .number)

while true; do
    STATUS=$(gh run list --workflow="Copilot code review" --json headBranch,status \
      --jq ".[] | select(.headBranch == \"refs/pull/${PR_NUM}/head\") | .status")
    
    if [ "$STATUS" = "completed" ]; then
        echo "✓ Copilot review workflow complete"
        break
    fi
    echo "⏳ Copilot review workflow status: $STATUS (checking again in 30s)"
    sleep 30
done

# 3. Check for review comments that need addressing
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false

# 4. If there are unresolved comments, address them first (see Pattern 2)
# If no comments or all addressed, then merge
gh pr merge <pr-number> -m -d --admin
```

**How to check manually:**
```bash
# 1. Check Copilot review workflow status
gh run list --workflow="Copilot code review" --limit 5
# If status is "in_progress" or "queued": WAIT
# If status is "completed": Continue to step 2

# 2. Check for review comments
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false
# If comments exist: Address them first
# If no comments: OK TO MERGE
```

**How to check manually:**
```bash
# Check if Copilot review exists (posted by workflow)
gh pr view <pr-number> --json reviews -q '.reviews[] | select(.author.login == "copilot-pull-request-reviewer")'

# If empty: workflow hasn't completed yet - WAIT
# If shows data: workflow complete - OK TO MERGE

# Or check workflow run status
gh run list --workflow="Copilot code review" --limit 5
```

**WRONG (what causes the problem):**
```bash
# ❌ BAD: Merges after CI only, doesn't wait for Copilot review workflow
gh pr checks <pr-number> --watch && gh pr merge <pr-number> -m -d --admin
```

**Before merging, verify ALL of these:**
1. ✅ Most recent commit was deployed to staging and verified
2. ✅ CI checks (Lint, etc.) have passed
3. ✅ Copilot review workflow has completed (review posted by copilot-pull-request-reviewer)
4. ✅ Any review comments have been addressed

**Real examples of the problem:**
- PR #147: Merged 43s after creation, review workflow completed at 2m24s
- PR #149: Merged at 00:01:51, review workflow completed at 00:03:02 (1m11s after merge)
- PR #150: Merged at 00:06:56, review workflow completed at 00:07:05 (9s after merge - close!)

**Timing data:**
- Copilot review workflow starts ~5 seconds after PR created
- Workflow takes 1-3 minutes to complete
- CI checks usually complete in <1 minute
- **Problem:** CI finishes before review workflow

**⚠️ Do NOT use:**
- `gh_check_merge` alias (only waits for CI, not Copilot workflow)
- `gh pr checks --watch && gh pr merge` (skips Copilot workflow check)
- Any command that merges immediately after CI passes

**This is only for merging to default branch**, NOT for deploying to staging.

### After Pushing

1. Update the PR description with latest changes made
2. Verify CI checks are running successfully
3. Check for any new review comments or feedback
4. If all checks pass, move PR from draft to "Ready for Review" (if applicable)

### Conflict Resolution

**Git Merge Conflicts:**

When you encounter merge conflicts during pull, merge, or rebase:

```bash
# 1. Check which files have conflicts
git status

# 2. Open conflicted files and look for conflict markers:
# <<<<<<< HEAD
# Your changes
# =======
# Their changes
# >>>>>>> branch-name

# 3. For each conflict, decide:
# - Keep your changes (remove their changes and markers)
# - Keep their changes (remove your changes and markers)
# - Combine both (merge manually and remove markers)
# - Ask user if unclear which to keep

# 4. Mark as resolved
git add <resolved-file>

# 5. Continue the operation
git merge --continue    # if merging
git rebase --continue   # if rebasing
```

**When to ask user about conflicts:**
- Business logic conflicts (can't determine correct behavior)
- Both changes look intentional and valid
- Security-sensitive code conflicts
- Database schema conflicts

**When to resolve automatically:**
- Formatting-only conflicts (whitespace, line endings)
- Obvious merge mistakes (duplicate imports, etc.)
- Auto-generated file conflicts (package-lock.json, composer.lock)

**Package Dependency Conflicts:**

```bash
# composer.lock conflicts (PHP)
composer update --lock
git add composer.lock
git commit -m "fix: resolve composer.lock conflict"

# package-lock.json conflicts (Node)
npm install
git add package-lock.json
git commit -m "fix: resolve package-lock.json conflict"
```

**Database Migration Conflicts:**
- If two branches both add migrations with same timestamp → rename one
- If migrations conflict in logic → ask user which to apply first
- Always test migrations on staging after resolving

**When conflicts are complex:**
```bash
# Abort and ask for help
git merge --abort   # or git rebase --abort

# Ask user: "Merge conflict in critical files: file1.php, file2.php.
# Both changes appear intentional. Should I keep your changes,
# their changes, or would you like to review manually?"
```

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
2. Check for performance impact (see Performance Checks below)
3. Check accessibility if UI changes (see Accessibility below)

### Dependency Updates

**When updating composer or npm dependencies:**

#### 1. Check for Breaking Changes
```bash
# For composer
composer update <package> --dry-run
composer show <package>  # Check version changes

# For npm
npm outdated
npm view <package> versions
```

#### 2. Review Changelogs
- Always review CHANGELOG or release notes
- Look for breaking changes, deprecated features
- Check minimum PHP/Node version requirements

#### 3. Update Dependencies Safely
```bash
# For composer (update one package at a time)
composer update <package-name> --with-all-dependencies
composer update  # Or all packages

# For npm
npm update <package-name>
npm update  # Or all packages

# Commit the lock file
git add composer.lock package-lock.json
git commit -m "chore: update dependencies"
```

#### 4. Test Thoroughly After Updates
- Run all tests: `./vendor/bin/phpunit`, `npm test`
- Test locally: Visit all major pages/features
- Deploy to staging: Test full user workflows
- Check for deprecation warnings in logs

#### 5. Document Major Updates
```bash
# For major version bumps, document in commit message
git commit -m "chore: update package X from v1 to v2

BREAKING CHANGES:
- Method Y renamed to Z
- Config format changed

Tested:
- All unit tests pass
- Manual testing on staging
- No errors in logs"
```

**When to update:**
- Security vulnerabilities (immediately)
- Bug fixes affecting you (soon)
- New features you need (when ready)
- Major versions (carefully, with testing)

**When NOT to update:**
- Right before a deadline
- Without testing on staging first
- Multiple major versions at once

### Performance Checks

**Check performance impact for:**
- Database queries (especially in loops)
- Image/asset loading
- JavaScript bundle size
- CSS file size

#### Quick Performance Checks:

**1. Database Queries:**
```bash
# Enable Query Monitor plugin on staging
wp @staging plugin activate query-monitor

# Or check queries in code
# Add to wp-config.php temporarily:
# define('SAVEQUERIES', true);

# Look for:
# - N+1 queries
# - Slow queries (>0.05s)
# - Duplicate queries
```

**2. Asset Sizes:**
```bash
# Check bundle sizes
npm run build
ls -lh dist/  # Or build output directory

# Warn if:
# - JS bundle >500KB
# - CSS bundle >100KB
# - Individual images >500KB (unless hero images)
```

**3. PageSpeed/Lighthouse:**
```bash
# For major UI changes, test with Lighthouse
# Run in Chrome DevTools or:
npx lighthouse https://staging-site.com --view

# Target scores:
# - Performance: >80
# - Accessibility: >90
```

**4. Database Query Optimization:**
```php
// Use proper indexes
// Cache expensive queries
// Avoid queries in loops

// WRONG:
foreach ($posts as $post) {
    $meta = get_post_meta($post->ID, 'key', true);  // Query in loop!
}

// RIGHT:
$post_ids = wp_list_pluck($posts, 'ID');
$all_meta = get_post_meta($post_ids, 'key');  // Single query
```

### Accessibility Checks

**For UI changes, check basic accessibility:**

#### 1. Keyboard Navigation
- Can you tab through all interactive elements?
- Is focus visible?
- Can you activate buttons/links with Enter/Space?

#### 2. Screen Reader Testing
```bash
# Test with VoiceOver (macOS):
# Cmd+F5 to toggle, Ctrl+Option+arrows to navigate

# Or test with NVDA (Windows - free)
```

#### 3. Semantic HTML
```php
// Use proper HTML5 elements
<nav>, <main>, <article>, <aside>, <header>, <footer>

// Use proper heading hierarchy (h1 -> h2 -> h3)
// Use <button> for buttons, <a> for links
```

#### 4. Alt Text for Images
```php
// ALWAYS provide alt text
<img src="photo.jpg" alt="Description of what's in the photo">

// For decorative images
<img src="decoration.png" alt="" role="presentation">
```

#### 5. Color Contrast
- Text must have sufficient contrast
- Minimum ratio: 4.5:1 for normal text, 3:1 for large text
- Use browser DevTools or WebAIM contrast checker

#### 6. Form Labels
```php
// ALWAYS associate labels with inputs
<label for="email">Email Address</label>
<input type="email" id="email" name="email" required>
```

**When to do thorough a11y testing:**
- New forms or interactive components
- Major UI redesigns
- Components used site-wide

**Quick check:** Run Lighthouse accessibility audit in Chrome DevTools

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

## Database Operations

**CRITICAL: Database operations can be destructive. Always follow safety procedures.**

### Before Any Database Changes:

1. **Backup first** - ALWAYS
   ```bash
   # Export database
   wp @staging db export backup-$(date +%Y%m%d-%H%M%S).sql
   
   # Or use WP CLI on production (with caution)
   wp @production db export backup-$(date +%Y%m%d-%H%M%S).sql
   ```

2. **Test on staging first** - NEVER run migrations directly on production
3. **Have rollback plan** - Know how to undo the change
4. **Verify backup** - Check file size, test restore on local

### Safe Migration Patterns:

**Adding columns (safe):**
```sql
-- Add column with default value
ALTER TABLE wp_tablename ADD COLUMN new_field VARCHAR(255) DEFAULT '' NOT NULL;
```

**Removing columns (DANGEROUS - backup first):**
```sql
-- Check column isn't used first
-- Backup database
-- Remove column
ALTER TABLE wp_tablename DROP COLUMN old_field;
```

**Changing data (test thoroughly):**
```bash
# Always test on staging first
wp @staging db query "UPDATE wp_options SET option_value = 'new' WHERE option_name = 'specific_option'"

# Verify change worked
wp @staging option get specific_option

# Then apply to production only after verification
wp @production db query "UPDATE wp_options SET option_value = 'new' WHERE option_name = 'specific_option'"
```

### WP CLI Database Commands:

```bash
# Search and replace (e.g., domain changes)
wp @staging search-replace 'old-domain.com' 'new-domain.com' --dry-run
wp @staging search-replace 'old-domain.com' 'new-domain.com' --skip-columns=guid

# Query database
wp @staging db query "SELECT * FROM wp_options WHERE option_name LIKE '%cache%'"

# Optimize tables
wp @staging db optimize

# Check database
wp @staging db check

# Reset database (DANGEROUS - staging only)
wp @staging db reset --yes
```

### Migration Workflow:

1. Write migration in feature branch
2. Test locally with fresh database
3. Commit migration file
4. Deploy to staging
5. Run migration on staging: `wp @staging migrate`
6. Verify staging works correctly
7. Merge to default branch
8. Migration runs automatically on production deploy
9. Monitor production for errors

### Rollback Database:

If migration breaks production:
```bash
# 1. Restore from backup (if available)
wp @production db import backup-YYYYMMDD-HHMMSS.sql

# 2. Or rollback deployment and revert migration
# See Rollback Procedures section
```

## Rollback Procedures

**When deployment breaks production, act fast:**

### Emergency Rollback Steps:

**1. Revert the deployment immediately:**
```bash
# Get the last good commit SHA
git log origin/main --oneline -10

# Create hotfix branch from last good commit
git checkout <last-good-commit-sha>
git checkout -b hotfix/rollback-bad-deployment

# Force push to default branch (EXTREME EMERGENCY ONLY)
git push origin HEAD:main --force

# Or better: Revert the bad commit
git checkout main
git revert <bad-commit-sha>
git push origin main
```

**2. Verify production is working:**
```bash
# Check site loads
curl -I https://production-site.com

# Check for PHP errors
wp @production cli version  # If WP CLI responds, PHP is working

# Clear caches
wp @production cache flush
```

**3. Communicate:**
- Notify team immediately in Slack/appropriate channel
- Document what broke and what you did
- Create incident report after resolution

### Rollback Database Migration:

**If migration broke database:**

```bash
# Option 1: Restore from backup (fastest)
wp @production db import backup-YYYYMMDD-HHMMSS.sql
wp @production cache flush

# Option 2: Write reverse migration
# Create migration that undoes the changes
# Test on staging first, then apply to production

# Option 3: Manual SQL rollback
wp @production db query "ALTER TABLE wp_tablename DROP COLUMN added_field"
```

### Rollback Code Changes:

**If specific feature broke:**

```bash
# Revert the specific commit
git revert <commit-sha>
git push origin main

# Or revert multiple commits
git revert <oldest-bad-commit>..<newest-bad-commit>
git push origin main
```

### Rollback Node/PHP Dependencies:

**If dependency update broke build:**

```bash
# Restore old package files
git checkout HEAD~1 package.json package-lock.json
npm install
npm run build

# Or for PHP
git checkout HEAD~1 composer.json composer.lock
composer install
```

### Prevention:

- ✅ Always test on staging before merging
- ✅ Keep backups current (automated daily backups)
- ✅ Use small, incremental changes (easier to rollback)
- ✅ Monitor after deployment (first 15 minutes critical)
- ✅ Have communication plan (know who to notify)

### Incident Communication:

**During incident:**
1. Immediate notification: "Production issue - investigating"
2. Status updates every 10-15 minutes
3. Resolution notification: "Fixed - deployed rollback"

**After incident:**
1. Write incident report
2. Document root cause
3. Create prevention tasks
4. Update runbooks if needed

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

### Multisite / Network Sites

**When working with WordPress Multisite:**

#### 1. Determine Scope
```bash
# Check if this is a multisite install
wp @staging config get MULTISITE

# List all sites in network
wp @staging site list
```

#### 2. Network-Wide vs Site-Specific Changes

**Network-wide changes:**
- Changes to `wp-content/mu-plugins/`
- Network-activated plugins
- Network settings
- Changes affecting all sites

**Site-specific changes:**
- Theme customizations for specific site
- Site-activated plugins
- Site-specific settings
- Content (posts, pages, media)

#### 3. Testing on Multisite
```bash
# Test on specific site
wp @staging --url=https://site2.example.com option get home

# Switch between sites
# In wp-cli.yml, define per-site aliases:
# @site1, @site2, etc.
```

#### 4. Deployment Considerations
- Network-wide changes affect ALL sites immediately
- Always test on staging multisite first
- Consider impact on all sites in network
- Document which sites are affected

**When to ask user:**
- Should this be network-wide or site-specific?
- Which sites in the network need this change?
- Has this been tested on all affected sites?

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

# Wait for CI and Copilot review workflow, then merge
gh pr checks <pr-number> --watch

# Wait for Copilot review workflow to complete
PR_NUM=$(gh pr view <pr-number> --json number -q .number)
while true; do
    STATUS=$(gh run list --workflow="Copilot code review" --json headBranch,status \
      --jq ".[] | select(.headBranch == \"refs/pull/${PR_NUM}/head\") | .status")
    if [ "$STATUS" = "completed" ]; then
        break
    fi
    sleep 30
done

# Check for review comments
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false

# If comments exist, address them first
# If no comments or all addressed, merge
gh pr merge <pr-number> -m -d --admin

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

## Troubleshooting

**Common issues and their solutions:**

### CI/CD Failures

**When CI fails after you pushed:**

1. **Check what failed:**
```bash
gh pr checks <pr-number>
# Or view in browser
gh pr view <pr-number> --web
```

2. **For linting failures (ShellCheck, PHPCS, ESLint):**
```bash
# Pull the latest changes if any
git pull

# Run the failing linter locally
shellcheck --severity=style script.sh
./vendor/bin/phpcs --standard=phpcs.xml file.php
npm run lint

# Fix issues
./vendor/bin/phpcbf --standard=phpcs.xml file.php  # Auto-fix PHP
npm run lint:fix  # Auto-fix JS

# Commit and push fix
git commit -am "fix: resolve linting errors"
git push
```

3. **For test failures:**
```bash
# Run tests locally to reproduce
npm test
./vendor/bin/phpunit

# If tests pass locally but fail in CI:
# - Check CI environment differences (PHP version, Node version)
# - Review test logs in GitHub Actions
# - May be timing/race condition

# Fix the test or code, then push
git commit -am "fix: resolve test failure"
git push
```

4. **For build failures:**
```bash
# Run build locally
npm run build
composer install

# Check for:
# - Missing dependencies
# - Version conflicts
# - Syntax errors

# Fix and push
git commit -am "fix: resolve build errors"
git push
```

**⚠️ If you're stuck:** Ask user before making significant changes to fix CI. They may know the root cause.

**"ShellCheck failed":**
```bash
# Problem: Script has shellcheck violations
# Solution: Run shellcheck locally with correct severity
shellcheck --severity=style script.sh

# Fix issues, then verify
git diff --check  # No trailing whitespace
shfmt -d script.sh  # Properly formatted
shellcheck --severity=style script.sh  # Passes
```

**"PHPCS errors":**
```bash
# Problem: PHP code doesn't meet coding standards
# Solution: Auto-fix with phpcbf, then manual fixes
./vendor/bin/phpcbf --standard=phpcs.xml file.php
./vendor/bin/phpcs --standard=phpcs.xml file.php

# If auto-fix doesn't work, read the errors and fix manually
```

**"Tests timeout":**
```bash
# Problem: Tests taking too long or hanging
# Causes: Database connection issues, infinite loops, external API calls
# Solution: Check test logs, add timeouts, mock external services
```

**"Build failed - npm/composer errors":**
```bash
# Problem: Dependencies can't install or build fails
# Solution: Clear caches and reinstall

# Node
rm -rf node_modules package-lock.json
npm install
npm run build

# PHP
rm -rf vendor composer.lock
composer install
```

### Git Issues

**"Permission denied (publickey)":**
```bash
# Problem: SSH key not configured or not added to agent
# Solution: Check SSH key exists and is added
ls -la ~/.ssh/id_*
ssh-add ~/.ssh/id_rsa  # or id_ed25519
ssh -T git@github.com  # Test connection
```

**"Detached HEAD state":**
```bash
# Problem: Not on a branch
# Solution: Create branch from current position or checkout existing branch
git checkout -b new-branch-name  # Create new branch
# Or
git checkout main  # Go back to main branch
```

**"Merge conflict" (see Conflict Resolution section above)**

**"fatal: refusing to merge unrelated histories":**
```bash
# Problem: Trying to merge branches with different roots
# Solution: Use --allow-unrelated-histories (rare, ask user first)
git merge --allow-unrelated-histories <branch>
```

### WP CLI Connection Issues

**"Error establishing database connection":**
```bash
# Problem: Can't connect to remote database
# Causes: SSH tunnel issues, credentials wrong, firewall
# Solution: Test SSH connection first
ssh user@staging-server.com

# Check wp-cli.yml configuration
cat wp-cli.yml

# Verify SSH key is added
ssh-add -l
```

**"Connection timeout":**
```bash
# Problem: WP CLI command hangs
# Solution: Increase timeout or check network
wp @staging option get home --ssh=ssh-user@host:/path --timeout=60
```

**"Command not found: wp":**
```bash
# Problem: WP CLI not installed or not in PATH on remote
# Solution: Check WP CLI is installed on remote server
ssh user@server 'which wp'
```

### Deployment Issues

**"Staging not updating after push":**
```bash
# Problem: Push succeeded but changes not visible
# Causes: Cache, CD workflow didn't run, wrong branch
# Solution: Check GitHub Actions, clear cache

# Check if deployment ran
gh run list --branch staging --limit 5

# Force clear cache
wp @staging cache flush

# Check correct commit is deployed
ssh user@staging-server 'cd /path/to/site && git log -1'
```

**"Production is broken after merge":**
```bash
# Problem: Bug reached production
# Solution: See Rollback Procedures section above
# Immediate: Revert commit and push
git revert <bad-commit>
git push origin main
```

### Linting Issues

**"Lint passes locally but fails in CI":**
```bash
# Problem: Different tool versions or configurations
# Solution: Check CI versions match local

# Check versions
shellcheck --version
./vendor/bin/phpcs --version
node --version

# Pull latest from repo (may have config changes)
git pull origin main
```

**"Can't find command: shellcheck/phpcs/eslint":**
```bash
# Problem: Tools not installed
# Solution: Install tools

# ShellCheck (varies by OS)
brew install shellcheck  # macOS
apt install shellcheck   # Linux

# PHPCS
composer install

# ESLint
npm install
```

### Build Issues

**"Module not found" errors:**
```bash
# Problem: Missing dependencies
# Solution: Install dependencies
npm install
composer install
```

**"Out of memory" during build:**
```bash
# Problem: Node/PHP running out of memory
# Solution: Increase memory limit
export NODE_OPTIONS="--max-old-space-size=4096"
npm run build
```

### Performance Issues

**"Site is slow after deployment":**
```bash
# Problem: Cache not working or query issues
# Solution: Check object cache, database queries

# Flush all caches
wp @production cache flush

# Check if object cache is working
wp @production cache type

# Check slow queries (requires access to database)
```

### When to Ask for Help

**Always ask the user when:**
- Error message is unclear or unfamiliar
- Multiple attempted solutions have failed
- Issue involves production data or security
- Problem requires access you don't have
- Issue is blocking critical work

**Example:**
```
"I've encountered a ShellCheck error (SC2086) that I'm not sure how to resolve
without changing the intended behavior. The script uses unquoted variable
expansion intentionally for word splitting. Should I disable this specific
check or refactor the approach?"
```

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
