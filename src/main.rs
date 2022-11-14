use env_logger::Env;
use sqlx::PgPool;
use std::net::TcpListener;

use zero2prod::{configuration::get_configuration, startup::run};

#[tokio::main]
async fn main() -> std::io::Result<()> {
    // `init` calls `set_logger`, so this is all we need to do.
    // fall back to printing all logs at info-level or above
    // if the RUST_LOG env variable is not set
    env_logger::Builder::from_env(Env::default().default_filter_or("info")).init();

    // panic if we can't read the conf
    let config = get_configuration().expect("Failed to read config");
    let connection = PgPool::connect(&config.database.connection_string())
        .await
        .expect("Failed to connect to Postgres");
    let address = format!("127.0.0.1:{}", config.application_port);
    let listener = TcpListener::bind(address).expect("Failed to bind to address");
    run(listener, connection)?.await
}
