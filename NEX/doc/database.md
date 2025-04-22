-- docs/database.md
# NEX Database Module

## Overview
The `Database` module in `lib/Database.lua` provides a secure and efficient interface for MySQL operations using oxmysql. It supports asynchronous queries, batch execution, rate limiting, and permission checks.

## Features
- **Security**: Parameterized queries, input sanitization, permission-based access.
- **Performance**: Query caching, asynchronous execution, batch queries.
- **Modularity**: Loads queries from `sql/` folder, integrates with NEX RPC system.
- **Metrics**: Tracks query count, execution time, and failures.

## Usage

### Executing a Query
```lua
-- Server-side
NEX.Services.Database:ExecuteQuery(source, 'get_user', { user_id = '12345' }, function(result, err, affected)
    if err then
        print('Error:', err)
    else
        print('User Data:', json.encode(result))
    end
end)

-- Client-side
Tunnel.Call('database:execute', function(result, err)
    if err then
        print('Error:', err)
    else
        print('Result:', json.encode(result))
    end
end, 'get_user', { user_id = '12345' })