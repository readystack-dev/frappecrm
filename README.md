# Frappe CRM: ReadyStack build kit

The offline build kit for the Docker image `readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r6`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [v1.90.0-CE-ubuntu24.04-r6](https://github.com/readystack-dev/frappecrm/releases/tag/v1.90.0-CE-ubuntu24.04-r6)
- Image: [`docker.io/readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r6`](https://hub.docker.com/r/readystack/frappecrm/tags), manifest digest `sha256:de5a06a514d23e99f0ae97b0d330ffad010b26fb95aa6e91399c438eb6a4d593`
- Product page: https://readystack.dev/products/frappecrm
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=frappecrm

Frappe CRM is distributed under its upstream licence (AGPL-3.0-only); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [v1.90.0-CE-ubuntu24.04-r6 release](https://github.com/readystack-dev/frappecrm/releases/tag/v1.90.0-CE-ubuntu24.04-r6): `ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r6.tar.gz` (712.9 MB), SHA-256 `246b15861ecccd791d897264214d79de484d5969e6ae71592e3dd4ce9c1242b8`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r6.rebuild.json.sigstore ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r6.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r6.tar.gz
cd v1.90.0-CE-ubuntu24.04-r6
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r6.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/frappecrm/recipe. The complete kit is the release download. Each release is a tag here.
