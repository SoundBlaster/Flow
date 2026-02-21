# Releasing Flow

## Versioning

Flow uses [Semantic Versioning](https://semver.org): `MAJOR.MINOR.PATCH`

- **PATCH** — fixes to existing commands, wording corrections
- **MINOR** — new commands, new params fields, backwards-compatible changes
- **MAJOR** — breaking changes to workflow structure or params schema

The single source of truth is the `VERSION` file at the repo root. Each command file also carries a matching `**Version:**` header — update both when releasing.

## Release Artifact

A release contains only what users need to install Flow:

```
install.sh
SPECS/COMMANDS/
```

The rest of the repo (this file, `SPECS/Idea.md`, `docs/`, etc.) is not included.

## Release Process (Manual)

### 1. Bump the version

Update `VERSION` file and the `**Version:**` header in every `SPECS/COMMANDS/*.md` that changed.

### 2. Commit

```bash
git add VERSION SPECS/COMMANDS/
git commit -m "Release v{VERSION}"
```

### 3. Tag

```bash
git tag v{VERSION}
git push origin main --tags
```

### 4. Create GitHub Release

```bash
gh release create v{VERSION} \
  --title "Flow v{VERSION}" \
  --notes "See CHANGELOG.md for details"
```

GitHub will attach the source zip automatically. Optionally attach a trimmed artifact (see below).

### 5. Trimmed artifact (optional)

If you want a minimal zip without the full repo:

```bash
mkdir -p /tmp/flow-release
cp install.sh /tmp/flow-release/
cp -r SPECS/COMMANDS /tmp/flow-release/SPECS/
cd /tmp && zip -r flow-v{VERSION}.zip flow-release/
gh release upload v{VERSION} /tmp/flow-release/flow-v{VERSION}.zip
```

## User Installation

```bash
# Latest release
curl -sSL https://github.com/SoundBlaster/Flow/releases/latest/download/install.sh | bash -s /path/to/repo

# Pinned version
curl -sSL https://github.com/SoundBlaster/Flow/releases/download/v1.0.0/install.sh | bash -s /path/to/repo

# Local (after cloning)
./install.sh /path/to/repo
```

## Future: Automated Releases via GitHub Actions

When the release cadence justifies it, add `.github/workflows/release.yml`:

- Trigger: push of a `v*` tag
- Steps: build trimmed artifact → create GitHub Release → attach zip
- Result: tagging is the only manual step

## Checklist

- [ ] `VERSION` file updated
- [ ] Command file headers updated
- [ ] `CHANGELOG.md` entry added
- [ ] Commit and tag pushed
- [ ] GitHub Release created
