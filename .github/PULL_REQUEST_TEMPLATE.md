## Summary

- describe the user-facing change
- note the key files or workflow areas touched
- link the related issue or task if applicable

## Versioning

- [ ] no version bump required: internal-only change
- [ ] PATCH: backwards-compatible fix to shipped behavior
- [ ] MINOR: backwards-compatible shipped behavior change
- [ ] MAJOR: breaking change to workflow or params schema

Version bump required only for shipped user-facing changes. If checked, update `SPECS/VERSION` and matching `**Version:**` headers in changed shipped command files.

## Validation

- [ ] `make version-check`
- [ ] `make test`
- [ ] not run

## Notes

- list risks, follow-ups, or rollout caveats if any
