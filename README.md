# NEX Framework
## Overview

NEX Framework is a powerful, object-oriented development platform for FiveM servers built with performance and flexibility in mind. Leveraging the strength of Lua OOP, NEX provides server developers with a robust foundation to create immersive, dynamic gameplay experiences without the bloat of legacy systems.

Unlike conventional frameworks, NEX was designed from the ground up with modern architecture principles, offering a clean, modular approach that empowers developers to build exactly what they need. The framework provides essential core systems while maintaining exceptional performance and avoiding unnecessary overhead.

## Key Features

- **Pure Lua OOP Architecture** - Clean, maintainable code structure using proper object-oriented programming
- **Modular System** - Pick and choose which components you need, or create your own
- **Performance Focused** - Built with optimization in mind from the ground up
- **Character Management** - Comprehensive player and character handling
- **Inventory System** - Flexible item management with full metadata support
- **Database Abstraction** - Simplified data handling with support for multiple DB drivers
- **Modern UI** - Responsive user interface system based on NUI
- **Developer Tools** - Extensive debugging and development utilities

## Installation

1. Clone this repository into your FiveM resources folder
```bash
git clone https://github.com/IanisCatalin15/NEX [resource]/nex-framework
```

2. Import the database schema (once available)
```bash
mysql -u username -p database_name < nex-framework/cfg/schema.sql
```

3. Configure your database connection in `cfg/config.json`
```json
{
  "DatabaseType": "oxmysql",
  "DatabaseConnection": {
    "host": "localhost",
    "user": "yourusername",
    "password": "yourpassword",
    "database": "nex_framework"
  }
}
```

4. Add `ensure nex-framework` to your server.cfg
5. Start your server!

## Development

NEX Framework uses a class-based OOP approach in Lua. Here's a simple example of how to create a new module:

```lua
-- Example module: mymodule.lua
local MyModule = NEX.Class()

function MyModule:Init()
    print("My module initialized!")
    self.data = {}
end

function MyModule:RegisterData(key, value)
    self.data[key] = value
    return true
end

function MyModule:GetData(key)
    return self.data[key]
end

return MyModule()
```

## Extending The Framework

NEX is designed to be easily extended through its module system. To create a new module:

1. Create a new file in `cfg/modules/your_module_name/`
2. Use the NEX.Class system to define your module
3. Register any events or commands related to your module
4. Return an instance of your module

The framework will automatically load your module during initialization.

## API Documentation

*Coming soon*

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and discussions, join our Discord community (coming soon).

## Roadmap

- [ ] Complete core framework implementation
- [ ] Database schema and migrations
- [ ] Documentation and wiki
- [ ] Example modules
- [ ] Developer tools
- [ ] Performance benchmarking
- [ ] UI component library

## Credits

- **Ianis Catalin** - *Initial work and project lead* - [IanisCatalin15](https://github.com/IanisCatalin15)

## Acknowledgments

- The FiveM community
- Contributors and testers
