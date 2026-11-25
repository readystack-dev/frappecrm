# Frappe CRM: ReadyStack build kit

The offline build kit for the Docker image `readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r6`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [v1.90.0-CE-ubuntu24.04-r6](https://github.com/readystack-dev/frappecrm/releases/tag/v1.90.0-CE-ubuntu24.04-r6)
- Image: [`docker.io/readystack/frappecrm:v1.90.0-CE-ubuntu24.04-r6`](https://hub.docker.com/r/readystack/frappecrm/tags), manifest digest `sha256:de5a06a514d23e99f0ae97b0d330ffad010b26fb95aa6e91399c438eb6a4d593`
- Product page: https://readystack.dev/products/frappecrm
- Source and build recipe: https://readystack.dev/products/frappecrm/recipe
- Build trail: https://readystack.dev/products/frappecrm/trail/v1.90.0-CE-ubuntu24.04-r6
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=frappecrm

## The image

ONE product container (supervisord runs the Frappe web backend [gunicorn], the Socket.IO realtime node process, one RQ worker process for the long, default and short queues, the scheduler, and the nginx frontend on :8080) PLUS two required datastore sidecars the customer provides: a MariaDB 11.x server and Redis (a cache instance + a queue instance; the queue instance also backs Socket.IO). NOT a single self-contained image — Frappe is fundamentally multi-service. The image has neither wkhtmltopdf nor Chromium: PDFs of the Standard and classic print formats fail, while Print Format Builder formats whose PDF Renderer is Typst, or WeasyPrint for a format already stored on it, render to PDF inside the image.

## Who uses Frappe CRM and why

Sales teams that want a simple, customisable CRM they can host themselves.

Frappe CRM tracks leads and deals. Each one has a single page with its activities, comments, notes and tasks, and a Kanban board shows every deal's stage.

A typical use: A small sales team tracks prospects in spreadsheets and email threads. In Frappe CRM each lead has one page with its notes, tasks and activity, and the team drags its leads and deals across its own stages on a Kanban board, so anyone can see where every deal stands.

From the upstream project's own description: https://github.com/frappe/crm.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-25 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 160 packages with copyleft licences (GPL, LGPL, MPL), 155 of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component).
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`frappe`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-25; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/frappecrm.

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

— ReadyStack · https://readystack.dev
