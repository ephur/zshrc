# Contributing to Zsh Configuration

## Automated Testing

This repository uses GitHub Actions to automatically test all changes. Tests run on:
- **Ubuntu Latest** - Primary Linux testing
- **macOS Latest** - macOS-specific functionality

### What Gets Tested

1. **Syntax Validation** - All `.zsh` files must parse correctly
2. **Shellcheck Linting** - Code quality checks with zsh-specific ignores
3. **Configuration Loading** - Ensures the config loads without errors
4. **Function Existence** - Verifies all required functions are defined

### Running Tests Locally

Before pushing changes, run the test suite locally:

```bash
# Quick tests (syntax, functions, compilation)
./tools/test_config.zsh --quick

# Full tests (includes shellcheck and performance)
./tools/test_config.zsh

# Install pre-commit hook (recommended)
./tools/pre-commit-hook install
```

## Branch Protection Setup

To require tests to pass before merging:

### 1. Enable Branch Protection

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Branches**
3. Click **Add branch protection rule**
4. Enter branch name pattern: `master` (or `main`)

### 2. Configure Protection Rules

Enable the following options:

- ✅ **Require a pull request before merging**
  - ✅ Require approvals: 1 (optional, for team repos)

- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - Search and select these status checks:
    - `Run Test Suite`
    - `Run Test Suite (macOS)` (optional)

- ✅ **Require conversation resolution before merging** (optional)

- ✅ **Do not allow bypassing the above settings**

### 3. Save and Test

After enabling:
1. Create a test branch
2. Make a change and push
3. Open a pull request
4. Verify that GitHub Actions runs automatically
5. Confirm you cannot merge until tests pass

## Development Workflow

### Making Changes

1. **Create a feature branch**
   ```bash
   git checkout -b feature/my-change
   ```

2. **Make your changes**
   - Edit files as needed
   - Add new functions with proper documentation
   - Update CHEATSHEET.md if adding/removing commands

3. **Test locally**
   ```bash
   ./tools/test_config.zsh
   ```

4. **Commit changes**
   ```bash
   git add .
   git commit -m "Description of changes"
   # Pre-commit hook runs automatically
   ```

5. **Push and create PR**
   ```bash
   git push origin feature/my-change
   ```
   - Open pull request on GitHub
   - Wait for CI to pass
   - Address any failures

### If Tests Fail

**In CI:**
1. Click "Details" next to the failed check
2. Review the error logs
3. Fix locally and push again

**Locally:**
1. Run `./tools/test_config.zsh` to see full output
2. Fix the issues reported
3. Re-run tests to verify
4. Commit and push fixes

## Coding Standards

### Shellcheck Compliance

All code must pass shellcheck with our standard ignores:
- SC1090: Can't follow non-constant source
- SC2148: Tips depend on target shell
- SC2296: Zsh-specific parameter expansion
- SC1091: Not following sourced files
- SC2034: Variables used by child processes
- SC2168: `local` outside functions (valid in zsh)

### Function Guidelines

1. **Add usage documentation**
   ```zsh
   # Description of what it does
   # Usage: function_name <required-arg> [optional-arg]
   # Example: function_name foo bar
   function function_name() {
     if [[ -z "$1" ]]; then
       echo "Usage: function_name <required-arg>"
       return 1
     fi
     # ... implementation
   }
   ```

2. **Quote variables** to prevent word splitting
3. **Use `local` for function variables**
4. **Declare and assign separately** to avoid masking return values
5. **Handle errors** with appropriate return codes

### Performance Requirements

- Maintain sub-150ms startup time
- Changes adding >5ms should be justified
- Use profiling to measure impact:
  ```bash
  PROFILE_STARTUP=true zsh -i --login -c echo
  ```

## Questions?

Open an issue or check the documentation:
- `README.md` - Overview and setup
- `CHEATSHEET.md` - Available commands
- `CLAUDE.md` - Architecture and development guide
- `tools/README.md` - Testing tools documentation
