[![ReadyStack](https://readystack.dev/logo.svg)](https://readystack.dev)

**Stable, Open-source Releases, Automated** · [readystack.dev](https://readystack.dev)

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-readystack%2Ffrappecrm-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/readystack/frappecrm) [![Docker pulls](https://img.shields.io/docker/pulls/readystack/frappecrm)](https://hub.docker.com/r/readystack/frappecrm) [![Grade at release](https://img.shields.io/badge/grade%20at%20release-A%20%2894%25%29-2ea44f)](https://readystack.dev/products/frappecrm) [![Signed: cosign](https://img.shields.io/badge/signed-cosign-2ea44f)](https://readystack.dev/keys/cosign.pub) ![SBOM: SPDX](https://img.shields.io/badge/SBOM-SPDX-2ea44f) ![Provenance: SLSA v1](https://img.shields.io/badge/provenance-SLSA%20v1-2ea44f) ![Offline rebuild: verified](https://img.shields.io/badge/offline%20rebuild-verified-2ea44f)

# Frappe CRM: ReadyStack build kit

The offline build kit for the Docker image `readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r7`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [v1.90.0-CE-ubuntu24.04-r7](https://github.com/readystack-dev/frappecrm/releases/tag/v1.90.0-CE-ubuntu24.04-r7)
- Image: [`docker.io/readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r7`](https://hub.docker.com/r/readystack/frappecrm/tags), manifest digest `sha256:ce10c783133ce2cb6e8cb423db57fb8db4677d8b954e3e0e4920bae88dfba5a5`
- Product page: https://readystack.dev/products/frappecrm
- Source and build recipe: https://readystack.dev/products/frappecrm/recipe
- Build trail: https://readystack.dev/products/frappecrm/trail/v1.90.0-CE-ubuntu24.04-r7
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=frappecrm

## The image

ONE product container (supervisord runs the Frappe web backend [gunicorn], the Socket.IO realtime node process, one RQ worker process for the long, default and short queues, the scheduler, and the nginx frontend on :8080) PLUS two required datastore sidecars the customer provides: a MariaDB 11.x server and Redis (a cache instance + a queue instance; the queue instance also backs Socket.IO). NOT a single self-contained image — Frappe is fundamentally multi-service. The image has neither wkhtmltopdf nor Chromium: PDFs of the Standard and classic print formats fail, while Print Format Builder formats whose PDF Renderer is Typst, or WeasyPrint for a format already stored on it, render to PDF inside the image.

## Who uses Frappe CRM and why

Sales teams that want a simple, customisable CRM they can host themselves.

Frappe CRM tracks leads and deals. Each one has a single page with its activities, comments, notes and tasks, and a Kanban board shows every deal's stage.

A typical use: A small sales team tracks prospects in spreadsheets and email threads. In Frappe CRM each lead has one page with its notes, tasks and activity, and the team drags its leads and deals across its own stages on a Kanban board, so anyone can see where every deal stands.

From the upstream project's own description: https://github.com/frappe/crm.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-28 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 160 packages with copyleft licences (GPL, LGPL, MPL), 155 of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component).
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`frappe`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-28; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/frappecrm.

Frappe CRM is distributed under its upstream licence (AGPL-3.0-only); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [v1.90.0-CE-ubuntu24.04-r7 release](https://github.com/readystack-dev/frappecrm/releases/tag/v1.90.0-CE-ubuntu24.04-r7): `ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r7.tar.gz` (714.1 MB), SHA-256 `6b705d66a8c88af0b991445adb68f6f4fe43cb9c09d1486e96531c9878d1a0ea`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r7.rebuild.json.sigstore ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r7.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r7.tar.gz
cd v1.90.0-CE-ubuntu24.04-r7
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-frappecrm-v1.90.0-CE-ubuntu24.04-r7.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/frappecrm/recipe. The complete kit is the release download. Each release is a tag here. How to report a vulnerability: [SECURITY.md](SECURITY.md).

## About ReadyStack

**Stable, Open-source Releases, Automated.** ReadyStack releases popular open-source apps every week with every available critical and high security fix applied, plus full documentation, reference data, tests and a build recipe that recreates each release bit-for-bit. Each release is rebuilt from its pinned inputs with the network off, checked against its published digest, signed, and scanned and graded again every day. The images and build kits are free, and ReadyStack is soon to be a nonprofit.

[readystack.dev](https://readystack.dev) · [All products](https://readystack.dev/products.html) · [Build kits on GitHub](https://github.com/readystack-dev) · [Defect log](https://readystack.dev/defects.html) · contact@readystack.dev

— ReadyStack · https://readystack.dev
