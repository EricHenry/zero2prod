use sqlx::{Connection, PgConnection};
use std::net::TcpListener;

use zero2prod::{configuration::get_configuration, startup::run};

#[tokio::main]
async fn main() -> std::io::Result<()> {
    // panic if we can't read the conf
    let config = get_configuration().expect("Failed to read config");
    let connection = PgConnection::connect(&config.database.connection_string())
        .await
        .expect("Failed to connect to Postgres");
    let address = format!("127.0.0.1:{}", config.application_port);
    let listener = TcpListener::bind(address).expect("Failed to bind to address");
    run(listener, connection)?.await
}
