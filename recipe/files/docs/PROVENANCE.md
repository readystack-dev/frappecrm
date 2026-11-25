# Provenance — Frappe CRM (`v1.90.0-CE-ubuntu24.04-r5`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/frappe/crm
- Revision built: `v1.90.0` (commit `36bd8859f2a6345a620477bc708d0546e8c3f08a`)
- Source tree: `bf0aa1f01cdb2aad41ae55d77ead24f1399f77b93c61cdc99c0baf7c48d8ceca` over 1111 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-python`; base image `ubuntu:24.04`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- SOURCE_DATE_EPOCH: `1795408354` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r5` — index digest `sha256:38ca4a856e84989e6b02b20a95e542423fe1b53d542623c88ccad39faffc94c8` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:3459b8fbfd8ce8a7a5162e96dd54ceb484265bf10460db7971cc20b10a9807ee` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r5`

## Pinned inputs, and why

- 17 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 1, image digests 1, language runtimes and toolchains 2, files the vendor stage downloads 1, pins in the kit's dockerfiles 4, readystack's build engine 1, dependencies upstream chose 2, services the release checks run beside 3).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r5.trail.json`, published beside this archive and signed with the release key (`ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r5.trail.json.sigstore`), and readable at https://readystack.dev/products/frappecrm/trail/v1.90.0-CE-ubuntu24.04-r5.

