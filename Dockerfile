# Ust the latest Rust stable release as base image
FROM rust:1.65.0

# Let's switch our working directory to `app` (equivalent to `cd app`)
# The `app` folder will be created for us by Docker in case it does not
# already exist.
WORKDIR /app

# Install the required system dependencies for our linking config
RUN apt update && apt install lld clang -y

# Copy all files form our working environment to our Docker image
COPY . .

# tell sqlx to use offline mode (need to have generated `sqlx-data.json` file
ENV SQLX_OFFLINE true
# Build our binary
RUN cargo build --release

# When `docker run` is executed, launch the binary
ENTRYPOINT ["./target/release/zero2prod"]