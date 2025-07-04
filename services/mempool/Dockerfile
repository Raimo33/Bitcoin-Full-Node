FROM alpine:3.22 AS builder

RUN apk add --no-cache git npm mariadb mariadb-client
RUN npm install -g typescript

WORKDIR /mempool.space

COPY backend/package*.json  ./backend/
COPY frontend/package*.json ./frontend/

RUN cd backend  && npm ci --only=production --no-audit --no-fund
RUN cd frontend && npm ci --only=production --no-audit --no-fund

COPY backend/   ./backend/
COPY frontend/  ./frontend/

RUN cd backend  && npx tsc
RUN cd frontend && NG_CLI_ANALYTICS=ci npm run build -- --configuration=production --build-optimizer --aot --optimization

COPY --chmod=755 init-db.sh  /init-db.sh
COPY mempool-schema.sql      /db-schema.sql

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql/
RUN ./init-db.sh

FROM alpine:3.22

RUN apk add --no-cache mariadb mariadb-client nginx nodejs

COPY mariadb-server.conf  /etc/my.cnf.d/mariadb-server.cnf
COPY nginx.conf           /etc/nginx/nginx.conf

COPY --from=builder /mempool.space/backend/               /mempool.space/backend/
COPY --from=builder /mempool.space/frontend/dist/mempool  /var/www/html/
COPY --from=builder /var/lib/mysql/                       /var/lib/mysql/

ENV ENV dev
ENV DB_HOST localhost
ENV DB_PORT 3306
ENV DB_USER mempool
ENV DB_PASSWORD mempool
ENV DB_DATABASE mempool
ENV API_ENDPOINT /api/v1/
ENV CHAT_SSL_ENABLED false
ENV MEMPOOL_REFRESH_RATE_MS 500
ENV INITIAL_BLOCK_AMOUNT 8
ENV DEFAULT_PROJECTED_BLOCKS_AMOUNT 3
ENV KEEP_BLOCK_AMOUNT 24
ENV BITCOIN_NODE_HOST bitcoinhost
ENV BITCOIN_NODE_PORT 8332
ENV BITCOIN_NODE_USER bitcoinuser
ENV BITCOIN_NODE_PASS bitcoinpass
ENV TX_PER_SECOND_SPAN_SECONDS 150
ENV BACKEND_API bitcoind
ENV ELECTRS_API_URL https://mempool.space/api

EXPOSE 80
WORKDIR /var/www/html

COPY --chmod=755 start.sh /start.sh
CMD ["/start.sh"]