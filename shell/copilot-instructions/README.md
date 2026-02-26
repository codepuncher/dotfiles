# Copilot CLI Instructions for Itineris Development

## Quick Navigation
- **[Quick Reference](./quick-reference.md)** - Command cheat sheets for instant copy-paste
- **[Git Workflow](./git-workflow.md)** - Branching, PRs, deployment, code review
- **[Code Standards](./code-standards.md)** - PHP, JavaScript, CSS, Bash coding rules
- **[Tools Reference](./tools.md)** - Scripts, utilities, credentials access

---

## ⚠️ CRITICAL: Always Run Lint Checks Locally Before Pushing

**NEVER push to GitHub without running local lint checks first.**

### Quick Lint Commands

**Bash:**
```bash
git diff --check                                    # Check trailing whitespace
shfmt -w script-name && shfmt -d script-name       # Format
shellcheck --severity=style script-name             # Lint
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

See [Code Standards](./code-standards.md) for detailed language-specific requirements.

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

---

## Core Workflow Rules

### Branch Protection
- **NEVER commit directly to the default branch** (usually `main`, `master`, or `develop`)
- **ALWAYS create a feature branch** for any changes
- **ALWAYS create a Pull Request** for review before merging

### Essential Git Commands
```bash
# Create and push feature branch
git checkout -b clickup/<task-id>/<description>
git push -u origin HEAD

# Deploy to staging
git push origin HEAD:staging --force

# Check CI and merge PR
gh pr checks <pr> --watch && gh pr merge <pr> -m -d --admin
```

See [Git Workflow](./git-workflow.md) for complete process.

---

## Communication

- Ask clarifying questions when requirements are ambiguous
- Provide concise explanations (3 sentences or less typically)
- Focus on doing the work, not explaining what you're about to do
- Let the code and commits speak for themselves

---

## When to Use Which Guide

**Starting a new task or feature?**
→ Read [Git Workflow](./git-workflow.md) for branch creation and PR process

**Writing or fixing code?**
→ Check [Code Standards](./code-standards.md) for language-specific rules

**Need a specific command?**
→ Check [Quick Reference](./quick-reference.md) for copy-paste ready commands

**Using a script or tool?**
→ Check [Tools Reference](./tools.md) for paths and usage examples

**Before committing or pushing?**
→ Run lint checks (see Critical section above) + review [Code Standards](./code-standards.md)
