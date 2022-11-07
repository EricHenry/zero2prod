#!/usr/bin/env bash
set -x
set -eo pipefail

# check if a custom user has been set, otherwise default to 'postgres'
DB_USER="${POSTGRES_USER:=postgres}"
# check if a custom password has been set, otherwise default to 'password'
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"
# check if a custom database name has been set, otherwise default to 'newsletter'
DB_NAME="${POSTGRES_DB:=newsletter}"
# check of a custom port has been set, otherwise default to '5432'
DB_PORT="${POSTGRES_PORT:=5432}"

# Launch postgres using Docker
docker run \
  -e POSTGRES_USER=${DB_USER} \
  -e POSTGRES_PASSWORD=${DB_PASSWORD} \
  -e POSTGRES_DB=${DB_NAME} \
  -p "${DB_PORT}":5432 \
  -d postgres \
  postgres -N 1000
  # ^ Increased maximum number of connections for testing purposes

  # set up sqlx
  DATABASE_URL="postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}"

  export DATABASE_URL
  sqlx database create

