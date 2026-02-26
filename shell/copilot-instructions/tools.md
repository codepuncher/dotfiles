# Tools Reference

Scripts, utilities, and tools available for Itineris development workflows.

## GitHub PR Comment Management

### Get PR Comments

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

### Reply to PR Comments

Use `gh-pr-reply-to-thread` script to reply and resolve review threads:

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

**Important:** Always use these utility scripts instead of raw `gh api` calls for PR comment management.

---

## Task & Ticket Management

### ClickUp

Query ClickUp tasks programmatically:

```bash
~/Code/misc/itineris-bin/clickup-get-task <task-id>
```

### FreshDesk

Query FreshDesk tickets programmatically:

```bash
~/Code/misc/itineris-bin/freshdesk-get-ticket <ticket-id>
```

**Note:** These scripts handle authentication and API interaction automatically. Always use these dedicated scripts instead of making direct API calls.

---

## Credentials Access

### 1Password CLI

Use 1Password CLI to retrieve credentials programmatically:

```bash
# Standard usage
op item get "Item Name" --vault "Vault Name" --fields username,password

# On Windows/WSL
op.exe item get "Item Name" --vault "Vault Name" --fields username,password
```

**Note:** Check project documentation for specific vault and item names for each project.

---

## GitHub Actions Testing

### Testing Workflows Locally with act

Before pushing CI workflow changes, test them locally using the [act GitHub CLI extension](https://nektosact.com/installation/gh.html):

```bash
# Install act as a GitHub CLI extension (one-time)
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

---

## WP CLI Remote Testing

### Configured Aliases

WP CLI aliases are configured in `wp-cli.yml` for remote testing:
- `@staging` - Staging environment
- `@production` - Production environment

### Usage

```bash
# Staging environment (safe for testing)
wp @staging option get home
wp @staging cli version
wp @staging cache flush

# Production environment (⚠️ USE WITH CAUTION)
wp @production option get home     # Read-only: safe
wp @production cache flush         # Write operation: be careful
```

**⚠️ WARNING**: Use `@production` with caution. Prefer read-only commands (get, list) over write operations (set, update, delete).

### Testing After Deployment

Always test on staging after deployment to verify fixes work correctly:

```bash
# Deploy to staging
git push origin HEAD:staging --force

# Test the fix
wp @staging option get home
wp @staging cache flush
```

---

## Quick Command Reference

See [Quick Reference](./quick-reference.md) for a comprehensive command cheat sheet including:
- Git commands
- Linting commands
- PR management
- Branch naming conventions
- Deployment commands
