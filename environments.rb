require 'zlib'

configure :development do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/messages_development')
  pool = ENV["DB_POOL"] || ENV['MAX_THREADS'] || 5
  ActiveRecord::Base.establish_connection(
      adapter:  db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      host:      db.host,
      username:  'Messages',
      password:  'messages',
      database:  db.path[1..-1],
      encoding:  'utf8',
      pool:      pool
  )
end

configure :test do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/messages_test')
  pool = ENV["DB_POOL"] || ENV['MAX_THREADS'] || 5
  ActiveRecord::Base.establish_connection(
      adapter:  db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      host:      db.host,
      username:  'Messages',
      password:  'messages',
      database:  db.path[1..-1],
      encoding:  'utf8',
      pool:      pool
  )
end