# Frappe CRM v1.90.0 — ReadyStack release `v1.90.0-CE-ubuntu24.04-r7`

Generated 2026-11-28 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r7` (linux/amd64). Index digest `sha256:8441a9662e57b53ff78e787a41e57340098afa9f0102eaa1120d47b159c60cf3` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:ce10c783133ce2cb6e8cb423db57fb8db4677d8b954e3e0e4920bae88dfba5a5` [`TARGET_DIGEST.txt`].
- **Upstream:** Frappe CRM v1.90.0 built from source at `v1.90.0` of https://github.com/frappe/crm — upstream notes: https://github.com/frappe/crm/releases/tag/v1.90.0 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** `ubuntu:24.04`; runtime user `frappe`.
- **Build:** `source-rebuild-python`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `v1.90.0-CE-ubuntu24.04-r6`.

## What changed in this release

- Upstream version unchanged (v1.90.0); ReadyStack rebuild.
- Frappe CRM v1.90.0 is unchanged from the release this supersedes (v1.90.0-CE-ubuntu24.04-r6); this release rebuilds it. Changes: libxrender1 moves from 1:0.9.10-1.1build1 to 1:0.9.10-1.1ubuntu0.1 (USN-9194-1); libexpat1 moves from 2.6.1-2ubuntu0.6 to 2.6.1-2ubuntu0.7 (USN-9196-1). Settings, ports and data volumes are those of v1.90.0-CE-ubuntu24.04-r6: replace the container with this image on the same volumes.

## Security status at release (measured 2026-11-27)

- **Docker Scout:** 0 fixable critical/high vulnerabilities after 1 OpenVEX statement of ours (`docs/security/VEX.openvex.json`; Docker Scout's default policy does not read them and counts it as fixable); runs as `frappe` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r7` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Before exposing this service:** Frappe's bench command writes every command line it runs, in clear text, to /home/frappe/frappe-bench/logs/bench.log (mode 644) inside the container. The entrypoint's first-boot `bench new-site` passes the Administrator password (ADMIN_PASSWORD or the generated one) and DB_ROOT_PASSWORD, your MariaDB root password, as arguments, so both are stored in plain text in that file, as is any secret you later pass to a bench command as an argument (set-admin-password '<new password>', restore --db-root-password, set-config encryption_key). The file is in the container's own filesystem, not in the sites volume: after the first boot, re-create the container (`docker stop` and `docker rm`, then the same `docker run` command; the site, its data and its passwords are kept, and the new bench.log does not have them), type a new Administrator password at the set-admin-password prompt (bench.log then records the command, not the password), and do not copy that logs directory out of the container.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:ce10c783133ce2cb6e8cb423db57fb8db4677d8b954e3e0e4920bae88dfba5a5`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 3 of 3 use cases passed (3 authored) against the running image [`docs/validation/test-results.json`].
- The cases are `GET /api/method/ping` (200), `GET /api/method/frappe.auth.get_logged_user` (200), `GET /api/method/frappe.utils.change_log.get_versions` (200); the suite checks nothing else.

## Known issues

- **medium** (upstream): Secret written in plain text or to the log by default [`RSD-frappecrm-bb54a77090`]
- **low** (ReadyStack package): Admin handbook: Contradicts the Site name bullet two lines above: a volume the upstream image wrote is used as it is only when its site is named frontend; otherwise it is not served. [`RSD-frappecrm-6deba1c887`] (carried from `v1.90.0-CE-ubuntu24.04-r1`, recorded there as `RSD-frappecrm-a6dc75ca7e`)
- **low** (ReadyStack package): Admin handbook: The section frames itself as the single canonical statement of this release's operating facts, but omits the 'cli' fact that strategies/frappecrm.json's doc_facts/operating_facts designates for… [`RSD-frappecrm-32c0557592`] (carried from `v1.85.0-CE-bookworm-r1`, recorded there as `RSD-frappecrm-ce70337f54`)

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r7
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

