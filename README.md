# Frappe CRM: ReadyStack build kit

The offline build kit for the Docker image `readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r5`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [v1.90.0-CE-ubuntu24.04-r5](https://github.com/readystack-dev/frappecrm/releases/tag/v1.90.0-CE-ubuntu24.04-r5)
- Image: [`docker.io/readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r5`](https://hub.docker.com/r/readystack/frappecrm/tags), manifest digest `sha256:3459b8fbfd8ce8a7a5162e96dd54ceb484265bf10460db7971cc20b10a9807ee`
- Product page: https://readystack.dev/products/frappecrm
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=frappecrm

Frappe CRM is distributed under its upstream licence (AGPL-3.0-only); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [v1.90.0-CE-ubuntu24.04-r5 release](https://github.com/readystack-dev/frappecrm/releases/tag/v1.90.0-CE-ubuntu24.04-r5): `ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r5.tar.gz` (712.8 MB), SHA-256 `770211301c80b7755990709177e3379e2fa76057213dea621f1bde10d0c1c0b4`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r5.rebuild.json.sigstore ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r5.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r5.tar.gz
cd v1.90.0-CE-ubuntu24.04-r5
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r5.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/frappecrm/recipe. The complete kit is the release download. Each release is a tag here.
