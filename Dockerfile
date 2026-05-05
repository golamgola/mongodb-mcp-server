FROM node:24-alpine
ARG VERSION=latest
RUN addgroup -S mcp && adduser -S mcp -G mcp
RUN npm install -g mongodb-mcp-server@${VERSION}
USER mcp
WORKDIR /home/mcp
ENV MDB_MCP_LOGGERS=stderr,mcp
# expose the default port we will use (Cloud Run will override PORT env if provided)
EXPOSE 8081
# Use npx so the container can pick up a connection string at runtime via env var.
# Use ${PORT:-8081} so Cloud Run's $PORT is honored if set (recommended), otherwise default to 8081.
ENTRYPOINT ["sh", "-c", "exec npx -y mongodb-mcp-server --transport http --httpHost=0.0.0.0 --httpPort=${PORT:-8081} --connectionString=\"$MONGODB_CONNECTION_STRING\" --loggers stderr"]
LABEL maintainer="MongoDB Inc <info@mongodb.com>"
LABEL description="MongoDB MCP Server"
LABEL version=${VERSION}
LABEL io.modelcontextprotocol.server.name="io.github.mongodb-js/mongodb-mcp-server"
