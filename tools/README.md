# Zsh Configuration Tools

Utilities for testing, benchmarking, and profiling your zsh configuration.

---

## test_config.zsh

Comprehensive testing and linting for zsh configuration.

### Usage

```bash
# Full test suite
./tools/test_config.zsh

# Quick tests (skip shellcheck and performance)
./tools/test_config.zsh --quick

# Run and keep compiled files
./tools/test_config.zsh --fix
```

### What it checks

1. **Syntax** - All .zsh files parse correctly
2. **Shellcheck** - Linting (with zsh-specific ignores)
3. **Load Test** - Configuration loads successfully
4. **Functions** - Required functions exist
5. **Compilation** - All files compile to .zwc
6. **Performance** - Startup time under 150ms

### Exit codes

- `0` - All tests passed
- `1` - Tests failed with errors

## pre-commit-hook

Git pre-commit hook that runs quick tests before each commit.

### Usage

```bash
# Install the hook
./tools/pre-commit-hook install

# Uninstall the hook
./tools/pre-commit-hook uninstall

# Test manually (without committing)
./tools/pre-commit-hook test

# Show help
./tools/pre-commit-hook help
```

### What It Does

- Runs `./tools/test_config.zsh --quick` before each commit
- Prevents commits if tests fail
- Catches syntax errors and broken configurations early

### Bypass

```bash
# Skip pre-commit hook for one commit
git commit --no-verify
```

---

## benchzshy.sh

Statistical benchmark that measures average startup time over 100 runs.

### Usage

```bash
./tools/benchzshy.sh
```

### Requirements

- GNU time (`gtime` on macOS)
  ```bash
  brew install gnu-time  # macOS
  ```

### Output

Provides average times for:
- **Real** - Actual wall-clock time
- **User** - CPU time in user space
- **Sys** - CPU time in kernel space

### Example

```
Benchmarking zsh startup over 100 runs...

== Average Time Over 100 Runs ==
Real: 0.087 s
User: 0.052 s
Sys : 0.028 s
```

Use this to measure the impact of configuration changes over many runs, reducing noise from individual measurements.

---

## zsh_profile.py

Analyzes zsh profiling output to identify slow operations.

### Usage

```bash
# 1. Generate profile with PROFILE_STARTUP
PROFILE_STARTUP=true zsh -i --login -c echo

# 2. Analyze profile (default: show operations > 5ms)
python tools/zsh_profile.py /tmp/zsh_profile.$$

# 3. Or with custom threshold (e.g., 1ms)
python tools/zsh_profile.py /tmp/zsh_profile.$$ 1
```

### Output

Shows operations exceeding threshold:

```
12.3ms /path/to/file.zsh:42 source slow_plugin.zsh
8.7ms /path/to/file.zsh:156 compinit -C
6.2ms /path/to/file.zsh:89 some_slow_function
```

### Use Cases

- **Identify bottlenecks** - Find which lines are slowing startup
- **Optimization** - Measure impact of changes
- **Regression detection** - Ensure new code doesn't add delays

### Requirements

- Python 3.x with dataclasses support

---

## CI/CD Integration

You can add this to GitHub Actions or similar:

```yaml
name: Test Zsh Config
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install zsh
        run: sudo apt-get install -y zsh
      - name: Run tests
        run: ./tools/test_config.zsh --quick
```

---

## Quick Reference

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `test_config.zsh` | Validate config works | Before commits, in CI/CD |
| `benchzshy.sh` | Measure average startup | Compare changes over time |
| `zsh_profile.py` | Find slow operations | Optimize specific bottlenecks |
| `pre-commit-hook` | Auto-validate commits | Daily development |
