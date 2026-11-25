#!/bin/bash
set -e
BENCH=/home/frappe/frappe-bench
cd "$BENCH"
# link baked assets into the sites volume
ASSETS_PATH="$BENCH/sites/assets"; BAKED="$BENCH/assets"
if [ ! -L "$ASSETS_PATH" ]; then rm -rf "$ASSETS_PATH"; ln -s "$BAKED" "$ASSETS_PATH"; fi
ls -1 apps > sites/apps.txt
# configurator (idempotent) from env
bench set-config -g db_host "${DB_HOST:-db}" >/dev/null 2>&1
bench set-config -gp db_port "${DB_PORT:-3306}" >/dev/null 2>&1
bench set-config -g redis_cache "redis://${REDIS_CACHE:-redis-cache:6379}" >/dev/null 2>&1
bench set-config -g redis_queue "redis://${REDIS_QUEUE:-redis-queue:6379}" >/dev/null 2>&1
bench set-config -g redis_socketio "redis://${REDIS_QUEUE:-redis-queue:6379}" >/dev/null 2>&1
bench set-config -gp socketio_port 9000 >/dev/null 2>&1
# wait for datastores
wait-for-it -t 120 "${DB_HOST:-db}:${DB_PORT:-3306}"
wait-for-it -t 120 "${REDIS_CACHE:-redis-cache:6379}"
wait-for-it -t 120 "${REDIS_QUEUE:-redis-queue:6379}"
# create the site on first boot (idempotent)
SITE="${SITE_NAME:-frontend}"
if [ ! -f "sites/$SITE/site_config.json" ]; then
  echo "First boot: creating site $SITE + installing crm..."
  # No built-in passwords (audit 2026-09-25: both fell back to 'admin'). DB_ROOT_PASSWORD is YOUR
  # MariaDB root password and is required; the Administrator password is ADMIN_PASSWORD or, when that
  # is unset, generated now and written only to sites/$SITE/initial_admin_password (mode 600).
  [ -n "${DB_ROOT_PASSWORD:-}" ] || { echo "First boot needs DB_ROOT_PASSWORD (the MariaDB root password) to create the site." >&2; exit 1; }
  ADMIN_PW="${ADMIN_PASSWORD:-}"
  GENERATED=""
  if [ -z "$ADMIN_PW" ]; then ADMIN_PW="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 24)"; GENERATED=1; fi
  bench new-site --mariadb-user-host-login-scope='%' --admin-password="$ADMIN_PW" \
    --db-root-username="${DB_ROOT_USER:-root}" --db-root-password="$DB_ROOT_PASSWORD" \
    --install-app crm --set-default "$SITE"
  if [ -n "$GENERATED" ]; then
    ( umask 077; printf '%s\n' "$ADMIN_PW" > "sites/$SITE/initial_admin_password" )
    echo "ADMIN_PASSWORD not set — generated the Administrator password into $BENCH/sites/$SITE/initial_admin_password"
  fi
  unset ADMIN_PW
  # Frappe leaves a new site's scheduler off until its setup wizard finishes, and the CRM UI never shows that
  # wizard: queued email was never sent and no scheduled job ran (held r2 review, 2026-09-30). Turn it on once,
  # here; a later `bench disable-scheduler` is the operator's choice and is never undone.
  bench --site "$SITE" enable-scheduler
  # Optional fixed demo API key for Administrator — ONLY when DEMO_API_KEY is set (the pipeline
  # sets it to validate the auth-gated API; customers do NOT set it, so no key is baked in prod).
  if [ -n "$DEMO_API_KEY" ]; then
    DK="${DEMO_API_KEY%%:*}"; DS="${DEMO_API_KEY#*:}"
    bench --site "$SITE" console >/dev/null 2>&1 <<PYEOF2 || true
import frappe
u = frappe.get_doc("User","Administrator")
u.api_key = "$DK"; u.api_secret = "$DS"
u.save(ignore_permissions=True); frappe.db.commit()
PYEOF2
  fi
fi
# Persist the site's encryption key before the web workers start. Frappe creates it on first use, and each
# gunicorn worker that finds none writes its own: an API secret saved in that window was encrypted with a key that
# lost the race, and token/Basic auth then failed for it for good (shipped erpnext v16.36.0-r2, 3 of 3 runs).
if ! grep -q '"encryption_key"' "sites/$SITE/site_config.json" 2>/dev/null; then
  bench --site "$SITE" execute frappe.utils.password.get_encryption_key >/dev/null
fi
echo "Starting all Frappe services under supervisord..."
exec supervisord -c /etc/supervisor/frappe.conf -n
