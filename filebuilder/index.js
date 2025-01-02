const dotenv = require("dotenv");
const fs = require("fs");
const path = require("path");

dotenv.config({ path: "../.env" });

main();

// .env variables
const ip = process.env.SOURCE_DB_IP;
const user = process.env.SOURCE_DB_USER;
const pwd = process.env.SOURCE_DB_PWD;

function main() {
  const config = loadConfig();
  console.log(config);
}

function loadConfig() {
  const configPath = path.resolve(__dirname, "../configs/db-config.json");
  return JSON.parse(fs.readFileSync(configPath, "utf8"));
}
