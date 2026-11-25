# =====================================================================
# L-009 HERMETIC OFFLINE BUILD (Frappe CRM on the Frappe framework, AGPL-3.0; versions: Dockerfile.vendor ARGs). --network=none.
# Reassembles the vendored built aio filesystem onto the pinned public ubuntu:24.04 base.
# =====================================================================
# CPython 3.14.10 COMPILED HERE, offline (--network=none), from python.org's tarball (sha256 re-checked) and
# the vendored build debs, by the same command the vendor stage ran; linked against Ubuntu's libraries.
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289 AS cpython
ARG SOURCE_DATE_EPOCH=1795543294
ENV SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}
COPY vendored/frappecrm-src/python/debs/ /tmp/cpython-debs/
COPY vendored/frappecrm-src/python/Python-3.14.10.tar.xz /tmp/Python-3.14.10.tar.xz
COPY vendored/frappecrm-src/python/cpython-3.14.10-7d9da92-fips-hashlib.diff /tmp/cpython-3.14.10-7d9da92-fips-hashlib.diff
RUN set --; for f in /tmp/cpython-debs/*.deb; do [ -e "$f" ] && set -- "$@" "$f"; done; \
    for pass in 1 2 3 4 5; do [ $# -eq 0 ] || dpkg -i --skip-same-version "$@" >/dev/null 2>&1 && break; done; \
    dpkg --configure -a && bad= && for d in "$@"; do p=$(dpkg-deb -f "$d" Package) v=$(dpkg-deb -f "$d" Version); \
      case "$(dpkg-query -W -f='${Version} ${db:Status-Abbrev}' "$p" 2>/dev/null)" in "$v ii"*) ;; *) bad="$bad $p=$v" ;; esac; done && \
    { [ -z "$bad" ] || { echo "vendored debs not installed at their vendored version:$bad" >&2; false; }; } && \
    : "${SOURCE_DATE_EPOCH:?the CPython build needs SOURCE_DATE_EPOCH}" && \
    echo "de414a57119abef52784d8993e341d53aed635fc2b05c2607d9f98a2c5b72032  /tmp/Python-3.14.10.tar.xz" | sha256sum -c - && \
    mkdir -p /usr/src/python && tar -xJf /tmp/Python-3.14.10.tar.xz -C /usr/src/python --strip-components=1 --no-same-owner && \
    echo "125404bb224770a1f9120b88075b252b0536e9bc348c89a3e7fb9dd19868ed7d  /tmp/cpython-3.14.10-7d9da92-fips-hashlib.diff" | sha256sum -c - && \
    patch -p1 --no-backup-if-mismatch -d /usr/src/python -i /tmp/cpython-3.14.10-7d9da92-fips-hashlib.diff && rm -f /tmp/cpython-3.14.10-7d9da92-fips-hashlib.diff && \
    rm -rf /tmp/cpython-debs /tmp/Python-3.14.10.tar.xz && cd /usr/src/python && \
    export DEB_BUILD_MAINT_OPTIONS=optimize=-lto && \
    PYCF="$(dpkg-buildflags --get CFLAGS) $(dpkg-buildflags --get CPPFLAGS)" && PYLD="$(dpkg-buildflags --get LDFLAGS)" && \
    ./configure --build=x86_64-linux-gnu --prefix=/usr/local --enable-shared --enable-loadable-sqlite-extensions --enable-option-checking=fatal --disable-test-modules --without-static-libpython --with-ensurepip=install --with-system-expat --without-system-libmpdec --with-dbmliborder= py_cv_module__dbm=n/a py_cv_module__gdbm=n/a py_cv_module__tkinter=n/a && \
    make -j"$(nproc)" "EXTRA_CFLAGS=$PYCF" "LDFLAGS=$PYLD,--strip-all" && \
    rm python && make -j"$(nproc)" "EXTRA_CFLAGS=$PYCF" "LDFLAGS=$PYLD,--strip-all,-rpath='\$\$ORIGIN/../lib'" python && \
    make install COMPILEALL_OPTS=--invalidation-mode=checked-hash && \
    cd / && rm -rf /usr/src/python /usr/local/lib/python3.14/idlelib /usr/local/lib/python3.14/tkinter /usr/local/lib/python3.14/turtledemo /usr/local/bin/idle3* && \
    for s in pip3 pydoc3 python3 python3-config; do ln -sfT "$s" "/usr/local/bin/${s%3*}${s#*3}"; done && \
    ldconfig && /usr/local/bin/python3 -I -B -c "import ssl, sqlite3, zlib, bz2, lzma, ctypes, uuid, pyexpat, decimal, readline, curses, hashlib, compression.zstd, sys, importlib.util as u; bad = [m for m in ('_dbm', '_gdbm', '_tkinter') if u.find_spec(m)]; assert not bad, ('built but must not be', bad); print(sys.version.replace(chr(10), ' '), '|', ssl.OPENSSL_VERSION, '| sqlite', sqlite3.sqlite_version, '| expat', pyexpat.EXPAT_VERSION)" && \
    ldd /usr/local/lib/python3.14/lib-dynload/_ssl.cpython-*.so | grep -qE 'libssl.so.3 => /(usr/)?lib/x86_64-linux-gnu/' && ldd /usr/local/lib/python3.14/lib-dynload/_sqlite3.cpython-*.so | grep -qE 'libsqlite3.so.0 => /(usr/)?lib/x86_64-linux-gnu/' && ldd /usr/local/lib/python3.14/lib-dynload/pyexpat.cpython-*.so | grep -qE 'libexpat.so.1 => /(usr/)?lib/x86_64-linux-gnu/' && ldd /usr/local/lib/python3.14/lib-dynload/_ctypes.cpython-*.so | grep -qE 'libffi.so.8 => /(usr/)?lib/x86_64-linux-gnu/' && ldd /usr/local/lib/python3.14/lib-dynload/_lzma.cpython-*.so | grep -qE 'liblzma.so.5 => /(usr/)?lib/x86_64-linux-gnu/' && ldd /usr/local/lib/python3.14/lib-dynload/_bz2.cpython-*.so | grep -qE 'libbz2.so.1.0 => /(usr/)?lib/x86_64-linux-gnu/' && ldd /usr/local/lib/python3.14/lib-dynload/_uuid.cpython-*.so | grep -qE 'libuuid.so.1 => /(usr/)?lib/x86_64-linux-gnu/' && ldd /usr/local/lib/python3.14/lib-dynload/zlib.cpython-*.so | grep -qE 'libz.so.1 => /(usr/)?lib/x86_64-linux-gnu/'

# Runtime: ubuntu:24.04, digest-pinned, + the interpreter compiled above; the vendored filesystem (which no longer
# carries an interpreter) is laid over it, then site-packages, then the app.
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289
ARG SOURCE_DATE_EPOCH=1795543294
ENV LANG=C.UTF-8 PYTHONUNBUFFERED=1
COPY --from=cpython /usr/local/ /usr/local/
ADD vendored/frappecrm-src/system.tar.gz /
ADD vendored/frappecrm-src/site.tar.gz /
ADD vendored/frappecrm-src/home.tar.gz /
# nginx runtime dirs must be frappe-writable (/run is volatile / not reliably vendored).
RUN mkdir -p /run /var/lib/nginx /var/log/nginx && touch /run/nginx.pid \
    && chown -R frappe:frappe /run/nginx.pid /var/lib/nginx /var/log/nginx \
    && chmod 755 /usr/local/bin/entrypoint-aio.sh /usr/local/bin/nginx-entrypoint.sh 2>/dev/null || true
WORKDIR /home/frappe/frappe-bench
EXPOSE 8080
# pip is build-only and is stripped in the vendor stage — but a deletion does not travel in the vendored
# tarball, so a base image's own pip comes back when the tarballs are laid on top (audit 2026-09-25: the
# Debian python base's pip 25.3, CVE-2026-8643). ubuntu:24.04 carries no pip, but the strip stays as the
# guard. Also drop /home/ubuntu: the base's stock account is gone from /etc/passwd (system.tar.gz).
RUN : "${SOURCE_DATE_EPOCH:?}" && \
    rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /var/cache/ldconfig/aux-cache /var/cache/fontconfig && \
    rm -rf /usr/local/lib/python3.14/site-packages/pip /usr/local/lib/python3.14/site-packages/pip-*.dist-info \
           /usr/local/bin/pip /usr/local/bin/pip3 /usr/local/bin/pip3.14 /home/ubuntu
USER frappe
ENTRYPOINT ["/usr/local/bin/entrypoint-aio.sh"]
# >>> readystack OCI labels: strategies/frappecrm.json image_labels plus the standard OCI labels,
# the set a generated kit carries (gen_dockerfile.label_lines). Written by scripts/kit_migrations.py;
# scripts/retarget.py re-renders it with every retarget. Never edit it by hand.
LABEL org.opencontainers.image.title="Frappe CRM"
LABEL org.opencontainers.image.version="v1.90.0-CE-ubuntu24.04-r6"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"
LABEL org.opencontainers.image.source="https://github.com/frappe/crm"
LABEL org.opencontainers.image.vendor="ReadyStack.dev"
LABEL readystack.product="frappecrm"
LABEL readystack.edition="CE"
LABEL readystack.build_method="source-rebuild-python"
LABEL com.readystack.license.disclosure="This image includes Frappe CRM (https://github.com/frappe/crm), licensed under AGPL-3.0-only, on the Frappe framework (https://github.com/frappe/frappe), licensed under MIT. No modifications have been made to the Frappe CRM source code: every file of upstream's tag is in the image unchanged, beside the frontend the build compiles from it. Lean image: Chromium, wkhtmltopdf and restic are not included. Operating-system packages come from Ubuntu's archive, unmodified. ReadyStack license holders may request the build recipe via contact@readystack.dev."
LABEL org.opencontainers.image.revision="36bd8859f2a6345a620477bc708d0546e8c3f08a"
# <<< readystack OCI labels
