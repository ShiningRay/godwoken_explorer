## Docker Environment

```
GWSCAN_ENDPOINT_HOST="localhost"
GWSCAN_ENDPOINT_PORT="4001"
GWSCAN_ENDPOINT_SCHEME="http"

PG_USERNAME="postgres"
PG_PADDWORD="postgres"
PG_DATABASE="godwoken_explorer_dev"
PG_HOSTNAME="localhost"
PG_PORT="5432"
PG_SHOW_SENSITIVE_DATA_ON_CONNECTION_ERROR="false"
PG_POOL_SIZE="10"
PG_QUEUE_TARGET="5000"
PG_TIMEOUT="10000"

DATABASE_URL="ecto://postgres:postgres@localhost:5432/godwoken_explorer_dev"

# GODWOKEN_SCAN_ENDPOINT_SECRET_KEY=""
# GWSCAN_ENDPOINT_LIVE_VIEW_SIGNING_SALT=""

GWSCAN_GRAPHIQL_ON_OFF="false"
GWSCAN_BLOCK_SYNC_WORKER_ON_OFF="false"
GWSCAN_BLOCK_GLOBAL_STATE_WORKER_ON_OFF="false"
GWSCAN_BLOCK_BIND_L1_L2_WORKER_ON_OFF="false"
GWSCAN_BLOCK_SYNC_L1_BLOCK_WORKER_ON_OFF="false"

# GWSCAN_DASHBOARD_USERNAME=""
# GWSCAN_DASHBOARD_PASSWORD=""

# GODWOKEN_JSON_RPC_URL=""
# GODWOKEN_MEMPOOL_RPC_URL=""
# CKB_INDEXER_URL=""
# CKB_RPC_URL=""

GWSCAN_INTERVAL_SYNC_WORKER="10"
GWSCAN_INTERVAL_GLOBAL_STATE_WORKER="30"
GWSCAN_INTERVAL_BIND_L1_WORKER="10"
GWSCAN_INTERVAL_SYNC_DEPOSITION_WORKER="2"

# GWSCAN_SENTRY_DSN=""
# GWSCAN_SENTRY_ENVIRONMENT_NAME=""
# GWSCAN_SENTRY_ENABLE_SOURCE_CODE_CONTEXT=""
# GWSCAN_SENTRY_INCLUDED_ENVIRONMENT=""
```