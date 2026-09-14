a# GitNexus — Code Intelligence

Applies only in projects with a `.gitnexus/` directory. Otherwise ignore this file: the MCP tools have
no index to answer against.

Omit the `repo` parameter — it is only needed when several repos are indexed and the cwd is not inside
the one you mean.

## Which tool

- **Before editing a symbol that has callers** — `impact({target, direction: "upstream"})`. Report
  callers, affected processes and risk.
- **"How does X work?" / concepts and execution flows** — `query({search_query})`.
- **A single named symbol's callers, callees and flows** — `context({name})`.
- **Before committing** — `detect_changes({scope: "all"})`.
- **Renaming** — `rename`, never find-and-replace.
- **Security / taint review** — `explain({target})` (needs an index built with `analyze --pdg`).

Prefer the graph over grep for anything about callers, dependencies or flows. Fall back to text search
when the graph comes back empty or `lower-bound`, or when chasing a literal.

## Reading results correctly

This is where the wrong conclusions get drawn.

- **Check `epistemic` before `risk`.** `'lower-bound'` means callers provably exist that the result does
  not list. Branch on `causes` (counts of *missing things*), not on the prose in `boundaries`. And
  `causes.scopeExtractionFiles === 0` does **not** prove completeness while `epistemic` is
  `'lower-bound'` — an unverified index has no measured file count.
- **`risk: UNKNOWN` on a `callgraph` result is unresolved, not low.** An empty caller set is not evidence
  a symbol is unused: dynamic dispatch, property access and cross-language calls are invisible to the
  index. Confirm with a text search before changing or deleting.
- **`risk: UNKNOWN` on a `mode: 'pdg'` result is meaningless — every successful PDG result is UNKNOWN by
  contract.** Never report it as a finding.
- **`partial: true` is not a clean check, and what it invalidates depends on the failed step.** A failed
  symbol query or unparseable diff degrades everything, counts included; a failed process lookup degrades
  only `affected_processes`, leaving the changed-symbol counts sound. `changed_count: 0` with
  `partial: true` means *unseen*, not *unaffected*.
- **`truncated: true` caps the listing, not the count.** Compare `summary.changed_count` against the
  array length instead of trusting the array; when `partial` is also true, that count is a lower bound.
- **On ambiguity, `totalCandidates` is the true match count**, not `candidates[].length` — that may be a
  shorter window (`candidatesTruncated: true`). Re-call with `uid` / `target_uid` / `symbol_uid` rather
  than guessing from the name.

Two practical defaults, easy to miss:

- `impact` on a hub symbol floods the output — use `summaryOnly: true`, or `limit` + `offset`.
- `rename` is `dry_run: true` by default: the preview is not the edit. Its `text_search` edits (regex,
  lower confidence) need review; its `graph` edits are safe.
- `detect_changes` defaults to `scope: "unstaged"`, which silently misses staged work — pass `"all"`.

Skip the graph entirely for edits with no call graph: docs, comments, config, fixtures, or a symbol you
created earlier in this same session.
