-- config.lua
local config = require('lapis.config')

config('development', {
  secret = 'UxNGNjv5qjbmhpbRjTnVNGknUEzBQnee',
  mysql = {
    host = '172.17.0.1',
    port = '3306',
    user = 'lua',
    password = '4linux',
    database = 'lua'
  }
})
