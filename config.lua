-- config.lua
local config = require('lapis.config')

config('development', {
  secret = os.getenv('SECRET') or 'UxNGNjv5qjbmhpbRjTnVNGknUEzBQnee',
  mysql = {
    host = os.getenv('DB_HOST') or '172.17.0.1',
    port = os.getenv('DB_PORT') or '3306',
    user = os.getenv('DB_USER') or 'lua',
    password = os.getenv('DB_PASSWORD') or '4linux',
    database = os.getenv('DB_DATABASE') or 'lua'
  }
})
