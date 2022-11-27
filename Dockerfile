# Builder stage
FROM rust:1.65.0 as builder

WORKDIR /app
RUN apt update && apt install lld clang -y
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release

# Runtime stage
FROM rust:1.65.0-slim as runtime

# Copy the compiled binary from the bulder environment
# to our runtime environment
COPY --from=builder /app/target/release/zero2prod zero2prod
# Also need the configuration files at runtime
COPY configuration configuration
ENV APP_ENVIRONMENT production
# When `docker run` is executed, launch the binary
ENTRYPOINT ["./target/release/zero2prod"]