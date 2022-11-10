#[derive(serde::Deserialize)]
pub struct Settings {
    pub database: DatabaseSettings,
    pub application_port: u16,
}

#[derive(serde::Deserialize)]
pub struct DatabaseSettings {
    pub username: String,
    pub password: String,
    pub port: u16,
    pub host: String,
    pub database_name: String,
}

impl DatabaseSettings {
    pub fn connection_string(&self) -> String {
        format!(
            "postgres://{}:{}@{}:{}/{}",
            self.username, self.password, self.host, self.port, self.database_name
        )
    }
}

pub fn get_configuration() -> Result<Settings, config::ConfigError> {
    // Initialize our config reader
    let settings = config::Config::builder()
        .add_source(
            // add config values from a file names `configuration.yaml`
            config::File::new("configuration.yaml", config::FileFormat::Yaml), // TODO:: use a different file format
        )
        .build()?;

    // try to convert the config values to read into our Settings type
    settings.try_deserialize::<Settings>()
}