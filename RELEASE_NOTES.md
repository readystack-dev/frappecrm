# Frappe CRM v1.90.0 — ReadyStack release `v1.90.0-CE-ubuntu24.04-r5`

Generated 2026-11-23 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r5` (linux/amd64). Index digest `sha256:38ca4a856e84989e6b02b20a95e542423fe1b53d542623c88ccad39faffc94c8` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:3459b8fbfd8ce8a7a5162e96dd54ceb484265bf10460db7971cc20b10a9807ee` [`TARGET_DIGEST.txt`].
- **Upstream:** Frappe CRM v1.90.0 built from source at `v1.90.0` of https://github.com/frappe/crm — upstream notes: https://github.com/frappe/crm/releases/tag/v1.90.0 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** `ubuntu:24.04`; runtime user `frappe`.
- **Build:** `source-rebuild-python`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `v1.90.0-CE-ubuntu24.04-r4`.

## What changed in this release

- Upstream version unchanged (v1.90.0); ReadyStack rebuild.
- Frappe CRM v1.90.0 is unchanged from the release this supersedes (v1.90.0-CE-ubuntu24.04-r4); this release rebuilds it. Changes: node moves from 24.22.2 to 24.22.3 (CVE-2026-123828, CVE-2026-123863, CVE-2026-123864, CVE-2026-123865, ...); CPython 3.14.10 is built with upstream's fix commit 7d9da92 for CVE-2026-119170, and the release's OpenVEX states it fixed (scanners that match on the version still list it); nginx moves from 1.24.0-2ubuntu7.19 to 1.24.0-2ubuntu7.20 (CVE-2026-113425, CVE-2026-118899, CVE-2026-123007, CVE-2026-123633, ...); nginx-common moves from 1.24.0-2ubuntu7.19 to 1.24.0-2ubuntu7.20 (CVE-2026-113425, CVE-2026-118899, CVE-2026-123007, CVE-2026-123633, ...); libc-bin moves from 2.39-0ubuntu8.9 to 2.39-0ubuntu8.12 (CVE-2026-18374, CVE-2026-84243, CVE-2026-8674, CVE-2026-86805, ...); libc6 moves from 2.39-0ubuntu8.9 to 2.39-0ubuntu8.12 (CVE-2026-18374, CVE-2026-84243, CVE-2026-8674, CVE-2026-86805, ...). Settings, ports and data volumes are those of v1.90.0-CE-ubuntu24.04-r4: replace the container with this image on the same volumes.

## Security status at release (measured 2026-11-23)

- **Docker Scout:** 0 fixable critical/high vulnerabilities after 1 OpenVEX statement of ours (`docs/security/VEX.openvex.json`; Docker Scout's default policy does not read them and counts it as fixable); runs as `frappe` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r5` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Before exposing this service:** Frappe's bench command writes every command line it runs, in clear text, to /home/frappe/frappe-bench/logs/bench.log (mode 644) inside the container. The entrypoint's first-boot `bench new-site` passes the Administrator password (ADMIN_PASSWORD or the generated one) and DB_ROOT_PASSWORD, your MariaDB root password, as arguments, so both are stored in plain text in that file, as is any secret you later pass to a bench command as an argument (set-admin-password '<new password>', restore --db-root-password, set-config encryption_key). The file is in the container's own filesystem, not in the sites volume: after the first boot, re-create the container (`docker stop` and `docker rm`, then the same `docker run` command; the site, its data and its passwords are kept, and the new bench.log does not have them), type a new Administrator password at the set-admin-password prompt (bench.log then records the command, not the password), and do not copy that logs directory out of the container.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:3459b8fbfd8ce8a7a5162e96dd54ceb484265bf10460db7971cc20b10a9807ee`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 3 of 3 use cases passed (3 authored) against the running image [`docs/validation/test-results.json`].
- The cases are `GET /api/method/ping` (200), `GET /api/method/frappe.auth.get_logged_user` (200), `GET /api/method/frappe.utils.change_log.get_versions` (200); the suite checks nothing else.

## Known issues

- **medium** (upstream): Secret written in plain text or to the log by default [`RSD-frappecrm-c328ff256f`]
- **low** (ReadyStack package): Admin handbook: Contradicts the Site name bullet two lines above: a volume the upstream image wrote is used as it is only when its site is named frontend; otherwise it is not served. [`RSD-frappecrm-04d9f5a7fa`] (carried from `v1.90.0-CE-ubuntu24.04-r1`, recorded there as `RSD-frappecrm-a6dc75ca7e`)
- **low** (ReadyStack package): Admin handbook: The section frames itself as the single canonical statement of this release's operating facts, but omits the 'cli' fact that strategies/frappecrm.json's doc_facts/operating_facts designates for… [`RSD-frappecrm-723ca05f49`] (carried from `v1.85.0-CE-bookworm-r1`, recorded there as `RSD-frappecrm-ce70337f54`)

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r5
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

