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

## Extending The Framework

NEX is designed to be easily extended through its module system. To create a new module:

1. Create a new file in `cfg/modules/your_module_name/`
2. Use the NEX.Class system to define your module
3. Register any events or commands related to your module
4. Return an instance of your module

The framework will automatically load your module during initialization.

## API Documentation

*Coming soon*

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
