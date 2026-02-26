# Quick Reference

Fast command lookup for common tasks. See main guides for detailed explanations.

## Git Commands

### Branch Creation & Push
```bash
# Create feature branch based on ticket source
git checkout -b clickup/<task-id>/<description>      # ClickUp
git checkout -b freshdesk/<ticket-id>/<description>  # FreshDesk
git checkout -b issue/<number>/<description>         # GitHub Issues
git checkout -b feature/<description>                # No ticket

# Push and track
git push -u origin HEAD
```

### Pull Requests
```bash
# Open draft PR
gh pr create --draft --fill

# Check CI status and merge
gh pr checks <pr-number> --watch && gh pr merge <pr-number> -m -d --admin

# Or use alias
gh_check_merge <pr-number> --admin
```

### Deployment
```bash
# Deploy any branch to staging
git push origin <branch-name>:staging --force

# Deploy to production (automatic on default branch merge)
# Happens automatically when PR is merged to main/master
```

---

## Linting Commands

### Bash Scripts
```bash
# Check trailing whitespace
git diff --check

# Remove trailing whitespace
sed -i 's/[[:space:]]*$//' script.sh

# Format with shfmt
shfmt -w script.sh       # Apply formatting
shfmt -d script.sh       # Verify formatting

# Lint with shellcheck
shellcheck --severity=style script.sh

# Check all modified scripts in branch
git diff main --name-only --diff-filter=ACMR | \
  xargs shellcheck --format=gcc --severity=style
```

### PHP
```bash
# Syntax check
php -l file.php

# Lint
./vendor/bin/phpcs --standard=phpcs.xml file.php

# Auto-fix
./vendor/bin/phpcbf --standard=phpcs.xml file.php
```

### JavaScript
```bash
# Project-specific (check package.json)
npm run lint:js

# Or using eslint directly
npx eslint --fix path/to/file.js
```

### CSS
```bash
# Project-specific (check package.json)
npm run lint:css

# Or using stylelint directly
npx stylelint --fix path/to/file.css
```

---

## WP CLI Remote Testing

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

---

## PR Comment Management

### Get Comments
```bash
# All comments in pretty format
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number>

# Filter by author
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> \
  --author='github-advanced-security[bot]'

# Unresolved comments only
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --resolved=false

# JSON output
~/Code/misc/itineris-bin/gh-pr-get-comments <pr-number> --format=json
```

### Reply to Comments
```bash
# Reply to thread
~/Code/misc/itineris-bin/gh-pr-reply-to-thread <pr-number> \
  --thread-id='PRRT_kwDOABCDEF' \
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

---

## Task/Ticket Management

```bash
# ClickUp
~/Code/misc/itineris-bin/clickup-get-task <task-id>

# FreshDesk
~/Code/misc/itineris-bin/freshdesk-get-ticket <ticket-id>
```

---

## GitHub Actions Testing

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

---

## Credentials Access

```bash
# 1Password CLI
op item get "Item Name" --vault "Vault Name" --fields username,password

# Or on Windows/WSL
op.exe item get "Item Name" --vault "Vault Name" --fields username,password
```

---

## Branch Naming Conventions

| Ticket Source | Format | Example |
|--------------|--------|---------|
| ClickUp | `clickup/<task-id>/<description>` | `clickup/86bzphaee/landing-page-ammends` |
| FreshDesk | `freshdesk/<ticket-id>/<description>` | `freshdesk/21170/intro-section-image-position` |
| GitHub Issues | `issue/<number>/<description>` | `issue/123/fix-navigation-bug` |
| No ticket | `feature/<description>` or `fix/<description>` | `feature/add-caching`, `fix/header-spacing` |
