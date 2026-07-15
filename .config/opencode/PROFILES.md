# OCX Profiles & oh-my-opencode-slim Presets

## Architecture

OCX profiles control file visibility, registries, and which OpenCode binary to launch.
`oh-my-opencode-slim` controls agent model assignments via named **presets**.

These two systems are **independent** — OCX does not know about oh-my-opencode-slim presets,
and oh-my-opencode-slim does not read OCX profile configs. They connect through a **wrapper script**.

### How it fits together

```
ocx opencode -p free
  → OCX reads ~/.config/opencode/profiles/free/ocx.jsonc
  → sees "bin": "~/.config/opencode/profiles/bin/oc-free"
  → launches oc-free instead of `opencode` directly
  → oc-free sets OH_MY_OPENCODE_SLIM_PRESET=free
  → exec opencode "$@"
  → oh-my-opencode-slim plugin reads OH_MY_OPENCODE_SLIM_PRESET env var
  → loads the "free" preset from presets.free in oh-my-opencode-slim.json
```

### Why not `include`?

The `include` field in `ocx.jsonc` is for **file glob discovery** (making project files visible
to OpenCode's read/glob/grep tools). It does NOT merge JSON config content anywhere.
The oh-my-opencode-slim plugin only reads its config from two locations:

1. `~/.config/opencode/oh-my-opencode-slim.json` (user config)
2. `<project>/.opencode/oh-my-opencode-slim.json` (project override)

Profile-specific `oh-my-opencode-slim.json` files in `profiles/<name>/` are never read
by the plugin.

## Profile → Preset Mapping

| Profile | Wrapper Script | Preset Used | Defined In |
|---------|---------------|-------------|------------|
| `default` | `bin/oc-default` | `go-deep-kimi` | root `oh-my-opencode-slim.json` → `presets.go-deep-kimi` |
| `free` | `bin/oc-free` | `free` | root `oh-my-opencode-slim.json` → `presets.free` |
| `kimi` | `bin/oc-kimi` | `kimi` | root `oh-my-opencode-slim.json` → `presets.kimi` |
| `kimi-superpowers` | `bin/oc-kimi-superpowers` | `kimi` | root `oh-my-opencode-slim.json` → `presets.kimi` |

## Wrapper Scripts

Location: `~/.config/opencode/profiles/bin/`

Each wrapper is a two-liner:

```bash
#!/usr/bin/env bash
# <name> preset
export OH_MY_OPENCODE_SLIM_PRESET=<preset-name>
exec opencode "$@"
```

## Adding a New Profile with a Different Preset

1. Create the profile directory and `ocx.jsonc`:
   ```bash
   mkdir -p ~/.config/opencode/profiles/my-profile
   ```

2. Write `ocx.jsonc`:
   ```jsonc
   {
     "$schema": "https://ocx.kdco.dev/schemas/profile.json",
     "registries": {},
     "renameWindow": true,
     "bin": "/Users/estvmachine/.config/opencode/profiles/bin/oc-my-profile",
     "exclude": [
       "**/CLAUDE.md",
       "**/CONTEXT.md",
       "**/.opencode/**",
       "**/opencode.jsonc",
       "**/opencode.json"
     ],
     "include": []
   }
   ```

3. Create the wrapper:
   ```bash
   cat > ~/.config/opencode/profiles/bin/oc-my-profile << 'EOF'
   #!/usr/bin/env bash
   export OH_MY_OPENCODE_SLIM_PRESET=my-preset
   exec opencode "$@"
   EOF
   chmod +x ~/.config/opencode/profiles/bin/oc-my-profile
   ```

4. Define the `my-preset` in `~/.config/opencode/oh-my-opencode-slim.json` under `presets`.

5. Launch: `ocx opencode -p my-profile`

## Running Without a Wrapper

For one-off use, set the env var directly:

```bash
OH_MY_OPENCODE_SLIM_PRESET=free ocx opencode -p free
```

## Reference

- oh-my-opencode-slim uses `OH_MY_OPENCODE_SLIM_PRESET` to override the `preset` field
  from the config file at startup (see `src/config/loader.ts` in the plugin source).
- OCX profile `bin` field: custom binary path that replaces the default `opencode` binary
  when launching via `ocx opencode -p <name>`.
- Community discussion of this pattern: https://github.com/alvinunreal/oh-my-opencode-slim/issues/438
